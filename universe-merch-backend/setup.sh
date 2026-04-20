#!/bin/bash
# Universe Merch Backend - Quick Setup Script
# Run this script to get started quickly

set -e

echo "🚀 Universe Merch Africa - Backend Setup"
echo "========================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 18+ first"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install
echo "✅ Dependencies installed"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found"
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo "✅ .env created"
    echo ""
    echo "⚠️  Please edit .env with your configuration:"
    echo "   - DATABASE_URL (required)"
    echo "   - JWT_SECRET (generate with: node -e \"console.log(require('crypto').randomBytes(32).toString('hex'))\")"
    echo "   - EMAIL credentials (optional for testing)"
    exit 1
fi

echo "✅ .env file exists"
echo ""

# Check database connection
echo "🔍 Testing database connection..."
if node -e "require('dotenv').config(); const pg = require('pg'); const pool = new pg.Pool({connectionString: process.env.DATABASE_URL}); pool.query('SELECT 1', (err) => { if (err) { console.log('❌ Database connection failed'); process.exit(1); } else { console.log('✅ Database connected'); process.exit(0); } })" 2>/dev/null; then
    echo ""
else
    echo ""
    echo "⚠️  Database not connected. Please:"
    echo "   1. Ensure PostgreSQL is running"
    echo "   2. Create database: createdb universe_merch"
    echo "   3. Update DATABASE_URL in .env"
    echo ""
    exit 1
fi

# Check if database is populated
echo "🔍 Checking if database is initialized..."
if psql "$DATABASE_URL" -c "SELECT COUNT(*) FROM schools;" 2>/dev/null | grep -q "40"; then
    echo "✅ Database is populated (40 schools found)"
    echo ""
else
    echo "⚠️  Database not populated. Run these commands:"
    echo "   psql \$DATABASE_URL -f sql/01_schema.sql"
    echo "   psql \$DATABASE_URL -f sql/02_seed.sql"
    echo ""
fi

echo "✅ All checks passed!"
echo ""
echo "🚀 Ready to start development server:"
echo "   npm run dev"
echo ""
echo "📊 Test the API:"
echo "   curl http://localhost:4000/api/health"
echo "   curl http://localhost:4000/api/schools"
echo ""
