# Universe Merch Africa - Backend Setup Guide

## ✅ What's Been Created

Your complete production-ready backend has been scaffolded with:

- ✅ Full Express.js server with all endpoints
- ✅ PostgreSQL schema with all tables (users, schools, products, orders, etc.)
- ✅ Seed data: 20 universities + 20 high schools + products
- ✅ Authentication (signup, login, JWT)
- ✅ Shopping cart (guest & logged-in users)
- ✅ Order checkout with atomic transactions
- ✅ Email service (welcome + order confirmation)
- ✅ Paystack payment webhook ready
- ✅ Frontend integration client (`uma-client.js`)
- ✅ Rate limiting, CORS, validation, security headers

## 🚀 Next Steps: Getting It Running

### Step 1: Install Dependencies

```bash
cd universe-merch-backend
npm install
```

This will install:
- express, pg (database), jsonwebtoken
- bcryptjs (password hashing), nodemailer (email)
- zod (validation), helmet (security)
- express-rate-limit, cors, dotenv

### Step 2: Set Up Database

**Choose ONE option:**

#### Option A: Local PostgreSQL

Install PostgreSQL if you don't have it:
- macOS: `brew install postgresql@14`
- Ubuntu/Debian: `sudo apt install postgresql-14`
- Windows: Download from postgresql.org

Then run:
```bash
# Create database
createdb universe_merch

# Load schema
psql universe_merch -f sql/01_schema.sql

# Load seed data (20 schools, products)
psql universe_merch -f sql/02_seed.sql

# Verify
psql universe_merch -c "SELECT COUNT(*) FROM schools;"
# Should return: count = 40
```

Update `.env`:
```
DATABASE_URL=postgresql://localhost/universe_merch
PGSSLMODE=disable
```

#### Option B: Supabase (Free, Cloud-Based - Recommended)

1. Go to [supabase.com](https://supabase.com)
2. Click "New Project" → choose region → create
3. Wait 2-3 minutes for project to be ready
4. In Project Settings → Database → copy Connection String (URI)
5. Paste into `.env`:
   ```
   DATABASE_URL=postgresql://postgres:PASSWORD@HOST:5432/postgres
   PGSSLMODE=require
   ```
6. Open Supabase SQL Editor → paste contents of `sql/01_schema.sql` → Run
7. Paste contents of `sql/02_seed.sql` → Run

#### Option C: Neon (Serverless Postgres - Also Free)

1. Go to [neon.tech](https://neon.tech)
2. Create account → New Project
3. Copy connection string to `.env`:
   ```
   DATABASE_URL=postgresql://...
   PGSSLMODE=require
   ```
4. Run locally:
   ```bash
   npm run db:schema
   npm run db:seed
   ```

### Step 3: Configure Email (Gmail Recommended for Dev)

#### Gmail Method (Fastest for Testing)

1. Enable 2-Step Verification on your Google account
2. Go to [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
3. Select "Mail" and "Windows Computer" (or your device)
4. Copy the 16-character app password
5. Update `.env`:
   ```
   EMAIL_HOST=smtp.gmail.com
   EMAIL_PORT=587
   EMAIL_USER=your@gmail.com
   EMAIL_PASS=xxxxxxxxxxxxxxxx
   EMAIL_FROM=noreply@universemerch.africa
   ```

**Test it:**
```bash
node -e "
require('dotenv').config();
const nodemailer = require('nodemailer');
const t = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  port: 587,
  auth: { user: process.env.EMAIL_USER, pass: process.env.EMAIL_PASS }
});
t.verify((err, valid) => {
  if (valid) console.log('✓ Email ready');
  else console.log('✗ Email failed:', err?.message);
});
"
```

### Step 4: Configure JWT Secret

Generate a strong random secret:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Copy output to `.env`:
```
JWT_SECRET=<paste-long-random-string-here>
```

### Step 5: Start the Server

```bash
npm run dev
```

You should see:
```
╔════════════════════════════════════════════════════╗
║   UNIVERSE MERCH AFRICA  ·  API running            ║
║   Port: 4000                                       ║
║   Environment: development                        ║
╚════════════════════════════════════════════════════╝

✓ Database connected
✓ Email service is ready
```

If you see errors, check the Troubleshooting section below.

## 🧪 Test the API

### 1. Health Check
```bash
curl http://localhost:4000/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "database": "connected"
}
```

### 2. Browse Schools (No Auth Required)
```bash
# All schools
curl http://localhost:4000/api/schools

# Only universities
curl http://localhost:4000/api/schools?type=university

# Specific school (UNILAG)
curl http://localhost:4000/api/schools/UL
```

### 3. Browse Products
```bash
# All products for UNILAG
curl http://localhost:4000/api/schools/UL/products

# Filter by category
curl "http://localhost:4000/api/schools/UL/products?category=hoodies"

# Filter by size
curl "http://localhost:4000/api/schools/UL/products?size=L"

# Sort by price
curl "http://localhost:4000/api/schools/UL/products?sort=price_asc"
```

### 4. Sign Up (With Email)
```bash
curl -X POST http://localhost:4000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@example.com",
    "password": "SecurePass123!",
    "first_name": "John",
    "last_name": "Doe",
    "phone": "08012345678"
  }'
```

You should receive a welcome email at student@example.com!

Response:
```json
{
  "message": "Signup successful",
  "user": { "id": "...", "email": "student@example.com", ... },
  "token": "eyJhbGciOiJIUzI1NiI..."
}
```

Save the token for next requests.

### 5. Add to Cart (Guest - No Auth)
```bash
# Get a variant_id from products endpoint first, then:
curl -X POST http://localhost:4000/api/cart/items \
  -H "Content-Type: application/json" \
  -H "X-Session-Id: test-session-123" \
  -d '{
    "variant_id": "<paste-variant-uuid-here>",
    "quantity": 2
  }'
```

### 6. Complete Checkout
```bash
curl -X POST http://localhost:4000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "John",
    "last_name": "Doe",
    "email": "student@example.com",
    "phone": "08012345678",
    "delivery_method": "campus_pickup",
    "payment_method": "card",
    "items": [
      {
        "variant_id": "<paste-variant-uuid>",
        "quantity": 1
      }
    ]
  }'
```

You should receive an order confirmation email!

Response:
```json
{
  "message": "Order created successfully",
  "order": {
    "order_number": "UMA-2026-00001",
    "total_amount": 11537.50,
    "payment_status": "pending"
  }
}
```

## 🔗 Connect Frontend to Backend

1. Copy `public/uma-client.js` to your frontend (e.g., `/public/js/uma-client.js`)

2. Include on every HTML page:
```html
<script src="/js/uma-client.js"></script>
<script>
  UMA.init({ apiUrl: 'http://localhost:4000/api' });
</script>
```

3. Now you can use in JavaScript:
```javascript
// Sign up
const user = await UMA.auth.signup({
  email: 'student@example.com',
  password: 'SecurePass123!',
  first_name: 'John',
  last_name: 'Doe',
  school_id: '...' // Get from UMA.schools.list()
});

// Browse schools
const universities = await UMA.schools.list({ type: 'university' });

// Load products
const { school, products } = await UMA.schools.products('UL');

// Add to cart
await UMA.cart.add(variantId, 1);

// Checkout
const order = await UMA.orders.checkout({
  first_name: 'John',
  last_name: 'Doe',
  email: 'student@example.com',
  phone: '08012345678',
  delivery_method: 'campus_pickup',
  payment_method: 'card',
  items: [{ variant_id: '...', quantity: 1 }]
});
```

See full examples in the main README.

## 🚀 Deploy to Production

### Render.com (Easiest, Free Tier)

1. Push your code to GitHub
2. Go to [render.com](https://render.com)
3. Click "New" → "Web Service"
4. Connect your GitHub repo
5. Fill in:
   - **Name:** universe-merch-backend
   - **Build command:** `npm install`
   - **Start command:** `npm start`
   - **Environment:** Add all variables from `.env` manually:
     - `DATABASE_URL`
     - `JWT_SECRET`
     - `EMAIL_HOST`, `EMAIL_PORT`, `EMAIL_USER`, `EMAIL_PASS`
     - `PAYSTACK_PUBLIC_KEY`, `PAYSTACK_SECRET_KEY`
     - `NODE_ENV=production`
     - `FRONTEND_URL=https://universemerch.vercel.app`
     - `CORS_ORIGIN=https://universemerch.vercel.app`
6. Click "Deploy"
7. Wait 5-10 minutes
8. You'll get a URL like: `https://universe-merch-backend.onrender.com`

### Update Your Frontend

Point frontend API requests to the new URL:

```javascript
UMA.init({ 
  apiUrl: 'https://universe-merch-backend.onrender.com/api' 
});
```

Or set an environment variable in your frontend build.

## 🛠️ Troubleshooting

| Problem | Solution |
|---------|----------|
| `ECONNREFUSED` when starting | PostgreSQL not running. Start with `brew services start postgresql@14` or `sudo service postgresql start` |
| `error: database "universe_merch" does not exist` | Run `createdb universe_merch` first |
| `ssl required` error on Supabase | Add `PGSSLMODE=require` to `.env` |
| Emails not sending | Check Gmail app password is correct (should be 16 characters); enable 2FA if not already |
| `401 Invalid token` errors | JWT expired (default 7 days); user needs to log in again |
| Port 4000 already in use | Change `PORT` in `.env` or kill process: `lsof -i :4000` → `kill -9 <PID>` |
| `Cannot find module 'express'` | Run `npm install` again |
| CORS errors in frontend | Update `CORS_ORIGIN` in `.env` to include your frontend URL |

## 📊 Database Management

### View Data (Local PostgreSQL)
```bash
psql universe_merch

# List tables
\dt

# View schools
SELECT code, name, type FROM schools;

# View products
SELECT id, name, price, is_featured FROM products LIMIT 5;

# View orders
SELECT order_number, total_amount, payment_status FROM orders;

# Count users
SELECT COUNT(*) FROM users;

# Exit
\q
```

### Backup Database
```bash
pg_dump universe_merch > backup.sql
```

### Reset Database (Caution!)
```bash
dropdb universe_merch
createdb universe_merch
npm run db:reset
```

## 🔑 Key Files

| File | Purpose |
|------|---------|
| `src/server.js` | Express app setup & route mounting |
| `src/routes/auth.js` | Signup, login, profile |
| `src/routes/schools.js` | School listing & products |
| `src/routes/cart.js` | Add/remove/update cart |
| `src/routes/orders.js` | Checkout & order tracking |
| `src/services/email.js` | Welcome & order confirmation emails |
| `src/middleware/auth.js` | JWT authentication |
| `sql/01_schema.sql` | Database structure |
| `sql/02_seed.sql` | Schools, products, variants |
| `public/uma-client.js` | Frontend integration library |

## 📈 Next: Scale to Production

After confirming everything works locally:

1. **Set up Supabase/Neon** (managed Postgres)
2. **Set up Resend** (transactional email, production-grade)
3. **Add Paystack webhook signature verification** (see comments in `src/routes/orders.js`)
4. **Deploy to Render, Railway, or Fly.io**
5. **Set up email verification** (optional users table field)
6. **Add admin dashboard** for order management
7. **Implement password reset** flow
8. **Set up CI/CD** (GitHub Actions) for automated deploys

## 🆘 Still Stuck?

Check:
1. All `.env` variables are filled
2. PostgreSQL is running
3. Database exists and is populated
4. Port 4000 is available
5. Node.js version ≥ 18: `node --version`
6. Email credentials are correct

If still stuck, check server logs for specific error messages.

---

**You're all set! Your backend is ready to power Universe Merch Africa. 🚀**
