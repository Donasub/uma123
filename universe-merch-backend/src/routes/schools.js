import express from 'express';
import { query } from '../utils/db.js';

const router = express.Router();

// GET /api/schools
router.get('/', async (req, res, next) => {
  try {
    const { type } = req.query;

    let sql = `
      SELECT s.id, s.code, s.name, s.type, s.city, s.state, s.region,
             s.crest_color_primary, s.crest_color_secondary, s.logo_url,
             COUNT(DISTINCT p.id) AS products_count
      FROM schools s
      LEFT JOIN products p ON s.id = p.school_id
    `;
    const params = [];

    if (type) {
      sql += ' WHERE s.type = $1';
      params.push(type);
    }

    sql += ' GROUP BY s.id ORDER BY s.name ASC';

    const result = await query(sql, params);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
});

// GET /api/schools/:codeOrId
router.get('/:codeOrId', async (req, res, next) => {
  try {
    const { codeOrId } = req.params;

    // Try to find by code first (more common), then by ID
    let result = await query(
      'SELECT id, code, name, type, city, state, region, crest_color_primary, crest_color_secondary, logo_url, description FROM schools WHERE code = $1',
      [codeOrId]
    );

    if (result.rows.length === 0) {
      result = await query(
        'SELECT id, code, name, type, city, state, region, crest_color_primary, crest_color_secondary, logo_url, description FROM schools WHERE id = $1',
        [codeOrId]
      );
    }

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'School not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

// GET /api/schools/:codeOrId/products
router.get('/:codeOrId/products', async (req, res, next) => {
  try {
    const { codeOrId } = req.params;
    const { category, size, color, sort } = req.query;

    // Find school
    let schoolResult = await query(
      'SELECT id, code, name, type, city, state, crest_color_primary, crest_color_secondary, logo_url, description FROM schools WHERE code = $1 OR id = $1',
      [codeOrId]
    );
    if (schoolResult.rows.length === 0) {
      return res.status(404).json({ error: 'School not found' });
    }

    const schoolId = schoolResult.rows[0].id;

    // Build products query
    let sql = `
      SELECT DISTINCT p.id, p.sku, p.name, p.description, p.price, p.image_url, 
             p.category, p.is_featured, p.is_new_drop, p.rating_avg, p.rating_count
      FROM products p
      JOIN product_variants pv ON p.id = pv.product_id
      WHERE p.school_id = $1
    `;
    const params = [schoolId];
    let paramIndex = 2;

    if (category) {
      sql += ` AND p.category = $${paramIndex++}`;
      params.push(category);
    }

    if (size) {
      sql += ` AND pv.size = $${paramIndex++}`;
      params.push(size);
    }

    if (color) {
      sql += ` AND pv.color = $${paramIndex++}`;
      params.push(color);
    }

    // Sorting
    if (sort === 'price_asc') {
      sql += ' ORDER BY p.price ASC';
    } else if (sort === 'price_desc') {
      sql += ' ORDER BY p.price DESC';
    } else if (sort === 'newest') {
      sql += ' ORDER BY p.created_at DESC';
    } else if (sort === 'popular') {
      sql += ' ORDER BY p.rating_avg DESC, p.rating_count DESC';
    } else {
      sql += ' ORDER BY p.name ASC';
    }

    const result = await query(sql, params);

    // Get all variants for each product
    const productsWithVariants = await Promise.all(
      result.rows.map(async (product) => {
        const variantsResult = await query(
          'SELECT id, size, color, stock_count FROM product_variants WHERE product_id = $1 ORDER BY size, color',
          [product.id]
        );
        return {
          ...product,
          variants: variantsResult.rows,
        };
      })
    );

    res.json({
      school: schoolResult.rows[0],
      products: productsWithVariants,
    });
  } catch (error) {
    next(error);
  }
});

export default router;
