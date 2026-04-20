-- Seed Universities (20)
INSERT INTO schools (code, name, type, city, state, region, crest_color_primary, crest_color_secondary, description) VALUES
('UL', 'University of Lagos', 'university', 'Lagos', 'Lagos', 'Southwest', '#003380', '#FFD700', 'Flagship institution in Lagos'),
('OAU', 'Obafemi Awolowo University', 'university', 'Ile-Ife', 'Osun', 'Southwest', '#2E8B57', '#FFFFFF', 'Leading university in Osun State'),
('ABU', 'Ahmadu Bello University', 'university', 'Zaria', 'Kaduna', 'North', '#8B0000', '#FFFF00', 'Premier northern university'),
('UI', 'University of Ibadan', 'university', 'Ibadan', 'Oyo', 'Southwest', '#FF6600', '#003333', 'Nigeria''s oldest university'),
('NSU', 'Nnamdi Azikiwe University', 'university', 'Awka', 'Anambra', 'Southeast', '#00AA44', '#FFFF00', 'Leading university in Southeast'),
('UNIBEN', 'University of Benin', 'university', 'Benin City', 'Edo', 'South-South', '#CC0000', '#FFFFFF', 'Major university in South-South'),
('UNILAG', 'Lagos State University', 'university', 'Ojo', 'Lagos', 'Southwest', '#003380', '#FFFFFF', 'State university in Lagos'),
('LASU', 'Lagos State University', 'university', 'Ojo', 'Lagos', 'Southwest', '#003366', '#FFD700', 'Tertiary institution in Lagos'),
('UNIV_PORT', 'University of Port Harcourt', 'university', 'Port Harcourt', 'Rivers', 'South-South', '#008000', '#FFFFFF', 'Major university in Rivers'),
('UNICAL', 'University of Calabar', 'university', 'Calabar', 'Cross River', 'South-South', '#FF0000', '#FFFFFF', 'Prominent university in South-South'),
('UNN', 'University of Nigeria', 'university', 'Nsukka', 'Enugu', 'Southeast', '#006600', '#FFFF00', 'Leading institution in Southeast'),
('DELSU', 'Delta State University', 'university', 'Abraka', 'Delta', 'South-South', '#002247', '#FFCC00', 'University in Delta State'),
('UNIMAID', 'University of Maiduguri', 'university', 'Maiduguri', 'Borno', 'Northeast', '#003366', '#FFFFFF', 'Northern university in Borno'),
('BIU', 'Bayero University Kano', 'university', 'Kano', 'Kano', 'North', '#800000', '#FFFF00', 'Leading university in Kano'),
('ATBU', 'Abubakar Tafawa Balewa University', 'university', 'Bauchi', 'Bauchi', 'North', '#CC6600', '#FFFFFF', 'Northern university'),
('FUTA', 'Federal University of Technology Akure', 'university', 'Akure', 'Ondo', 'Southwest', '#0066CC', '#FFFF00', 'Technology-focused university'),
('LAUTECH', 'Ladoke Akintola University of Technology', 'university', 'Ogbomoso', 'Oyo', 'Southwest', '#8B4513', '#FFFFFF', 'Technology university in Oyo'),
('UNIOSUN', 'Osun State University', 'university', 'Osogbo', 'Osun', 'Southwest', '#003333', '#FFFF00', 'State university in Osun'),
('FUNAAB', 'Federal University of Agriculture', 'university', 'Abeokuta', 'Ogun', 'Southwest', '#228B22', '#FFD700', 'Agricultural university'),
('UNIABUJA', 'University of Abuja', 'university', 'Abuja', 'FCT', 'North', '#003333', '#FFFF00', 'Federal university in Abuja');

-- Seed High Schools (20)
INSERT INTO schools (code, name, type, city, state, region, crest_color_primary, crest_color_secondary, description) VALUES
('LASG', 'Lagos State Model College', 'high_school', 'Lagos', 'Lagos', 'Southwest', '#003366', '#FFCC00', 'Elite school in Lagos'),
('FEDPOLY', 'Federal College of Education', 'high_school', 'Abeokuta', 'Ogun', 'Southwest', '#0066CC', '#FFFFFF', 'Teacher training college'),
('APSSEC', 'APS Secondary School Enugu', 'high_school', 'Enugu', 'Enugu', 'Southeast', '#FF0000', '#FFFFFF', 'Secondary school in Enugu'),
('GOVT_SEC_KANO', 'Government Secondary School Kano', 'high_school', 'Kano', 'Kano', 'North', '#003366', '#FFFF00', 'School in Kano'),
('PORTHC', 'Port Harcourt Secondary School', 'high_school', 'Port Harcourt', 'Rivers', 'South-South', '#008000', '#FFFF00', 'Secondary school in Port Harcourt'),
('LOYOLA_SEC', 'Loyola Jesuit College', 'high_school', 'Abuja', 'FCT', 'North', '#8B0000', '#FFFFFF', 'Jesuit school in Abuja'),
('QUEENS_SEC', 'Queens College Lagos', 'high_school', 'Lagos', 'Lagos', 'Southwest', '#FF69B4', '#FFFFFF', 'Girls secondary school'),
('KINGS_SEC', 'Kings College Lagos', 'high_school', 'Lagos', 'Lagos', 'Southwest', '#003366', '#FFD700', 'Boys secondary school'),
('USMANU_SEC', 'Usmanu Danfodiyo Secondary School', 'high_school', 'Kaduna', 'Kaduna', 'North', '#006633', '#FFFF00', 'School in Kaduna'),
('GOVT_TECH_IBADAN', 'Government Technical College Ibadan', 'high_school', 'Ibadan', 'Oyo', 'Southwest', '#CC0000', '#FFFFFF', 'Technical college'),
('MAYFLOWER_SEC', 'Mayflower School Ikenne', 'high_school', 'Ikenne', 'Ogun', 'Southwest', '#0066CC', '#FFFFFF', 'Secondary school in Ogun'),
('EASTER_SEC', 'Easterbrook Secondary School', 'high_school', 'Benin City', 'Edo', 'South-South', '#008080', '#FFFF00', 'School in Edo'),
('BAPTIST_SEC', 'Baptist Secondary School Enugu', 'high_school', 'Enugu', 'Enugu', 'Southeast', '#FF6600', '#FFFFFF', 'Baptist school'),
('MISSIONARY_SEC', 'Missionary Secondary School', 'high_school', 'Lagos', 'Lagos', 'Southwest', '#003366', '#FFFF00', 'Missionary school'),
('FEDERAL_SCIENCE_SEC', 'Federal Science and Technical School', 'high_school', 'Kano', 'Kano', 'North', '#006633', '#FFFF00', 'Science and tech focused school'),
('GIRLS_COLLEGE_JOS', 'Girls College Jos', 'high_school', 'Jos', 'Plateau', 'North-Central', '#FF69B4', '#FFFFFF', 'Girls school in Plateau'),
('BOYS_COLLEGE_JOS', 'Boys College Jos', 'high_school', 'Jos', 'Plateau', 'North-Central', '#003366', '#FFFFFF', 'Boys school in Plateau'),
('ACADEMY_CALABAR', 'Calabar High School', 'high_school', 'Calabar', 'Cross River', 'South-South', '#008000', '#FFFF00', 'School in Cross River'),
('GOVT_SEC_KADUNA', 'Government Secondary School Kaduna', 'high_school', 'Kaduna', 'Kaduna', 'North', '#8B0000', '#FFFF00', 'Government school in Kaduna'),
('CHRISTIAN_SEC_IBADAN', 'Christian Secondary School', 'high_school', 'Ibadan', 'Oyo', 'Southwest', '#FF0000', '#FFFFFF', 'Christian school in Ibadan');

-- Get school IDs for product insertion
-- Now insert products and variants for each school

-- Products for UNILAG (UL)
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'UL'), 'UL-HOODIE-001', 'UNILAG Pride Hoodie', 'Premium UNILAG hoodie with embroidered crest', 8500.00, 'hoodies', true, false),
((SELECT id FROM schools WHERE code = 'UL'), 'UL-TSHIRT-001', 'Classic UNILAG T-Shirt', 'Comfortable cotton t-shirt with screen-printed logo', 3500.00, 't-shirts', true, true),
((SELECT id FROM schools WHERE code = 'UL'), 'UL-CAP-001', 'UNILAG Snapback Cap', 'Classic snapback with embroidered crest', 2000.00, 'caps', false, false),
((SELECT id FROM schools WHERE code = 'UL'), 'UL-SWEAT-001', 'UNILAG Sweatpants', 'Comfortable sweatpants with UNILAG branding', 5500.00, 'pants', false, false);

-- Add variants for UNILAG products
INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'UL-HOODIE-001'), 'S', 'Navy Blue', 50),
((SELECT id FROM products WHERE sku = 'UL-HOODIE-001'), 'M', 'Navy Blue', 75),
((SELECT id FROM products WHERE sku = 'UL-HOODIE-001'), 'L', 'Navy Blue', 60),
((SELECT id FROM products WHERE sku = 'UL-HOODIE-001'), 'XL', 'Navy Blue', 40),
((SELECT id FROM products WHERE sku = 'UL-HOODIE-001'), 'S', 'Gold', 30),
((SELECT id FROM products WHERE sku = 'UL-HOODIE-001'), 'M', 'Gold', 45),
((SELECT id FROM products WHERE sku = 'UL-TSHIRT-001'), 'S', 'White', 100),
((SELECT id FROM products WHERE sku = 'UL-TSHIRT-001'), 'M', 'White', 120),
((SELECT id FROM products WHERE sku = 'UL-TSHIRT-001'), 'L', 'White', 100),
((SELECT id FROM products WHERE sku = 'UL-TSHIRT-001'), 'XL', 'White', 80),
((SELECT id FROM products WHERE sku = 'UL-TSHIRT-001'), 'S', 'Navy Blue', 80),
((SELECT id FROM products WHERE sku = 'UL-TSHIRT-001'), 'M', 'Navy Blue', 90),
((SELECT id FROM products WHERE sku = 'UL-CAP-001'), 'One Size', 'Navy Blue', 150),
((SELECT id FROM products WHERE sku = 'UL-CAP-001'), 'One Size', 'Gold', 100),
((SELECT id FROM products WHERE sku = 'UL-SWEAT-001'), 'S', 'Navy Blue', 40),
((SELECT id FROM products WHERE sku = 'UL-SWEAT-001'), 'M', 'Navy Blue', 50),
((SELECT id FROM products WHERE sku = 'UL-SWEAT-001'), 'L', 'Navy Blue', 45),
((SELECT id FROM products WHERE sku = 'UL-SWEAT-001'), 'XL', 'Navy Blue', 30);

-- Products for OAU
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'OAU'), 'OAU-HOODIE-001', 'OAU Heritage Hoodie', 'Premium OAU hoodie with traditional design', 8500.00, 'hoodies', true, false),
((SELECT id FROM schools WHERE code = 'OAU'), 'OAU-TSHIRT-001', 'OAU Legacy T-Shirt', 'Classic OAU t-shirt', 3500.00, 't-shirts', false, true),
((SELECT id FROM schools WHERE code = 'OAU'), 'OAU-JACKET-001', 'OAU Winter Jacket', 'Warm winter jacket for OAU students', 12000.00, 'jackets', true, false);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'OAU-HOODIE-001'), 'S', 'Green', 40),
((SELECT id FROM products WHERE sku = 'OAU-HOODIE-001'), 'M', 'Green', 60),
((SELECT id FROM products WHERE sku = 'OAU-HOODIE-001'), 'L', 'Green', 50),
((SELECT id FROM products WHERE sku = 'OAU-HOODIE-001'), 'XL', 'Green', 35),
((SELECT id FROM products WHERE sku = 'OAU-TSHIRT-001'), 'S', 'White', 80),
((SELECT id FROM products WHERE sku = 'OAU-TSHIRT-001'), 'M', 'White', 100),
((SELECT id FROM products WHERE sku = 'OAU-TSHIRT-001'), 'L', 'White', 90),
((SELECT id FROM products WHERE sku = 'OAU-TSHIRT-001'), 'XL', 'White', 70),
((SELECT id FROM products WHERE sku = 'OAU-JACKET-001'), 'S', 'Green', 20),
((SELECT id FROM products WHERE sku = 'OAU-JACKET-001'), 'M', 'Green', 30),
((SELECT id FROM products WHERE sku = 'OAU-JACKET-001'), 'L', 'Green', 25),
((SELECT id FROM products WHERE sku = 'OAU-JACKET-001'), 'XL', 'Green', 15);

-- Products for ABU
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'ABU'), 'ABU-POLO-001', 'ABU Polo Shirt', 'Elegant polo shirt with ABU embroidery', 4500.00, 'polos', false, false),
((SELECT id FROM schools WHERE code = 'ABU'), 'ABU-HOODIE-001', 'ABU Pride Hoodie', 'Premium ABU hoodie', 8500.00, 'hoodies', true, true),
((SELECT id FROM schools WHERE code = 'ABU'), 'ABU-SHORTS-001', 'ABU Athletic Shorts', 'Comfortable shorts for ABU athletes', 3000.00, 'shorts', false, false);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'ABU-POLO-001'), 'S', 'Red', 50),
((SELECT id FROM products WHERE sku = 'ABU-POLO-001'), 'M', 'Red', 70),
((SELECT id FROM products WHERE sku = 'ABU-POLO-001'), 'L', 'Red', 60),
((SELECT id FROM products WHERE sku = 'ABU-POLO-001'), 'XL', 'Red', 40),
((SELECT id FROM products WHERE sku = 'ABU-HOODIE-001'), 'S', 'Red', 35),
((SELECT id FROM products WHERE sku = 'ABU-HOODIE-001'), 'M', 'Red', 50),
((SELECT id FROM products WHERE sku = 'ABU-HOODIE-001'), 'L', 'Red', 45),
((SELECT id FROM products WHERE sku = 'ABU-HOODIE-001'), 'XL', 'Red', 30),
((SELECT id FROM products WHERE sku = 'ABU-SHORTS-001'), 'S', 'Yellow', 60),
((SELECT id FROM products WHERE sku = 'ABU-SHORTS-001'), 'M', 'Yellow', 80),
((SELECT id FROM products WHERE sku = 'ABU-SHORTS-001'), 'L', 'Yellow', 70),
((SELECT id FROM products WHERE sku = 'ABU-SHORTS-001'), 'XL', 'Yellow', 50);

-- Products for UI
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'UI'), 'UI-TSHIRT-001', 'UI Heritage T-Shirt', 'Classic UI tee with vintage design', 3500.00, 't-shirts', true, false),
((SELECT id FROM schools WHERE code = 'UI'), 'UI-HOODIE-001', 'UI Tradition Hoodie', 'Premium UI hoodie', 8500.00, 'hoodies', true, false),
((SELECT id FROM schools WHERE code = 'UI'), 'UI-BEANIE-001', 'UI Winter Beanie', 'Warm beanie for UI students', 2500.00, 'beanies', false, true);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'UI-TSHIRT-001'), 'S', 'Orange', 90),
((SELECT id FROM products WHERE sku = 'UI-TSHIRT-001'), 'M', 'Orange', 110),
((SELECT id FROM products WHERE sku = 'UI-TSHIRT-001'), 'L', 'Orange', 100),
((SELECT id FROM products WHERE sku = 'UI-TSHIRT-001'), 'XL', 'Orange', 80),
((SELECT id FROM products WHERE sku = 'UI-HOODIE-001'), 'S', 'Orange', 40),
((SELECT id FROM products WHERE sku = 'UI-HOODIE-001'), 'M', 'Orange', 55),
((SELECT id FROM products WHERE sku = 'UI-HOODIE-001'), 'L', 'Orange', 50),
((SELECT id FROM products WHERE sku = 'UI-HOODIE-001'), 'XL', 'Orange', 35),
((SELECT id FROM products WHERE sku = 'UI-BEANIE-001'), 'One Size', 'Orange', 120),
((SELECT id FROM products WHERE sku = 'UI-BEANIE-001'), 'One Size', 'Navy', 100);

-- Products for NSU
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'NSU'), 'NSU-TSHIRT-001', 'NSU Pride T-Shirt', 'Premium NSU t-shirt', 3500.00, 't-shirts', true, false),
((SELECT id FROM schools WHERE code = 'NSU'), 'NSU-HOODIE-001', 'NSU Excellence Hoodie', 'Comfortable hoodie for NSU', 8500.00, 'hoodies', false, false),
((SELECT id FROM schools WHERE code = 'NSU'), 'NSU-TRACKSUIT-001', 'NSU Tracksuit', 'Complete tracksuit set', 15000.00, 'tracksuits', true, true);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'NSU-TSHIRT-001'), 'S', 'Green', 100),
((SELECT id FROM products WHERE sku = 'NSU-TSHIRT-001'), 'M', 'Green', 120),
((SELECT id FROM products WHERE sku = 'NSU-TSHIRT-001'), 'L', 'Green', 110),
((SELECT id FROM products WHERE sku = 'NSU-TSHIRT-001'), 'XL', 'Green', 90),
((SELECT id FROM products WHERE sku = 'NSU-HOODIE-001'), 'S', 'Green', 35),
((SELECT id FROM products WHERE sku = 'NSU-HOODIE-001'), 'M', 'Green', 50),
((SELECT id FROM products WHERE sku = 'NSU-HOODIE-001'), 'L', 'Green', 45),
((SELECT id FROM products WHERE sku = 'NSU-HOODIE-001'), 'XL', 'Green', 30),
((SELECT id FROM products WHERE sku = 'NSU-TRACKSUIT-001'), 'S', 'Green', 25),
((SELECT id FROM products WHERE sku = 'NSU-TRACKSUIT-001'), 'M', 'Green', 35),
((SELECT id FROM products WHERE sku = 'NSU-TRACKSUIT-001'), 'L', 'Green', 30),
((SELECT id FROM products WHERE sku = 'NSU-TRACKSUIT-001'), 'XL', 'Green', 20);

-- Add more schools' products (abbreviated for brevity, but would continue for all 40 schools)
-- For remaining schools, add at least 2-3 products each

-- UNIBEN Products
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'UNIBEN'), 'UNB-TSHIRT-001', 'UNIBEN Classic T-Shirt', 'Comfortable UNIBEN tee', 3500.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'UNIBEN'), 'UNB-HOODIE-001', 'UNIBEN Hoodie', 'Premium UNIBEN hoodie', 8500.00, 'hoodies', true, false);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'UNB-TSHIRT-001'), 'S', 'Red', 80),
((SELECT id FROM products WHERE sku = 'UNB-TSHIRT-001'), 'M', 'Red', 100),
((SELECT id FROM products WHERE sku = 'UNB-TSHIRT-001'), 'L', 'Red', 90),
((SELECT id FROM products WHERE sku = 'UNB-TSHIRT-001'), 'XL', 'Red', 70),
((SELECT id FROM products WHERE sku = 'UNB-HOODIE-001'), 'S', 'Red', 40),
((SELECT id FROM products WHERE sku = 'UNB-HOODIE-001'), 'M', 'Red', 55),
((SELECT id FROM products WHERE sku = 'UNB-HOODIE-001'), 'L', 'Red', 50),
((SELECT id FROM products WHERE sku = 'UNB-HOODIE-001'), 'XL', 'Red', 35);

-- UNILAG Products (Lagos State University)
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'LASU'), 'LASU-TSHIRT-001', 'LASU T-Shirt', 'Comfortable LASU tee', 3500.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'LASU'), 'LASU-HOODIE-001', 'LASU Hoodie', 'Premium LASU hoodie', 8500.00, 'hoodies', true, true);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'LASU-TSHIRT-001'), 'S', 'Navy', 80),
((SELECT id FROM products WHERE sku = 'LASU-TSHIRT-001'), 'M', 'Navy', 100),
((SELECT id FROM products WHERE sku = 'LASU-TSHIRT-001'), 'L', 'Navy', 90),
((SELECT id FROM products WHERE sku = 'LASU-TSHIRT-001'), 'XL', 'Navy', 70),
((SELECT id FROM products WHERE sku = 'LASU-HOODIE-001'), 'S', 'Navy', 40),
((SELECT id FROM products WHERE sku = 'LASU-HOODIE-001'), 'M', 'Navy', 55),
((SELECT id FROM products WHERE sku = 'LASU-HOODIE-001'), 'L', 'Navy', 50),
((SELECT id FROM products WHERE sku = 'LASU-HOODIE-001'), 'XL', 'Navy', 35);

-- Continue with remaining high schools
-- Queens College Lagos
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'QUEENS_SEC'), 'QUEENS-TSHIRT-001', 'QC Lagos T-Shirt', 'Pink QC Lagos tee', 3000.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'QUEENS_SEC'), 'QUEENS-HOODIE-001', 'QC Lagos Hoodie', 'Pink hoodie for QC Lagos', 7500.00, 'hoodies', true, false);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'QUEENS-TSHIRT-001'), 'S', 'Pink', 70),
((SELECT id FROM products WHERE sku = 'QUEENS-TSHIRT-001'), 'M', 'Pink', 90),
((SELECT id FROM products WHERE sku = 'QUEENS-TSHIRT-001'), 'L', 'Pink', 80),
((SELECT id FROM products WHERE sku = 'QUEENS-TSHIRT-001'), 'XL', 'Pink', 60),
((SELECT id FROM products WHERE sku = 'QUEENS-HOODIE-001'), 'S', 'Pink', 35),
((SELECT id FROM products WHERE sku = 'QUEENS-HOODIE-001'), 'M', 'Pink', 50),
((SELECT id FROM products WHERE sku = 'QUEENS-HOODIE-001'), 'L', 'Pink', 45),
((SELECT id FROM products WHERE sku = 'QUEENS-HOODIE-001'), 'XL', 'Pink', 30);

-- Kings College Lagos
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'KINGS_SEC'), 'KINGS-TSHIRT-001', 'KC Lagos T-Shirt', 'Navy KC Lagos tee', 3000.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'KINGS_SEC'), 'KINGS-HOODIE-001', 'KC Lagos Hoodie', 'Navy hoodie for KC Lagos', 7500.00, 'hoodies', true, false);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'KINGS-TSHIRT-001'), 'S', 'Navy', 70),
((SELECT id FROM products WHERE sku = 'KINGS-TSHIRT-001'), 'M', 'Navy', 90),
((SELECT id FROM products WHERE sku = 'KINGS-TSHIRT-001'), 'L', 'Navy', 80),
((SELECT id FROM products WHERE sku = 'KINGS-TSHIRT-001'), 'XL', 'Navy', 60),
((SELECT id FROM products WHERE sku = 'KINGS-HOODIE-001'), 'S', 'Navy', 35),
((SELECT id FROM products WHERE sku = 'KINGS-HOODIE-001'), 'M', 'Navy', 50),
((SELECT id FROM products WHERE sku = 'KINGS-HOODIE-001'), 'L', 'Navy', 45),
((SELECT id FROM products WHERE sku = 'KINGS-HOODIE-001'), 'XL', 'Navy', 30);

-- Add sample products for remaining universities and high schools (abbreviated)
-- This ensures diversity across all 40 schools
INSERT INTO products (school_id, sku, name, description, price, category, is_featured, is_new_drop) VALUES
((SELECT id FROM schools WHERE code = 'UNIV_PORT'), 'UP-TSHIRT-001', 'UNIPORT T-Shirt', 'Green UNIPORT tee', 3500.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'UNIV_PORT'), 'UP-HOODIE-001', 'UNIPORT Hoodie', 'Premium UNIPORT hoodie', 8500.00, 'hoodies', true, false),
((SELECT id FROM schools WHERE code = 'UNICAL'), 'UC-TSHIRT-001', 'UNICAL T-Shirt', 'UNICAL classic tee', 3500.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'UNN'), 'UNN-TSHIRT-001', 'UNN T-Shirt', 'UNN classic tee', 3500.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'LASG'), 'LASG-TSHIRT-001', 'LASG T-Shirt', 'LASG classic tee', 3000.00, 't-shirts', false, false),
((SELECT id FROM schools WHERE code = 'FEDPOLY'), 'FCP-TSHIRT-001', 'FCEAAC T-Shirt', 'Federal College tee', 3000.00, 't-shirts', false, false);

INSERT INTO product_variants (product_id, size, color, stock_count) VALUES
((SELECT id FROM products WHERE sku = 'UP-TSHIRT-001'), 'S', 'Green', 80),
((SELECT id FROM products WHERE sku = 'UP-TSHIRT-001'), 'M', 'Green', 100),
((SELECT id FROM products WHERE sku = 'UP-TSHIRT-001'), 'L', 'Green', 90),
((SELECT id FROM products WHERE sku = 'UP-TSHIRT-001'), 'XL', 'Green', 70),
((SELECT id FROM products WHERE sku = 'UP-HOODIE-001'), 'S', 'Green', 40),
((SELECT id FROM products WHERE sku = 'UP-HOODIE-001'), 'M', 'Green', 55),
((SELECT id FROM products WHERE sku = 'UP-HOODIE-001'), 'L', 'Green', 50),
((SELECT id FROM products WHERE sku = 'UP-HOODIE-001'), 'XL', 'Green', 35),
((SELECT id FROM products WHERE sku = 'UC-TSHIRT-001'), 'S', 'Red', 80),
((SELECT id FROM products WHERE sku = 'UC-TSHIRT-001'), 'M', 'Red', 100),
((SELECT id FROM products WHERE sku = 'UC-TSHIRT-001'), 'L', 'Red', 90),
((SELECT id FROM products WHERE sku = 'UC-TSHIRT-001'), 'XL', 'Red', 70),
((SELECT id FROM products WHERE sku = 'UNN-TSHIRT-001'), 'S', 'Green', 80),
((SELECT id FROM products WHERE sku = 'UNN-TSHIRT-001'), 'M', 'Green', 100),
((SELECT id FROM products WHERE sku = 'UNN-TSHIRT-001'), 'L', 'Green', 90),
((SELECT id FROM products WHERE sku = 'UNN-TSHIRT-001'), 'XL', 'Green', 70),
((SELECT id FROM products WHERE sku = 'LASG-TSHIRT-001'), 'S', 'Navy', 70),
((SELECT id FROM products WHERE sku = 'LASG-TSHIRT-001'), 'M', 'Navy', 90),
((SELECT id FROM products WHERE sku = 'LASG-TSHIRT-001'), 'L', 'Navy', 80),
((SELECT id FROM products WHERE sku = 'LASG-TSHIRT-001'), 'XL', 'Navy', 60),
((SELECT id FROM products WHERE sku = 'FCP-TSHIRT-001'), 'S', 'Blue', 70),
((SELECT id FROM products WHERE sku = 'FCP-TSHIRT-001'), 'M', 'Blue', 90),
((SELECT id FROM products WHERE sku = 'FCP-TSHIRT-001'), 'L', 'Blue', 80),
((SELECT id FROM products WHERE sku = 'FCP-TSHIRT-001'), 'XL', 'Blue', 60);
