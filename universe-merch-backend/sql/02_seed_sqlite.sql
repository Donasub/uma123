-- SQLite Seed Data for Universe Merch Africa
-- Simplified version for testing

-- Seed Universities (5)
INSERT OR IGNORE INTO schools (id, code, name, type, city, state, region, crest_color_primary, crest_color_secondary, description) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'UNILAG', 'University of Lagos', 'university', 'Lagos', 'Lagos', 'Southwest', '#003380', '#FFD700', 'Flagship institution in Lagos'),
('550e8400-e29b-41d4-a716-446655440001', 'UI', 'University of Ibadan', 'university', 'Ibadan', 'Oyo', 'Southwest', '#FF6600', '#003333', 'Nigeria''s oldest university'),
('550e8400-e29b-41d4-a716-446655440002', 'OAU', 'Obafemi Awolowo University', 'university', 'Ile-Ife', 'Osun', 'Southwest', '#2E8B57', '#FFFFFF', 'Leading university in Osun State'),
('550e8400-e29b-41d4-a716-446655440003', 'ABU', 'Ahmadu Bello University', 'university', 'Zaria', 'Kaduna', 'North', '#8B0000', '#FFFF00', 'Premier northern university'),
('550e8400-e29b-41d4-a716-446655440004', 'UNIBEN', 'University of Benin', 'university', 'Benin City', 'Edo', 'South-South', '#CC0000', '#FFFFFF', 'Major university in South-South');

-- Seed High Schools (5)
INSERT OR IGNORE INTO schools (id, code, name, type, city, state, region, crest_color_primary, crest_color_secondary, description) VALUES
('550e8400-e29b-41d4-a716-446655440005', 'QUEENS', 'Queens College Lagos', 'high_school', 'Lagos', 'Lagos', 'Southwest', '#FF69B4', '#FFFFFF', 'Girls secondary school'),
('550e8400-e29b-41d4-a716-446655440006', 'KINGS', 'Kings College Lagos', 'high_school', 'Lagos', 'Lagos', 'Southwest', '#003366', '#FFD700', 'Boys secondary school'),
('550e8400-e29b-41d4-a716-446655440007', 'LASG', 'Lagos State Model College', 'high_school', 'Lagos', 'Lagos', 'Southwest', '#003366', '#FFCC00', 'Elite school in Lagos'),
('550e8400-e29b-41d4-a716-446655440008', 'LOYOLA', 'Loyola Jesuit College', 'high_school', 'Abuja', 'FCT', 'North', '#8B0000', '#FFFFFF', 'Jesuit school in Abuja'),
('550e8400-e29b-41d4-a716-446655440009', 'GOVT_SEC_KANO', 'Government Secondary School Kano', 'high_school', 'Kano', 'Kano', 'North', '#003366', '#FFFF00', 'School in Kano');

-- Products for UNILAG
INSERT OR IGNORE INTO products (id, school_id, sku, name, description, price, image_url, category, is_featured, is_new_drop) VALUES
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', 'UNILAG-001', 'UNILAG Hoodie', 'Classic UNILAG hoodie with school crest', 15000.00, '/images/products/unilag-hoodie.jpg', 'clothing', 1, 0),
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'UNILAG-002', 'UNILAG T-Shirt', 'Comfortable cotton t-shirt', 8000.00, '/images/products/unilag-tshirt.jpg', 'clothing', 0, 1),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'UNILAG-003', 'UNILAG Cap', 'Adjustable cap with school logo', 5000.00, '/images/products/unilag-cap.jpg', 'accessories', 0, 0);

-- Product variants for UNILAG Hoodie
INSERT OR IGNORE INTO product_variants (product_id, size, color, stock_count) VALUES
('660e8400-e29b-41d4-a716-446655440000', 'S', 'Navy Blue', 10),
('660e8400-e29b-41d4-a716-446655440000', 'M', 'Navy Blue', 15),
('660e8400-e29b-41d4-a716-446655440000', 'L', 'Navy Blue', 20),
('660e8400-e29b-41d4-a716-446655440000', 'XL', 'Navy Blue', 12);

-- Product variants for UNILAG T-Shirt
INSERT OR IGNORE INTO product_variants (product_id, size, color, stock_count) VALUES
('660e8400-e29b-41d4-a716-446655440001', 'S', 'White', 25),
('660e8400-e29b-41d4-a716-446655440001', 'M', 'White', 30),
('660e8400-e29b-41d4-a716-446655440001', 'L', 'White', 28),
('660e8400-e29b-41d4-a716-446655440001', 'XL', 'White', 20);

-- Product variants for UNILAG Cap
INSERT OR IGNORE INTO product_variants (product_id, size, color, stock_count) VALUES
('660e8400-e29b-41d4-a716-446655440002', 'One Size', 'Navy Blue', 50);

-- Products for UI
INSERT OR IGNORE INTO products (id, school_id, sku, name, description, price, image_url, category, is_featured, is_new_drop) VALUES
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 'UI-001', 'UI Polo Shirt', 'Premium polo shirt with UI logo', 12000.00, '/images/products/ui-polo.jpg', 'clothing', 1, 0),
('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 'UI-002', 'UI Mug', 'Ceramic mug with school crest', 3000.00, '/images/products/ui-mug.jpg', 'accessories', 0, 1);

-- Product variants for UI Polo
INSERT OR IGNORE INTO product_variants (product_id, size, color, stock_count) VALUES
('660e8400-e29b-41d4-a716-446655440003', 'S', 'Green', 8),
('660e8400-e29b-41d4-a716-446655440003', 'M', 'Green', 12),
('660e8400-e29b-41d4-a716-446655440003', 'L', 'Green', 15),
('660e8400-e29b-41d4-a716-446655440003', 'XL', 'Green', 10);

-- Product variants for UI Mug
INSERT OR IGNORE INTO product_variants (product_id, size, color, stock_count) VALUES
('660e8400-e29b-41d4-a716-446655440004', 'One Size', 'White', 40);

-- Create a test user
INSERT OR IGNORE INTO users (id, email, password_hash, first_name, last_name, phone, school_id, email_verified) VALUES
('770e8400-e29b-41d4-a716-446655440000', 'test@example.com', '$2a$12$KWVPV4es7HbT0cqdvg0Ch.Aj9i/rNbe29LHm.tx0U2RQO/a0CDvIC', 'Test', 'User', '+2348012345678', '550e8400-e29b-41d4-a716-446655440000', 1);

-- Create test addresses for the user
INSERT OR IGNORE INTO addresses (user_id, type, label, address, city, state, phone, is_default) VALUES
('770e8400-e29b-41d4-a716-446655440000', 'home', 'My Home', '123 Main Street, Lagos', 'Lagos', 'Lagos', '+2348012345678', 1),
('770e8400-e29b-41d4-a716-446655440000', 'work', 'Office', '456 Business Avenue, Victoria Island', 'Lagos', 'Lagos', '+2348012345678', 0);

-- Create test orders
INSERT OR IGNORE INTO orders (id, order_number, user_id, first_name, last_name, email, phone, delivery_method, delivery_address, delivery_city, delivery_state, payment_method, payment_status, subtotal, shipping_cost, vat, total_amount, order_status) VALUES
('880e8400-e29b-41d4-a716-446655440000', 'UMA-2024-0001', '770e8400-e29b-41d4-a716-446655440000', 'Test', 'User', 'test@example.com', '+2348012345678', 'campus_pickup', NULL, NULL, NULL, 'card', 'paid', 15000.00, 0.00, 2250.00, 17250.00, 'delivered'),
('880e8400-e29b-41d4-a716-446655440001', 'UMA-2024-0002', '770e8400-e29b-41d4-a716-446655440000', 'Test', 'User', 'test@example.com', '+2348012345678', 'doorstep', '123 Main Street, Lagos', 'Lagos', 'Lagos', 'transfer', 'paid', 8000.00, 2000.00, 1200.00, 11200.00, 'shipped');

-- Create order items
INSERT OR IGNORE INTO order_items (order_id, product_id, variant_id, name, sku, size, color, price, quantity, image_url) VALUES
('880e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', 'UNILAG Hoodie', 'UNILAG-001', 'L', 'Navy Blue', 15000.00, 1, '/images/products/unilag-hoodie.jpg'),
('880e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'UNILAG T-Shirt', 'UNILAG-002', 'M', 'White', 8000.00, 1, '/images/products/unilag-tshirt.jpg');