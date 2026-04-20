import express from 'express';
import { query } from '../utils/db.js';

const router = express.Router();

// GET /api/products
router.get('/', async (req, res, next) => {
  try {
    const { featured, new_drop, category, sort } = req.query;

    let sql = 'SELECT id, sku, name, description, price, image_url, category, is_featured, is_new_drop, rating_avg, rating_count FROM products WHERE 1=1';
    const params = [];
    let paramIndex = 1;

    if (featured === 'true') {
      sql += ` AND is_featured = true`;
    }

    if (new_drop === 'true') {
      sql += ` AND is_new_drop = true`;
    }

    if (category) {
      sql += ` AND category = $${paramIndex++}`;
      params.push(category);
    }

    // Sorting
    if (sort === 'price_asc') {
      sql += ' ORDER BY price ASC';
    } else if (sort === 'price_desc') {
      sql += ' ORDER BY price DESC';
    } else if (sort === 'newest') {
      sql += ' ORDER BY created_at DESC';
    } else if (sort === 'popular') {
      sql += ' ORDER BY rating_avg DESC, rating_count DESC';
    } else {
      sql += ' ORDER BY name ASC';
    }

    const result = await query(sql, params);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
});

// GET /api/products/:id
router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    const result = await query(
      `SELECT p.id, p.sku, p.name, p.description, p.price, p.image_url, p.category,
              p.is_featured, p.is_new_drop, p.rating_avg, p.rating_count, s.name as school_name
       FROM products p
       LEFT JOIN schools s ON p.school_id = s.id
       WHERE p.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }

    const product = result.rows[0];

    // Get variants
    const variantsResult = await query(
      'SELECT id, size, color, stock_count FROM product_variants WHERE product_id = $1 ORDER BY size, color',
      [id]
    );

    res.json({
      ...product,
      variants: variantsResult.rows,
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/products/meta/categories
router.get('/meta/categories', async (req, res, next) => {
  try {
    const result = await query(
      'SELECT DISTINCT category FROM products WHERE category IS NOT NULL ORDER BY category'
    );

    res.json({
      categories: result.rows.map(r => r.category),
    });
  } catch (error) {
    next(error);
  }
});

export default router;
