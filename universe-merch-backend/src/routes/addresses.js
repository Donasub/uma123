import express from 'express';
import { query } from '../utils/db.js';
import { authenticate, requireAuth } from '../middleware/auth.js';
import { addressSchema } from '../utils/validation.js';
import { validateSchema } from '../middleware/validation.js';

const router = express.Router();

// GET /api/addresses - Get user addresses
router.get('/', authenticate, requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT id, type, label, address, city, state, postal_code, phone, is_default
       FROM addresses WHERE user_id = $1 ORDER BY is_default DESC, created_at DESC`,
      [req.user.id]
    );

    res.json(result.rows);
  } catch (error) {
    next(error);
  }
});

// POST /api/addresses - Create new address
router.post('/', authenticate, requireAuth, validateSchema(addressSchema), async (req, res, next) => {
  try {
    const { type, label, address, city, state, postal_code, phone, is_default } = req.validated;

    // If setting as default, unset other defaults
    if (is_default) {
      await query(
        'UPDATE addresses SET is_default = FALSE WHERE user_id = $1',
        [req.user.id]
      );
    }

    const result = await query(
      `INSERT INTO addresses (user_id, type, label, address, city, state, postal_code, phone, is_default)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING id, type, label, address, city, state, postal_code, phone, is_default`,
      [req.user.id, type, label || null, address, city, state, postal_code || null, phone || null, is_default || false]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

// PATCH /api/addresses/:id - Update address
router.patch('/:id', authenticate, requireAuth, validateSchema(addressSchema.partial()), async (req, res, next) => {
  try {
    const { id } = req.params;
    const { type, label, address, city, state, postal_code, phone, is_default } = req.validated;

    // Verify ownership
    const existing = await query('SELECT id FROM addresses WHERE id = $1 AND user_id = $2', [id, req.user.id]);
    if (existing.rows.length === 0) {
      return res.status(404).json({ error: 'Address not found' });
    }

    // If setting as default, unset other defaults
    if (is_default) {
      await query(
        'UPDATE addresses SET is_default = FALSE WHERE user_id = $1 AND id != $2',
        [req.user.id, id]
      );
    }

    const updates = [];
    const values = [];
    let paramIndex = 1;

    if (type !== undefined) {
      updates.push(`type = $${paramIndex++}`);
      values.push(type);
    }
    if (label !== undefined) {
      updates.push(`label = $${paramIndex++}`);
      values.push(label);
    }
    if (address !== undefined) {
      updates.push(`address = $${paramIndex++}`);
      values.push(address);
    }
    if (city !== undefined) {
      updates.push(`city = $${paramIndex++}`);
      values.push(city);
    }
    if (state !== undefined) {
      updates.push(`state = $${paramIndex++}`);
      values.push(state);
    }
    if (postal_code !== undefined) {
      updates.push(`postal_code = $${paramIndex++}`);
      values.push(postal_code);
    }
    if (phone !== undefined) {
      updates.push(`phone = $${paramIndex++}`);
      values.push(phone);
    }
    if (is_default !== undefined) {
      updates.push(`is_default = $${paramIndex++}`);
      values.push(is_default);
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'No fields to update' });
    }

    values.push(id);
    const result = await query(
      `UPDATE addresses SET ${updates.join(', ')} WHERE id = $${paramIndex}
       RETURNING id, type, label, address, city, state, postal_code, phone, is_default`,
      values
    );

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

// DELETE /api/addresses/:id - Delete address
router.delete('/:id', authenticate, requireAuth, async (req, res, next) => {
  try {
    const { id } = req.params;

    const result = await query(
      'DELETE FROM addresses WHERE id = $1 AND user_id = $2 RETURNING id',
      [id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Address not found' });
    }

    res.json({ message: 'Address deleted successfully' });
  } catch (error) {
    next(error);
  }
});

export default router;