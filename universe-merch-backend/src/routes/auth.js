import express from 'express';
import { query } from '../utils/db.js';
import { hashPassword, comparePassword } from '../utils/crypto.js';
import { generateToken, verifyToken } from '../utils/jwt.js';
import { signupSchema, loginSchema, updateProfileSchema } from '../utils/validation.js';
import { validateSchema } from '../middleware/validation.js';
import { authenticate, requireAuth } from '../middleware/auth.js';
import { sendWelcomeEmail } from '../services/email.js';

const router = express.Router();

// POST /api/auth/signup
router.post('/signup', validateSchema(signupSchema), async (req, res, next) => {
  try {
    const { email, password, first_name, last_name, phone, school_id } = req.validated;

    // Check if user exists
    const existingUser = await query('SELECT id FROM users WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(409).json({ error: 'Email already registered' });
    }

    // Hash password
    const password_hash = await hashPassword(password);

    // Create user
    const result = await query(
      `INSERT INTO users (email, password_hash, first_name, last_name, phone, school_id)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING id, email, first_name, last_name, phone, school_id, created_at`,
      [email, password_hash, first_name, last_name, phone || null, school_id || null]
    );

    const user = result.rows[0];

    // Generate JWT
    const token = generateToken({ id: user.id, email: user.email });

    // Send welcome email
    await sendWelcomeEmail(user);

    // Create empty cart
    await query(
      `INSERT INTO carts (user_id) VALUES ($1)`,
      [user.id]
    );

    res.status(201).json({
      message: 'Signup successful',
      user: {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        phone: user.phone,
        school_id: user.school_id,
      },
      token,
    });
  } catch (error) {
    next(error);
  }
});

// POST /api/auth/login
router.post('/login', validateSchema(loginSchema), async (req, res, next) => {
  try {
    const { email, password } = req.validated;

    // Find user
    const result = await query('SELECT * FROM users WHERE email = $1', [email]);
    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const user = result.rows[0];

    // Verify password
    const isValid = await comparePassword(password, user.password_hash);
    if (!isValid) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    // Generate JWT
    const token = generateToken({ id: user.id, email: user.email });

    res.json({
      message: 'Login successful',
      user: {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        phone: user.phone,
        school_id: user.school_id,
      },
      token,
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/auth/me
router.get('/me', authenticate, requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT id, email, first_name, last_name, phone, school_id, email_verified, created_at
       FROM users WHERE id = $1`,
      [req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

// PATCH /api/auth/me
router.patch('/me', authenticate, requireAuth, validateSchema(updateProfileSchema), async (req, res, next) => {
  try {
    const { first_name, last_name, phone, school_id } = req.validated;

    const updates = [];
    const values = [];
    let paramIndex = 1;

    if (first_name) {
      updates.push(`first_name = $${paramIndex++}`);
      values.push(first_name);
    }
    if (last_name) {
      updates.push(`last_name = $${paramIndex++}`);
      values.push(last_name);
    }
    if (phone) {
      updates.push(`phone = $${paramIndex++}`);
      values.push(phone);
    }
    if (school_id) {
      updates.push(`school_id = $${paramIndex++}`);
      values.push(school_id);
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'No fields to update' });
    }

    values.push(req.user.id);

    const result = await query(
      `UPDATE users SET ${updates.join(', ')} WHERE id = $${paramIndex}
       RETURNING id, email, first_name, last_name, phone, school_id`,
      values
    );

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

// PATCH /api/auth/password - Change password
router.patch('/password', authenticate, requireAuth, async (req, res, next) => {
  try {
    const { current_password, new_password } = req.body;

    if (!current_password || !new_password) {
      return res.status(400).json({ error: 'Current password and new password are required' });
    }

    if (new_password.length < 6) {
      return res.status(400).json({ error: 'New password must be at least 6 characters' });
    }

    // Get user
    const result = await query('SELECT * FROM users WHERE id = $1', [req.user.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = result.rows[0];

    // Verify current password
    const isValid = await comparePassword(current_password, user.password_hash);
    if (!isValid) {
      return res.status(401).json({ error: 'Current password is incorrect' });
    }

    // Hash new password
    const new_password_hash = await hashPassword(new_password);

    // Update password
    await query(
      'UPDATE users SET password_hash = $1 WHERE id = $2',
      [new_password_hash, req.user.id]
    );

    res.json({ message: 'Password updated successfully' });
  } catch (error) {
    next(error);
  }
});

export default router;
