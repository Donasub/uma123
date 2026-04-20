import express from 'express';
import { query } from '../utils/db.js';
import { authenticate, getOrCreateCart } from '../middleware/auth.js';
import { addToCartSchema, updateCartItemSchema } from '../utils/validation.js';
import { validateSchema } from '../middleware/validation.js';

const router = express.Router();

// Helper: Get or create cart
const getCart = async (userId, sessionId) => {
  let result;
  if (userId) {
    result = await query('SELECT id FROM carts WHERE user_id = $1', [userId]);
  } else {
    result = await query('SELECT id FROM carts WHERE session_id = $1', [sessionId]);
  }

  if (result.rows.length === 0) {
    const createResult = await query(
      'INSERT INTO carts (user_id, session_id) VALUES ($1, $2) RETURNING id',
      [userId || null, sessionId || null]
    );
    return createResult.rows[0].id;
  }

  return result.rows[0].id;
};

// GET /api/cart
router.get('/', authenticate, getOrCreateCart, async (req, res, next) => {
  try {
    const cartId = await getCart(req.user?.id, req.sessionId);

    const result = await query(
      `SELECT ci.id, ci.variant_id, ci.quantity, 
              p.id as product_id, p.sku, p.name, p.price, p.image_url,
              pv.size, pv.color, pv.stock_count
       FROM cart_items ci
       JOIN product_variants pv ON ci.variant_id = pv.id
       JOIN products p ON pv.product_id = p.id
       WHERE ci.cart_id = $1
       ORDER BY ci.created_at ASC`,
      [cartId]
    );

    const items = result.rows;
    const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

    res.json({
      cart_id: cartId,
      items,
      subtotal,
      item_count: items.length,
    });
  } catch (error) {
    next(error);
  }
});

// POST /api/cart/items
router.post('/items', authenticate, getOrCreateCart, validateSchema(addToCartSchema), async (req, res, next) => {
  try {
    const { variant_id, quantity } = req.validated;

    // Verify variant exists and has stock
    const variantResult = await query(
      'SELECT id, stock_count FROM product_variants WHERE id = $1',
      [variant_id]
    );

    if (variantResult.rows.length === 0) {
      return res.status(404).json({ error: 'Product variant not found' });
    }

    if (variantResult.rows[0].stock_count < quantity) {
      return res.status(400).json({ error: 'Insufficient stock' });
    }

    const cartId = await getCart(req.user?.id, req.sessionId);

    // Check if item already in cart
    const existingResult = await query(
      'SELECT id, quantity FROM cart_items WHERE cart_id = $1 AND variant_id = $2',
      [cartId, variant_id]
    );

    let cartItem;
    if (existingResult.rows.length > 0) {
      // Update quantity
      const newQuantity = existingResult.rows[0].quantity + quantity;
      const updateResult = await query(
        'UPDATE cart_items SET quantity = $1 WHERE id = $2 RETURNING id, variant_id, quantity',
        [newQuantity, existingResult.rows[0].id]
      );
      cartItem = updateResult.rows[0];
    } else {
      // Create new cart item
      const insertResult = await query(
        'INSERT INTO cart_items (cart_id, variant_id, quantity) VALUES ($1, $2, $3) RETURNING id, variant_id, quantity',
        [cartId, variant_id, quantity]
      );
      cartItem = insertResult.rows[0];
    }

    res.status(201).json({
      message: 'Item added to cart',
      cart_item: cartItem,
    });
  } catch (error) {
    next(error);
  }
});

// PATCH /api/cart/items/:id
router.patch('/items/:id', authenticate, getOrCreateCart, validateSchema(updateCartItemSchema), async (req, res, next) => {
  try {
    const { id } = req.params;
    const { quantity } = req.validated;

    const cartId = await getCart(req.user?.id, req.sessionId);

    // Verify item belongs to cart
    const itemResult = await query(
      'SELECT variant_id FROM cart_items WHERE id = $1 AND cart_id = $2',
      [id, cartId]
    );

    if (itemResult.rows.length === 0) {
      return res.status(404).json({ error: 'Cart item not found' });
    }

    // Verify stock
    const variant_id = itemResult.rows[0].variant_id;
    const variantResult = await query(
      'SELECT stock_count FROM product_variants WHERE id = $1',
      [variant_id]
    );

    if (variantResult.rows[0].stock_count < quantity) {
      return res.status(400).json({ error: 'Insufficient stock' });
    }

    // Update quantity
    const result = await query(
      'UPDATE cart_items SET quantity = $1 WHERE id = $2 RETURNING id, variant_id, quantity',
      [quantity, id]
    );

    res.json({
      message: 'Cart item updated',
      cart_item: result.rows[0],
    });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/cart/items/:id
router.delete('/items/:id', authenticate, getOrCreateCart, async (req, res, next) => {
  try {
    const { id } = req.params;

    const cartId = await getCart(req.user?.id, req.sessionId);

    const result = await query(
      'DELETE FROM cart_items WHERE id = $1 AND cart_id = $2',
      [id, cartId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Cart item not found' });
    }

    res.json({ message: 'Item removed from cart' });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/cart
router.delete('/', authenticate, getOrCreateCart, async (req, res, next) => {
  try {
    const cartId = await getCart(req.user?.id, req.sessionId);

    await query('DELETE FROM cart_items WHERE cart_id = $1', [cartId]);

    res.json({ message: 'Cart cleared' });
  } catch (error) {
    next(error);
  }
});

export default router;
