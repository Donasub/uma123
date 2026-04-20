# Universe Merch Africa - Architecture Overview

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND (Vercel)                         │
│                  HTML/CSS/JavaScript Pages                       │
│                   + uma-client.js Library                        │
└────────────────────────┬────────────────────────────────────────┘
                         │ HTTP/JSON
                         │ (CORS enabled)
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   EXPRESS API SERVER                             │
│                  (Port 4000, Node.js)                            │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Middleware Stack                                         │   │
│  │  • helmet (security headers)                            │   │
│  │  • cors (cross-origin)                                  │   │
│  │  • rate-limit (auth & general)                          │   │
│  │  • authenticate (JWT)                                   │   │
│  │  • validate (Zod schemas)                               │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Route Handlers                                           │   │
│  │  • /api/auth/signup, login, me                          │   │
│  │  • /api/schools, products                               │   │
│  │  • /api/cart/items, cart management                     │   │
│  │  • /api/orders, checkout, webhooks                      │   │
│  │  • /api/health                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Services & Utils                                         │   │
│  │  • Email (Nodemailer → SMTP)                            │   │
│  │  • JWT (signing & verification)                         │   │
│  │  • Crypto (password hashing)                            │   │
│  │  • Validation (Zod schemas)                             │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────┬─────────────────────────────────────────────────┬──────┘
         │                                                 │
         ▼                                                 ▼
    PostgreSQL                                      Email Service
    Database                                       (Gmail/Resend/etc)
    (Local or Cloud)                               (SMTP)
         │
    ┌────┴─────────────────────┬──────────┬───────────┐
    │    Database Schema        │          │           │
    ▼                           ▼          ▼           ▼
  users              schools  products  orders      carts
    │                   │        │         │          │
    ├─ id               ├─ id    ├─ id     ├─ id      ├─ id
    ├─ email            ├─ code  ├─ sku    ├─ order_#  ├─ user_id
    ├─ password_hash    ├─ name  ├─ name   ├─ user_id  ├─ session_id
    ├─ school_id        ├─ type  ├─ price  ├─ total    └─ items
    └─ profile...       ├─ city  ├─ category└─ items
                        └─ colors   variants
                                      │
                                      ▼
                              product_variants
                                ├─ size
                                ├─ color
                                └─ stock_count
```

## 📊 Data Flow Examples

### Signup Flow
```
User
  ↓
[Frontend] POST /api/auth/signup
  ↓
[Backend] Validate input (Zod)
  ↓
[Backend] Hash password (bcryptjs)
  ↓
[Database] INSERT INTO users
  ↓
[Backend] Generate JWT token
  ↓
[Email] Send welcome email (async)
  ↓
[Response] {user, token}
  ↓
[Frontend] Store token in localStorage
```

### Shopping Flow
```
User Selects School
  ↓
[Frontend] GET /api/schools/UL/products
  ↓
[Database] SELECT products, variants WHERE school_id = UL
  ↓
[Response] {school, products[]}
  ↓
[Frontend] Display products with variants
  ↓
User Clicks "Add to Cart"
  ↓
[Frontend] POST /api/cart/items {variant_id, quantity}
  ↓
[Database] Check stock_count >= quantity
  ↓
[Database] INSERT cart_item OR UPDATE quantity
  ↓
[Response] {cart_item}
```

### Checkout Flow (Atomic Transaction)
```
User Clicks Checkout
  ↓
[Frontend] POST /api/orders {items, delivery, payment}
  ↓
[Backend] BEGIN TRANSACTION
  ↓
[Database] LOCK product_variants (prevent overselling)
  ↓
[Backend] For each item:
         ├─ Verify variant exists
         ├─ Verify stock_count >= quantity
         └─ Calculate total
  ↓
[Backend] Calculate shipping + VAT
  ↓
[Database] INSERT INTO orders (generate order_number)
  ↓
[Database] INSERT INTO order_items (full snapshots)
  ↓
[Database] UPDATE product_variants SET stock_count -= quantity
  ↓
[Database] DELETE FROM cart_items (clear cart)
  ↓
[Database] COMMIT TRANSACTION
  ↓
[Email] Send order confirmation (async)
  ↓
[Response] {order_number, total_amount}
```

### Payment Webhook Flow
```
External Payment Gateway (Paystack)
  ↓
[Webhook] POST /api/orders/UMA-2026-00001/payment-webhook
  ↓
[Backend] Verify signature (crypto.hmac)
  ↓
[Backend] Parse status (paid/failed)
  ↓
[Database] UPDATE orders SET payment_status = 'paid'
  ↓
[Database] UPDATE orders SET order_status = 'confirmed'
  ↓
[Response] {success: true}
```

## 🔐 Security Layers

```
Request Flow
    ↓
[HTTPS/TLS]              ← Encrypted transport
    ↓
[CORS Check]             ← Origin validation
    ↓
[Rate Limit]             ← DDoS protection (120 req/min)
    ↓
[Helmet Headers]         ← Security headers (X-Frame, CSP, etc)
    ↓
[Input Validation]       ← Zod schema validation
    ↓
[JWT Auth (Optional)]    ← Bearer token verification
    ↓
[Database Query]         ← Parameterized (SQL injection safe)
    ↓
[Business Logic]         ← Transaction isolation
    ↓
[Response]               ← Error handling (no sensitive data)
```

## 📈 Scalability Path

### Phase 1: Single Server (Current)
```
┌─────────────┐
│   Frontend  │
│   (Vercel)  │
└──────┬──────┘
       │
       ▼
┌─────────────────────────┐
│  Backend (Render/Railway) │ ← Single dyno/instance
│  + PostgreSQL (Supabase)  │
└─────────────────────────┘
```

### Phase 2: Load Balancing
```
┌─────────────┐
│   Frontend  │
│   (Vercel)  │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Load Balancer  │
└────┬────────┬───┘
     │        │
     ▼        ▼
┌────────┐ ┌────────┐
│Backend1│ │Backend2│ ← Horizontal scaling
│(Render)│ │(Render)│
└────┬───┘ └───┬────┘
     └─────┬───┘
           ▼
     ┌──────────────┐
     │ PostgreSQL   │
     │ (Supabase)   │
     └──────────────┘
```

### Phase 3: Advanced (Future)
```
CDN (CloudFlare)
    ↓
┌──────────────┐
│Load Balancer │
└──────┬───────┘
       ↓
┌─────────────────────┐
│  API Servers        │
│  - Backend App 1-N  │
│  - Redis Cache      │
│  - Worker Queues    │
└──────┬──────────────┘
       ↓
┌────────────────────────┐
│ Database Layer         │
│ - PostgreSQL Master    │
│ - Read Replicas       │
└────────────────────────┘
```

## 🔄 Key Interactions

### Database Relationships
```
One School → Many Products
            ├─ Each product → Many Variants (size × color)
            │                 ├─ Each variant → Many Cart Items
            │                 └─ Each variant → Many Order Items

One User → One Cart
        ├─ Many Cart Items
        └─ Many Orders
            └─ Each order → Many Order Items
```

### API Endpoint Groups

**Public (No Auth)**
```
GET  /api/health              ← Health check
GET  /api/schools             ← List schools
GET  /api/schools/:code       ← Get school details
GET  /api/schools/:code/products  ← Browse storefront
GET  /api/products            ← Product catalog
GET  /api/orders/by-number/:id    ← Track any order
POST /api/auth/signup         ← Create account
POST /api/auth/login          ← Get JWT
```

**Guest (Optional Auth, Session-ID Header)**
```
GET  /api/cart                ← View cart
POST /api/cart/items          ← Add to cart
PATCH /api/cart/items/:id     ← Update item
DELETE /api/cart/items/:id    ← Remove item
POST /api/orders              ← Checkout
```

**Authenticated (JWT Required)**
```
GET  /api/auth/me             ← Get profile
PATCH /api/auth/me            ← Update profile
GET  /api/orders              ← Order history
```

**Webhooks (External)**
```
POST /api/orders/:id/payment-webhook ← Payment callback
```

## 🎯 Performance Considerations

- **Connection Pooling**: PG pool reuses connections (10 default)
- **Rate Limiting**: Prevents abuse (20 auth / 120 general per minute)
- **Indexes**: On school_id, category, featured, user_id, email
- **Transactions**: Atomic checkout prevents overselling
- **Async Email**: Doesn't block response
- **Caching**: Can add Redis layer for schools/products

## 🔍 Monitoring & Logging

```
Application Logs
├─ Server startup
├─ Database connections
├─ Request/response times
├─ Email sending status
├─ Error stack traces
└─ Access logs (optional)

Database Monitoring
├─ Connection count
├─ Slow queries
├─ Table sizes
└─ Backup status

Payment Webhooks
├─ Webhook logs
├─ Signature verification
├─ Failure retries
└─ Reconciliation reports
```

---

This architecture is designed to be:
- **Secure** ← Multiple validation layers
- **Scalable** ← Stateless API servers
- **Reliable** ← Transactions, error handling
- **Maintainable** ← Modular code organization
- **Observable** ← Logging and monitoring hooks
