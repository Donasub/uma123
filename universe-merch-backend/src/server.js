import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { query } from './utils/db.js';
import { authenticate } from './middleware/auth.js';
import { errorHandler } from './middleware/errors.js';
import { verifyEmailConfig } from './services/email.js';

// Routes
import authRouter from './routes/auth.js';
import schoolsRouter from './routes/schools.js';
import productsRouter from './routes/products.js';
import cartRouter from './routes/cart.js';
import ordersRouter from './routes/orders.js';
import addressesRouter from './routes/addresses.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 4000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Middleware
app.use(helmet());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// CORS
const allowedOrigins = (process.env.CORS_ORIGIN || 'http://localhost:3000').split(',');
app.use(cors({
  origin: allowedOrigins,
  credentials: true,
}));

// Rate limiting
const generalLimiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 120, // 120 requests per minute
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 20, // 20 attempts per 15 minutes
  message: 'Too many authentication attempts, please try again later',
  skipSuccessfulRequests: true,
});

app.use(generalLimiter);

// Health check
app.get('/api/health', async (req, res) => {
  try {
    await query('SELECT 1');
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      database: 'connected',
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error.message,
    });
  }
});

// Routes
app.use('/api/auth', authLimiter, authRouter);
app.use('/api/schools', schoolsRouter);
app.use('/api/products', productsRouter);
app.use('/api/cart', cartRouter);
app.use('/api/orders', ordersRouter);
app.use('/api/addresses', addressesRouter);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

// Error handler
app.use(errorHandler);

// Start server
const startServer = async () => {
  try {
    // Test database connection
    await query('SELECT 1');
    console.log('✓ Database connected');

    // Verify email configuration
    const emailReady = await verifyEmailConfig();

    // Start listening
    app.listen(PORT, () => {
      console.log('\n╔════════════════════════════════════════════════════╗');
      console.log('║   UNIVERSE MERCH AFRICA  ·  API running            ║');
      console.log(`║   Port: ${PORT}                                       ║`);
      console.log(`║   Environment: ${NODE_ENV.padEnd(41)}║`);
      console.log('╚════════════════════════════════════════════════════╝\n');

      if (emailReady) {
        console.log('✓ Email service configured');
      } else {
        console.log('⚠ Email service not configured - emails will not be sent');
      }
    });
  } catch (error) {
    console.error('✗ Failed to start server:', error.message);
    process.exit(1);
  }
};

startServer();

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down...');
  process.exit(0);
});
