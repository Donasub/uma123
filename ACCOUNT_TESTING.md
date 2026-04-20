# Account Page Testing Guide

## Overview
The user account page (`account.html`) provides a comprehensive interface for users to manage their profile, view orders, manage addresses, and change passwords.

## Features
- **Profile Management**: View and edit personal information
- **Order History**: Browse past orders with status tracking
- **Address Management**: Add, edit, delete delivery addresses
- **Password Management**: Change account password securely
- **Responsive Design**: Works on desktop and mobile devices

## Setup for Testing

### 1. Backend Setup (Recommended)
```bash
# Install dependencies
npm install

# Set up environment
cp .env.example .env
# Edit .env with your database URL and JWT secret

# Create database and run migrations
createdb universe_merch  # or use your preferred method
npm run db:schema
npm run db:seed

# Start the backend
npm start
```

### 2. Database Configuration
Update your `.env` file:
```env
DATABASE_URL="postgresql://username:password@localhost:5432/universe_merch"
JWT_SECRET="your-super-secret-jwt-key-here"
PORT=4000
```

### 3. Testing the Account Page
1. Start the backend server
2. Open `account.html` in your browser
3. The page will attempt to authenticate and load real data
4. If backend is unavailable, it falls back to mock data

## API Integration

The account page integrates with these backend endpoints:

### Authentication
- `GET /api/auth/me` - Get current user profile
- `PATCH /api/auth/me` - Update user profile

### Orders
- `GET /api/orders` - List user's order history

### Addresses
- `GET /api/addresses` - List user's saved addresses
- `POST /api/addresses` - Create new address
- `PATCH /api/addresses/:id` - Update existing address
- `DELETE /api/addresses/:id` - Delete address

## Testing Without Backend

If you want to test the UI without setting up the full backend:

1. Open `test-account.html` in your browser
2. This provides a testing interface and setup guide
3. The account page will show mock data when API calls fail

## Mock Data Fallback

The account page includes fallback mock data for:
- User profile information
- Order history
- Saved addresses

This allows testing the UI even when the backend is unavailable.

## Browser Compatibility

- Modern browsers with ES6+ support
- Mobile responsive design
- Graceful degradation for older browsers

## Security Features

- JWT token authentication
- Secure password updates
- Input validation and sanitization
- XSS protection via Content Security Policy