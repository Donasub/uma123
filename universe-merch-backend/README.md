# Universe Merch Africa - Backend

Production-ready Node.js + PostgreSQL backend for the Universe Merch Africa campus merchandise marketplace.

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

Key variables to set:
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - Long random string for JWT signing
- `EMAIL_*` - SMTP credentials for email sending
- `PAYSTACK_*` - Payment gateway keys

### 3. Set Up Database

**Local PostgreSQL:**
```bash
createdb universe_merch
npm run db:schema
npm run db:seed
```

**Supabase (recommended):**
1. Create project at supabase.com
2. Copy Connection string to `.env`
3. Run schema and seed via SQL Editor in dashboard

### 4. Start Development Server

```bash
npm run dev
```

Server will start at `http://localhost:4000`

Test it:
```bash
curl http://localhost:4000/api/health
curl http://localhost:4000/api/schools
```

## 📋 Project Structure

```
src/
  ├── server.js              # Express app setup
  ├── routes/
  │   ├── auth.js            # Authentication endpoints
  │   ├── schools.js         # Schools listing & filtering
  │   ├── products.js        # Products catalog
  │   ├── cart.js            # Shopping cart operations
  │   └── orders.js          # Order checkout & tracking
  ├── middleware/
  │   ├── auth.js            # JWT authentication
  │   ├── validation.js      # Request validation
  │   └── errors.js          # Error handling
  ├── services/
  │   └── email.js           # Email sending (Nodemailer)
  └── utils/
      ├── db.js              # Database connection pool
      ├── jwt.js             # JWT generation/verification
      ├── validation.js      # Zod schemas
      ├── constants.js       # App constants
      └── crypto.js          # Password hashing, tokens

sql/
  ├── 01_schema.sql          # Database schema
  └── 02_seed.sql            # Initial data (40 schools, products)

public/
  └── uma-client.js          # Frontend integration script

.env.example                  # Environment variables template
```

## 🔐 Authentication

The API uses JWT tokens. After signup/login, store the token and include it in requests:

```
Authorization: Bearer <token>
```

For guest operations (cart, checkout), use session ID header:

```
X-Session-Id: <any-string>
```

## 💳 Payments

The API is ready for Paystack integration. When a customer completes payment:

1. Paystack calls `POST /api/orders/:orderNumber/payment-webhook`
2. Backend marks order as `paid` and updates status to `confirmed`

Currently, webhook signature verification is commented out. Add it for production:

```javascript
const crypto = require('crypto');
const hash = crypto.createHmac('sha512', process.env.PAYSTACK_SECRET_KEY)
  .update(JSON.stringify(req.body))
  .digest('hex');
if (hash !== req.headers['x-paystack-signature']) {
  return res.status(401).json({ error: 'Invalid signature' });
}
```

## 📊 Database Schema

- **users** — student accounts (bcrypt hashed passwords, JWT tokens)
- **schools** — 20 universities + 20 high schools, with branding colors
- **products** — per-school storefronts
- **product_variants** — size/color combinations with stock counts
- **carts** — per-user or per-session
- **cart_items** — cart line items with quantity tracking
- **orders** — completed orders with full item snapshots
- **order_items** — individual items in each order

All tables include `created_at` / `updated_at` timestamps.

## 🧪 Testing the API

### 1. Sign up a student

```bash
curl -X POST http://localhost:4000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email":"test@example.com",
    "password":"testpass123",
    "first_name":"Test",
    "last_name":"Student",
    "phone":"08012345678",
    "school_id":"<uuid-from-schools>"
  }'
```

### 2. Browse schools

```bash
curl http://localhost:4000/api/schools
curl http://localhost:4000/api/schools?type=university
curl http://localhost:4000/api/schools/UL  # UNILAG
```

### 3. Browse products for a school

```bash
curl http://localhost:4000/api/schools/UL/products
curl "http://localhost:4000/api/schools/UL/products?category=hoodies&sort=price_asc"
```

### 4. Add to cart

```bash
curl -X POST http://localhost:4000/api/cart/items \
  -H "Content-Type: application/json" \
  -H "X-Session-Id: test-session" \
  -d '{"variant_id":"<uuid>","quantity":2}'
```

### 5. Checkout

```bash
curl -X POST http://localhost:4000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "first_name":"Test",
    "last_name":"Student",
    "email":"test@example.com",
    "phone":"08012345678",
    "delivery_method":"campus_pickup",
    "payment_method":"card",
    "items":[{"variant_id":"<uuid>","quantity":1}]
  }'
```

## 🚢 Deploying to Production

### Render.com (Recommended)

1. Push to GitHub
2. Go to render.com → New → Web Service
3. Connect your repo
4. Set Build: `npm install` / Start: `npm start`
5. Add all `.env` variables to Environment
6. Deploy → get URL like `https://universe-merch.onrender.com`

### Railway / Fly.io

Similar process - both have simple one-click Postgres setup.

### Environment Variables for Production

- `NODE_ENV=production`
- `DATABASE_URL=postgresql://...` (use cloud provider)
- `JWT_SECRET=<long-random-string-32+chars>`
- `EMAIL_*=...` (use Resend or similar for production reliability)
- `PAYSTACK_PUBLIC_KEY` and `PAYSTACK_SECRET_KEY`
- `FRONTEND_URL=https://universemerch.vercel.app` (your Vercel domain)
- `CORS_ORIGIN=https://universemerch.vercel.app` (tighten CORS)

## 📧 Email Configuration

### Gmail (Development)

1. Enable 2FA on your Google account
2. Create an [App Password](https://myaccount.google.com/apppasswords)
3. Set in `.env`:

```
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your@gmail.com
EMAIL_PASS=your_16_char_app_password
```

### Resend (Production Recommended)

1. Sign up at resend.com
2. Verify your domain
3. Create API key
4. Use with Nodemailer:

```
EMAIL_HOST=smtp.resend.com
EMAIL_PORT=587
EMAIL_USER=resend
EMAIL_PASS=your_resend_api_key
```

## 🛠️ Troubleshooting

| Issue | Fix |
|-------|-----|
| `ECONNREFUSED` | Check Postgres is running: `psql -U postgres -c "SELECT 1"` |
| `ssl required` error on Supabase/Neon | Add `PGSSLMODE=require` to `.env` |
| Emails not sending | Verify Gmail app password or Resend API key |
| `401 Invalid token` | JWT expired (7 days default) — re-login |
| CORS errors in browser | Add your frontend URL to `CORS_ORIGIN` in `.env` |

## 🔒 Security

- ✅ Passwords hashed with bcrypt (cost 12)
- ✅ Transactions on checkout prevent overselling
- ✅ JWT signed with secret (keep long & random)
- ✅ Rate limiting on auth endpoints (20/15min) and general API (120/min)
- ✅ Zod validation on every endpoint
- ✅ Parameterized queries (SQL injection safe)
- ✅ CORS configured
- ✅ Helmet security headers

For production, also add:
- Paystack webhook signature verification
- Email verification before first order
- Password reset flow
- Admin dashboard
- Input sanitization
- HTTPS only
- Secure cookies

## 📚 Frontend Integration

Copy `public/uma-client.js` to your frontend and include on every page:

```html
<script src="/uma-client.js"></script>
<script>
  UMA.init({ apiUrl: 'https://YOUR-API.onrender.com/api' });
</script>
```

Then use:

```javascript
// Auth
await UMA.auth.signup({ email, password, first_name, last_name, school_id });
await UMA.auth.login(email, password);
const user = UMA.auth.getCurrentUser();

// Schools & Products
const schools = await UMA.schools.list({ type: 'university' });
const products = await UMA.schools.products('UL', { category: 'hoodies' });

// Cart
await UMA.cart.add(variantId, quantity);
const cart = await UMA.cart.get();

// Orders
const result = await UMA.orders.checkout({ ... });
const order = await UMA.orders.track(orderNumber);
```

Full examples in `docs/FRONTEND_INTEGRATION.html` (not included; see main spec).

## 📝 Next Steps

Easy additions (not included):

1. Email verification enforcement
2. Password reset flow
3. Admin dashboard
4. Order status updates (shipped, delivered)
5. Reviews & ratings
6. Image uploads (Cloudinary)
7. SMS notifications (Twilio)
8. Coupon codes
9. Wishlist
10. Advanced analytics

## 📄 License

MIT
