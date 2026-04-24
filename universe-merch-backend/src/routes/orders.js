import express from 'express';
import { query, getClient, DB_TYPE } from '../utils/db.js';
import { authenticate, getOrCreateCart } from '../middleware/auth.js';
import { checkoutSchema, paymentWebhookSchema } from '../utils/validation.js';
import { validateSchema } from '../middleware/validation.js';
import { SHIPPING_COSTS, VAT_RATE } from '../utils/constants.js';
import { sendOrderConfirmationEmail } from '../services/email.js';

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

// POST /api/orders (Checkout)
router.post('/', authenticate, getOrCreateCart, validateSchema(checkoutSchema), async (req, res, next) => {
  const client = await getClient();

  try {
    const {
      first_name, last_name, email, phone,
      delivery_method, delivery_address, delivery_city, delivery_state, delivery_notes,
      payment_method, items
    } = req.validated;

    const cartId = await getCart(req.user?.id, req.sessionId);

    // Start transaction
    await client.query('BEGIN');

    // Validate and lock variants
    const validatedItems = [];
    let subtotal = 0;

    for (const item of items) {
      // Lock and verify stock
      const variantResult = await client.query(
        'SELECT pv.id, pv.stock_count, p.id as product_id, p.sku, p.name, p.price, p.image_url FROM product_variants pv JOIN products p ON pv.product_id = p.id WHERE pv.id = $1 FOR UPDATE',
        [item.variant_id]
      );

      if (variantResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ error: 'Product variant not found' });
      }

      const variant = variantResult.rows[0];
      if (variant.stock_count < item.quantity) {
        await client.query('ROLLBACK');
        return res.status(400).json({ error: `Insufficient stock for ${variant.name}` });
      }

      const itemTotal = variant.price * item.quantity;
      subtotal += itemTotal;

      validatedItems.push({
        ...item,
        product_id: variant.product_id,
        sku: variant.sku,
        name: variant.name,
        price: variant.price,
        image_url: variant.image_url,
      });
    }

    // Calculate totals
    const shipping_cost = SHIPPING_COSTS[delivery_method] || 0;
    const vat = subtotal * VAT_RATE;
    const total_amount = subtotal + shipping_cost + vat;

    // Generate order number
    let order_number;
    if (DB_TYPE === 'sqlite') {
      order_number = `UMA-${new Date().getFullYear()}-${Math.floor(Math.random() * 90000) + 10000}`;
    } else {
      const sequenceResult = await client.query(
        'SELECT generate_order_number() as order_number'
      );
      order_number = sequenceResult.rows[0].order_number;
    }

    // Create order
    const orderResult = await client.query(
      `INSERT INTO orders (
        order_number, user_id, first_name, last_name, email, phone,
        delivery_method, delivery_address, delivery_city, delivery_state, delivery_notes,
        payment_method, payment_status, subtotal, shipping_cost, vat, total_amount, order_status
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)
      RETURNING id, order_number, created_at`,
      [
        order_number, req.user?.id || null, first_name, last_name, email, phone,
        delivery_method, delivery_address || null, delivery_city || null, delivery_state || null, delivery_notes || null,
        payment_method, 'pending', subtotal, shipping_cost, vat, total_amount, 'pending'
      ]
    );

    const order = orderResult.rows[0];

    // Create order items
    for (const item of validatedItems) {
      await client.query(
        `INSERT INTO order_items (order_id, product_id, variant_id, name, sku, size, color, price, quantity, image_url)
         SELECT $1, $2, pv.id, p.name, p.sku, pv.size, pv.color, p.price, $3, p.image_url
         FROM product_variants pv
         JOIN products p ON pv.product_id = p.id
         WHERE pv.id = $4`,
        [order.id, item.product_id, item.quantity, item.variant_id]
      );

      // Decrement stock
      await client.query(
        'UPDATE product_variants SET stock_count = stock_count - $1 WHERE id = $2',
        [item.quantity, item.variant_id]
      );
    }

    // Clear cart
    await client.query('DELETE FROM cart_items WHERE cart_id = $1', [cartId]);

    // Commit transaction
    await client.query('COMMIT');

    // Get order items for email
    const orderItemsResult = await query(
      'SELECT name, size, color, price, quantity FROM order_items WHERE order_id = $1',
      [order.id]
    );

    // Send confirmation email
    await sendOrderConfirmationEmail(
      {
        order_number: order.order_number,
        first_name,
        last_name,
        email,
        phone,
        delivery_method,
        delivery_address,
        delivery_city,
        delivery_state,
        delivery_notes,
        payment_method,
        subtotal,
        shipping_cost,
        vat,
        total_amount,
        payment_status: 'pending',
        created_at: order.created_at,
      },
      orderItemsResult.rows
    );

    res.status(201).json({
      message: 'Order created successfully',
      order: {
        id: order.id,
        order_number: order.order_number,
        total_amount,
        payment_method,
        payment_status: 'pending',
      },
    });
  } catch (error) {
    try {
      await client.query('ROLLBACK');
    } catch (rollbackError) {
      console.error('Rollback error:', rollbackError);
    }
    next(error);
  } finally {
    client.release();
  }
});

// GET /api/orders (User order history)
router.get('/', authenticate, async (req, res, next) => {
  try {
    if (!req.user) {
      return res.status(401).json({ error: 'Authentication required' });
    }

    const result = await query(
      `SELECT id, order_number, subtotal, shipping_cost, vat, total_amount, 
              payment_status, order_status, delivery_method, created_at
       FROM orders WHERE user_id = $1 ORDER BY created_at DESC`,
      [req.user.id]
    );

    res.json(result.rows);
  } catch (error) {
    next(error);
  }
});

// GET /api/orders/by-number/:orderNumber (Track any order)
router.get('/by-number/:orderNumber', async (req, res, next) => {
  try {
    const { orderNumber } = req.params;

    const orderResult = await query(
      `SELECT id, order_number, first_name, last_name, email, phone,
              delivery_method, delivery_address, delivery_city, delivery_state,
              subtotal, shipping_cost, vat, total_amount, payment_status, order_status, created_at
       FROM orders WHERE order_number = $1`,
      [orderNumber]
    );

    if (orderResult.rows.length === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }

    const order = orderResult.rows[0];

    const itemsResult = await query(
      `SELECT name, sku, size, color, price, quantity, image_url
       FROM order_items WHERE order_id = $1`,
      [order.id]
    );

    res.json({
      order,
      items: itemsResult.rows,
    });
  } catch (error) {
    next(error);
  }
});

// POST /api/orders/:orderNumber/payment-webhook (Payment gateway callback)
router.post('/:orderNumber/payment-webhook', validateSchema(paymentWebhookSchema), async (req, res, next) => {
  try {
    const { orderNumber } = req.params;
    const { status, payment_reference, amount } = req.validated;

    // TODO: Verify Paystack webhook signature
    // const signature = req.headers['x-paystack-signature'];
    // const hash = crypto.createHmac('sha512', process.env.PAYSTACK_SECRET_KEY)
    //   .update(JSON.stringify(req.body))
    //   .digest('hex');
    // if (hash !== signature) {
    //   return res.status(401).json({ error: 'Invalid signature' });
    // }

    // Update order status
    if (status === 'paid') {
      await query(
        'UPDATE orders SET payment_status = $1, order_status = $2, payment_reference = $3 WHERE order_number = $4',
        ['paid', 'confirmed', payment_reference || null, orderNumber]
      );
    } else if (status === 'failed') {
      await query(
        'UPDATE orders SET payment_status = $1, payment_reference = $2 WHERE order_number = $3',
        ['failed', payment_reference || null, orderNumber]
      );
    }

    res.json({ message: 'Webhook processed successfully' });
  } catch (error) {
    next(error);
  }
});

export default router;
