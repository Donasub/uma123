-- SQLite Seed Data for Universe Merch Africa
-- Hardcoded UUIDs for referential integrity across runs

-- ─── SCHOOLS ────────────────────────────────────────────────────────────────
INSERT OR IGNORE INTO schools (id, code, name, type, city, state, region, crest_color_primary, crest_color_secondary, description) VALUES
('sch-uni-lag-0000-0000-000000000001', 'UNILAG', 'University of Lagos',            'university',  'Lagos',      'Lagos',    'Southwest',   '#003380', '#FFD700', 'Flagship institution in Lagos'),
('sch-uni-iba-0000-0000-000000000002', 'UI',     'University of Ibadan',            'university',  'Ibadan',     'Oyo',      'Southwest',   '#FF6600', '#003333', 'Nigeria''s oldest university'),
('sch-uni-oau-0000-0000-000000000003', 'OAU',    'Obafemi Awolowo University',      'university',  'Ile-Ife',    'Osun',     'Southwest',   '#2E8B57', '#FFFFFF', 'Leading university in Osun State'),
('sch-uni-abu-0000-0000-000000000004', 'ABU',    'Ahmadu Bello University',         'university',  'Zaria',      'Kaduna',   'North',       '#8B0000', '#FFFF00', 'Premier northern university'),
('sch-uni-ben-0000-0000-000000000005', 'UNIBEN', 'University of Benin',             'university',  'Benin City', 'Edo',      'South-South', '#CC0000', '#FFFFFF', 'Major university in South-South'),
('sch-uni-unn-0000-0000-000000000006', 'UNN',    'University of Nigeria Nsukka',    'university',  'Nsukka',     'Enugu',    'Southeast',   '#006600', '#FFFF00', 'Leading institution in Southeast'),
('sch-uni-pha-0000-0000-000000000007', 'UNIPH',  'University of Port Harcourt',     'university',  'PH',         'Rivers',   'South-South', '#008000', '#FFFFFF', 'Major university in Rivers'),
('sch-hs-qcl-00000-0000-000000000008', 'QUEENS', 'Queens College Lagos',            'high_school', 'Lagos',      'Lagos',    'Southwest',   '#FF69B4', '#FFFFFF', 'Girls secondary school in Lagos'),
('sch-hs-kcl-00000-0000-000000000009', 'KINGS',  'Kings College Lagos',             'high_school', 'Lagos',      'Lagos',    'Southwest',   '#003366', '#FFD700', 'Boys secondary school in Lagos'),
('sch-hs-loy-00000-0000-000000000010', 'LOYOLA', 'Loyola Jesuit College Abuja',     'high_school', 'Abuja',      'FCT',      'North',       '#8B0000', '#FFFFFF', 'Jesuit school in Abuja'),
('sch-hs-may-00000-0000-000000000011', 'MAYFLR', 'Mayflower School Ikenne',         'high_school', 'Ikenne',     'Ogun',     'Southwest',   '#0066CC', '#FFFFFF', 'Progressive co-educational school');

-- ─── PRODUCTS — UNILAG ──────────────────────────────────────────────────────
INSERT OR IGNORE INTO products (id, school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
('prd-ul-hd-000000-0000-000000000001', 'sch-uni-lag-0000-0000-000000000001', 'UNILAG-HD-001', 'UNILAG Pride Hoodie',    'Premium hoodie with embroidered UNILAG crest. Made from 80% cotton, 20% polyester fleece. A campus staple.', 15000.00, 'hoodies',    1, 0),
('prd-ul-ts-000000-0000-000000000002', 'sch-uni-lag-0000-0000-000000000001', 'UNILAG-TS-001', 'Classic UNILAG Tee',      'Heavyweight cotton t-shirt with screen-printed crest. Available in 4 sizes.', 8000.00,  't-shirts',   1, 1),
('prd-ul-cp-000000-0000-000000000003', 'sch-uni-lag-0000-0000-000000000001', 'UNILAG-CP-001', 'UNILAG Snapback Cap',     'Structured snapback with embroidered crest and flat brim. One size fits all.', 5500.00,  'caps',       0, 0),
('prd-ul-jk-000000-0000-000000000004', 'sch-uni-lag-0000-0000-000000000001', 'UNILAG-JK-001', 'UNILAG Varsity Jacket',   'Classic varsity jacket with leather sleeves and chenille crest patch.', 28000.00, 'jackets',    1, 1),
('prd-ul-sw-000000-0000-000000000005', 'sch-uni-lag-0000-0000-000000000001', 'UNILAG-SW-001', 'UNILAG Sweatpants',       'Comfortable fleece sweatpants with crest embroidery. Perfect for campus.', 9500.00,  'pants',      0, 0);

-- Variants — UNILAG Pride Hoodie
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ul-hd-s-nb-0000-000000000001', 'prd-ul-hd-000000-0000-000000000001', 'S',  'Navy Blue', 20),
('var-ul-hd-m-nb-0000-000000000002', 'prd-ul-hd-000000-0000-000000000001', 'M',  'Navy Blue', 35),
('var-ul-hd-l-nb-0000-000000000003', 'prd-ul-hd-000000-0000-000000000001', 'L',  'Navy Blue', 30),
('var-ul-hd-xl-nb-000-000000000004', 'prd-ul-hd-000000-0000-000000000001', 'XL', 'Navy Blue', 20),
('var-ul-hd-s-gd-0000-000000000005', 'prd-ul-hd-000000-0000-000000000001', 'S',  'Gold',      15),
('var-ul-hd-m-gd-0000-000000000006', 'prd-ul-hd-000000-0000-000000000001', 'M',  'Gold',      20);

-- Variants — UNILAG Classic Tee
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ul-ts-s-wh-0000-000000000007', 'prd-ul-ts-000000-0000-000000000002', 'S',  'White',     50),
('var-ul-ts-m-wh-0000-000000000008', 'prd-ul-ts-000000-0000-000000000002', 'M',  'White',     60),
('var-ul-ts-l-wh-0000-000000000009', 'prd-ul-ts-000000-0000-000000000002', 'L',  'White',     55),
('var-ul-ts-xl-wh-000-000000000010', 'prd-ul-ts-000000-0000-000000000002', 'XL', 'White',     40),
('var-ul-ts-s-nb-0000-000000000011', 'prd-ul-ts-000000-0000-000000000002', 'S',  'Navy Blue', 40),
('var-ul-ts-m-nb-0000-000000000012', 'prd-ul-ts-000000-0000-000000000002', 'M',  'Navy Blue', 45);

-- Variants — UNILAG Snapback Cap
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ul-cp-os-nb-000-000000000013', 'prd-ul-cp-000000-0000-000000000003', 'One Size', 'Navy Blue', 80),
('var-ul-cp-os-gd-000-000000000014', 'prd-ul-cp-000000-0000-000000000003', 'One Size', 'Gold',      60);

-- Variants — UNILAG Varsity Jacket
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ul-jk-s-nb-0000-000000000015', 'prd-ul-jk-000000-0000-000000000004', 'S',  'Navy Blue', 10),
('var-ul-jk-m-nb-0000-000000000016', 'prd-ul-jk-000000-0000-000000000004', 'M',  'Navy Blue', 15),
('var-ul-jk-l-nb-0000-000000000017', 'prd-ul-jk-000000-0000-000000000004', 'L',  'Navy Blue', 12),
('var-ul-jk-xl-nb-000-000000000018', 'prd-ul-jk-000000-0000-000000000004', 'XL', 'Navy Blue',  8);

-- Variants — UNILAG Sweatpants
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ul-sw-s-nb-0000-000000000019', 'prd-ul-sw-000000-0000-000000000005', 'S',  'Navy Blue', 25),
('var-ul-sw-m-nb-0000-000000000020', 'prd-ul-sw-000000-0000-000000000005', 'M',  'Navy Blue', 30),
('var-ul-sw-l-nb-0000-000000000021', 'prd-ul-sw-000000-0000-000000000005', 'L',  'Navy Blue', 28),
('var-ul-sw-xl-nb-000-000000000022', 'prd-ul-sw-000000-0000-000000000005', 'XL', 'Navy Blue', 18);

-- ─── PRODUCTS — UI ──────────────────────────────────────────────────────────
INSERT OR IGNORE INTO products (id, school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
('prd-ui-hd-000000-0000-000000000001', 'sch-uni-iba-0000-0000-000000000002', 'UI-HD-001', 'UI Heritage Hoodie',  'Premium UI hoodie with embroidered crest. Heritage design celebrating decades of excellence.', 14500.00, 'hoodies',   1, 0),
('prd-ui-ts-000000-0000-000000000002', 'sch-uni-iba-0000-0000-000000000002', 'UI-TS-001', 'UI Classic T-Shirt',  'Classic cotton tee representing Nigeria''s first university. Screen-printed crest logo.', 7500.00,  't-shirts',  0, 1),
('prd-ui-po-000000-0000-000000000003', 'sch-uni-iba-0000-0000-000000000002', 'UI-PO-001', 'UI Alumni Polo',      'Premium piqué polo with embroidered UI crest. Ideal for alumni and supporters.', 11000.00, 'polo',      1, 0);

-- Variants — UI Heritage Hoodie
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ui-hd-s-or-0000-000000000001', 'prd-ui-hd-000000-0000-000000000001', 'S',  'Orange', 18),
('var-ui-hd-m-or-0000-000000000002', 'prd-ui-hd-000000-0000-000000000001', 'M',  'Orange', 25),
('var-ui-hd-l-or-0000-000000000003', 'prd-ui-hd-000000-0000-000000000001', 'L',  'Orange', 22),
('var-ui-hd-xl-or-000-000000000004', 'prd-ui-hd-000000-0000-000000000001', 'XL', 'Orange', 15);

-- Variants — UI Classic T-Shirt
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ui-ts-s-wh-0000-000000000005', 'prd-ui-ts-000000-0000-000000000002', 'S',  'White',  40),
('var-ui-ts-m-wh-0000-000000000006', 'prd-ui-ts-000000-0000-000000000002', 'M',  'White',  50),
('var-ui-ts-l-wh-0000-000000000007', 'prd-ui-ts-000000-0000-000000000002', 'L',  'White',  45),
('var-ui-ts-xl-wh-000-000000000008', 'prd-ui-ts-000000-0000-000000000002', 'XL', 'White',  30);

-- Variants — UI Alumni Polo
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-ui-po-s-gr-0000-000000000009', 'prd-ui-po-000000-0000-000000000003', 'S',  'Green', 12),
('var-ui-po-m-gr-0000-000000000010', 'prd-ui-po-000000-0000-000000000003', 'M',  'Green', 18),
('var-ui-po-l-gr-0000-000000000011', 'prd-ui-po-000000-0000-000000000003', 'L',  'Green', 16),
('var-ui-po-xl-gr-000-000000000012', 'prd-ui-po-000000-0000-000000000003', 'XL', 'Green', 10);

-- ─── PRODUCTS — OAU ─────────────────────────────────────────────────────────
INSERT OR IGNORE INTO products (id, school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
('prd-oau-hd-00000-0000-000000000001', 'sch-uni-oau-0000-0000-000000000003', 'OAU-HD-001', 'OAU Heritage Hoodie', 'Premium OAU hoodie with traditional Ife design motifs and embroidered crest.', 14000.00, 'hoodies',  1, 0),
('prd-oau-jk-00000-0000-000000000002', 'sch-uni-oau-0000-0000-000000000003', 'OAU-JK-001', 'OAU Winter Jacket',   'Warm winter jacket perfect for Ile-Ife harmattan season.', 22000.00, 'jackets',  0, 1),
('prd-oau-ts-00000-0000-000000000003', 'sch-uni-oau-0000-0000-000000000003', 'OAU-TS-001', 'OAU Legacy T-Shirt',  'Classic OAU t-shirt in forest green. A timeless piece.', 7000.00,  't-shirts', 0, 0);

-- Variants — OAU Heritage Hoodie
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-oau-hd-s-gn-000-000000000001', 'prd-oau-hd-00000-0000-000000000001', 'S',  'Green', 15),
('var-oau-hd-m-gn-000-000000000002', 'prd-oau-hd-00000-0000-000000000001', 'M',  'Green', 22),
('var-oau-hd-l-gn-000-000000000003', 'prd-oau-hd-00000-0000-000000000001', 'L',  'Green', 18),
('var-oau-hd-xl-gn-00-000000000004', 'prd-oau-hd-00000-0000-000000000001', 'XL', 'Green', 12);

-- Variants — OAU Winter Jacket
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-oau-jk-s-gn-000-000000000005', 'prd-oau-jk-00000-0000-000000000002', 'S',  'Green', 8),
('var-oau-jk-m-gn-000-000000000006', 'prd-oau-jk-00000-0000-000000000002', 'M',  'Green', 12),
('var-oau-jk-l-gn-000-000000000007', 'prd-oau-jk-00000-0000-000000000002', 'L',  'Green', 10),
('var-oau-jk-xl-gn-00-000000000008', 'prd-oau-jk-00000-0000-000000000002', 'XL', 'Green',  6);

-- Variants — OAU Legacy T-Shirt
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-oau-ts-s-gn-000-000000000009', 'prd-oau-ts-00000-0000-000000000003', 'S',  'Green', 30),
('var-oau-ts-m-gn-000-000000000010', 'prd-oau-ts-00000-0000-000000000003', 'M',  'Green', 40),
('var-oau-ts-l-gn-000-000000000011', 'prd-oau-ts-00000-0000-000000000003', 'L',  'Green', 35),
('var-oau-ts-xl-gn-00-000000000012', 'prd-oau-ts-00000-0000-000000000003', 'XL', 'Green', 25);

-- ─── PRODUCTS — ABU ─────────────────────────────────────────────────────────
INSERT OR IGNORE INTO products (id, school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
('prd-abu-po-00000-0000-000000000001', 'sch-uni-abu-0000-0000-000000000004', 'ABU-PO-001', 'ABU Polo Shirt',     'Elegant polo with ABU embroidery. Available in school colours.', 9500.00,  'polo',     1, 0),
('prd-abu-cp-00000-0000-000000000002', 'sch-uni-abu-0000-0000-000000000004', 'ABU-CP-001', 'ABU Snapback Cap',   'Embroidered crest cap in school maroon.', 4500.00,  'caps',     0, 1),
('prd-abu-hd-00000-0000-000000000003', 'sch-uni-abu-0000-0000-000000000004', 'ABU-HD-001', 'ABU Premier Hoodie', 'Northern-inspired design with ABU crest. Keeps you warm on harmattan mornings.', 13500.00, 'hoodies',  0, 0);

-- Variants — ABU Polo
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-abu-po-s-mr-0000-000000000001', 'prd-abu-po-00000-0000-000000000001', 'S',  'Red',   14),
('var-abu-po-m-mr-0000-000000000002', 'prd-abu-po-00000-0000-000000000001', 'M',  'Red',   20),
('var-abu-po-l-mr-0000-000000000003', 'prd-abu-po-00000-0000-000000000001', 'L',  'Red',   18),
('var-abu-po-xl-mr-000-000000000004', 'prd-abu-po-00000-0000-000000000001', 'XL', 'Red',   12);

-- Variants — ABU Cap
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-abu-cp-os-mr-000-000000000005', 'prd-abu-cp-00000-0000-000000000002', 'One Size', 'Red',    60),
('var-abu-cp-os-gd-000-000000000006', 'prd-abu-cp-00000-0000-000000000002', 'One Size', 'Yellow', 40);

-- Variants — ABU Hoodie
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-abu-hd-s-mr-0000-000000000007', 'prd-abu-hd-00000-0000-000000000003', 'S',  'Red', 12),
('var-abu-hd-m-mr-0000-000000000008', 'prd-abu-hd-00000-0000-000000000003', 'M',  'Red', 18),
('var-abu-hd-l-mr-0000-000000000009', 'prd-abu-hd-00000-0000-000000000003', 'L',  'Red', 15),
('var-abu-hd-xl-mr-000-000000000010', 'prd-abu-hd-00000-0000-000000000003', 'XL', 'Red', 10);

-- ─── PRODUCTS — QUEENS COLLEGE ──────────────────────────────────────────────
INSERT OR IGNORE INTO products (id, school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
('prd-qcl-ts-00000-0000-000000000001', 'sch-hs-qcl-00000-0000-000000000008', 'QUEENS-TS-001', 'Queens College Tee',     'Heritage cotton tee celebrating QC''s legacy. Available in classic pink.', 6500.00, 't-shirts',  1, 0),
('prd-qcl-hd-00000-0000-000000000002', 'sch-hs-qcl-00000-0000-000000000008', 'QUEENS-HD-001', 'QC Alumnae Hoodie',      'Soft fleece hoodie with embroidered QC crest. Perfect for reunions.', 12000.00, 'hoodies',  0, 1);

-- Variants — Queens Tee
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-qcl-ts-s-pk-0000-000000000001', 'prd-qcl-ts-00000-0000-000000000001', 'S',  'Pink',  35),
('var-qcl-ts-m-pk-0000-000000000002', 'prd-qcl-ts-00000-0000-000000000001', 'M',  'Pink',  45),
('var-qcl-ts-l-pk-0000-000000000003', 'prd-qcl-ts-00000-0000-000000000001', 'L',  'Pink',  40),
('var-qcl-ts-xl-pk-000-000000000004', 'prd-qcl-ts-00000-0000-000000000001', 'XL', 'Pink',  25);

-- Variants — QC Hoodie
INSERT OR IGNORE INTO product_variants (id, product_id, size, color, stock_count) VALUES
('var-qcl-hd-s-pk-0000-000000000005', 'prd-qcl-hd-00000-0000-000000000002', 'S',  'Pink',  20),
('var-qcl-hd-m-pk-0000-000000000006', 'prd-qcl-hd-00000-0000-000000000002', 'M',  'Pink',  25),
('var-qcl-hd-l-pk-0000-000000000007', 'prd-qcl-hd-00000-0000-000000000002', 'L',  'Pink',  22),
('var-qcl-hd-xl-pk-000-000000000008', 'prd-qcl-hd-00000-0000-000000000002', 'XL', 'Pink',  15);

-- ─── TEST USER (password: "password123") ────────────────────────────────────
INSERT OR IGNORE INTO users (id, email, password_hash, first_name, last_name, phone, school_id, email_verified) VALUES
('usr-test-00000000-0000-000000000001', 'test@example.com',
 '$2a$12$KWVPV4es7HbT0cqdvg0Ch.Aj9i/rNbe29LHm.tx0U2RQO/a0CDvIC',
 'Test', 'User', '+2348012345678', 'sch-uni-lag-0000-0000-000000000001', 1);

-- ─── DEMO ORDER (so order-tracking works immediately) ───────────────────────
INSERT OR IGNORE INTO orders (id, order_number, user_id, first_name, last_name, email, phone,
  delivery_method, delivery_address, delivery_city, delivery_state,
  payment_method, payment_status, subtotal, shipping_cost, vat, total_amount, order_status) VALUES
('ord-demo-0000000000-0000-000000000001',
 'UMA-2026-00001',
 'usr-test-00000000-0000-000000000001',
 'Test', 'User', 'test@example.com', '+2348012345678',
 'campus_pickup', NULL, NULL, NULL,
 'card', 'paid', 15000.00, 0.00, 1125.00, 16125.00, 'confirmed');

INSERT OR IGNORE INTO order_items (order_id, product_id, variant_id, name, sku, size, color, price, quantity) VALUES
('ord-demo-0000000000-0000-000000000001',
 'prd-ul-hd-000000-0000-000000000001',
 'var-ul-hd-l-nb-0000-000000000003',
 'UNILAG Pride Hoodie', 'UNILAG-HD-001', 'L', 'Navy Blue', 15000.00, 1);