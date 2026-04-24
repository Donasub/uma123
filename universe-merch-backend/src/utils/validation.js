import { z } from 'zod';

// Auth schemas
export const signupSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  first_name: z.string().min(2, 'First name required'),
  last_name: z.string().min(2, 'Last name required'),
  phone: z.string().optional(),
  school_id: z.string().uuid().optional(),
});

export const loginSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(6, 'Password required'),
});

export const updateProfileSchema = z.object({
  first_name: z.string().min(2).optional(),
  last_name: z.string().min(2).optional(),
  phone: z.string().optional(),
  school_id: z.string().uuid().optional(),
});

// Product schemas
export const productsFilterSchema = z.object({
  category: z.string().optional(),
  featured: z.string().transform(v => v === 'true').optional(),
  new_drop: z.string().transform(v => v === 'true').optional(),
  sort: z.enum(['price_asc', 'price_desc', 'newest', 'popular']).optional(),
});

export const schoolProductsFilterSchema = z.object({
  category: z.string().optional(),
  size: z.string().optional(),
  color: z.string().optional(),
  sort: z.enum(['price_asc', 'price_desc', 'newest', 'popular']).optional(),
});

// Cart schemas
export const addToCartSchema = z.object({
  variant_id: z.string().min(1, 'Variant ID required'),
  quantity: z.number().int().min(1, 'Quantity must be at least 1'),
});

export const updateCartItemSchema = z.object({
  quantity: z.number().int().min(1, 'Quantity must be at least 1'),
});

// Order schemas
export const checkoutSchema = z.object({
  first_name: z.string().min(2, 'First name required'),
  last_name: z.string().min(2, 'Last name required'),
  email: z.string().email('Invalid email'),
  phone: z.string().min(10, 'Invalid phone number'),
  delivery_method: z.enum(['campus_pickup', 'doorstep', 'express']),
  delivery_address: z.string().optional(),
  delivery_city: z.string().optional(),
  delivery_state: z.string().optional(),
  delivery_notes: z.string().optional(),
  payment_method: z.enum(['card', 'transfer', 'ussd']),
  items: z.array(
    z.object({
      variant_id: z.string().min(1, 'Variant ID required'),
      quantity: z.number().int().min(1, 'Quantity must be at least 1'),
    })
  ),
});

export const paymentWebhookSchema = z.object({
  status: z.enum(['paid', 'failed', 'pending']),
  payment_reference: z.string().optional(),
  amount: z.number().optional(),
});

// Address schemas
export const addressSchema = z.object({
  type: z.enum(['home', 'work', 'other']),
  label: z.string().max(100).optional(),
  address: z.string().min(5, 'Address required'),
  city: z.string().min(2, 'City required'),
  state: z.string().min(2, 'State required'),
  postal_code: z.string().optional(),
  phone: z.string().optional(),
  is_default: z.boolean().optional(),
});
