-- Sample data to seed the database for testing
-- Run this AFTER schema.sql in Supabase SQL Editor

-- Get source IDs
DO $$
DECLARE
    amazon_id UUID;
    pcc_id UUID;
    mediamarkt_id UUID;
    aliexpress_id UUID;
    ebay_id UUID;
BEGIN

SELECT id INTO amazon_id FROM sources WHERE name = 'Amazon ES';
SELECT id INTO pcc_id FROM sources WHERE name = 'PCComponentes';
SELECT id INTO mediamarkt_id FROM sources WHERE name = 'MediaMarkt';
SELECT id INTO aliexpress_id FROM sources WHERE name = 'AliExpress';
SELECT id INTO ebay_id FROM sources WHERE name = 'eBay ES';

-- Samsung Galaxy S24 Ultra
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'Samsung Galaxy S24 Ultra 256GB Titanium Black', 'Samsung', '887276788968', 'Smartphones', 
'https://images.samsung.com/es/smartphones/galaxy-s24-ultra/images/galaxy-s24-ultra-highlights-color-titanium-black-mo.jpg');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 1099.00, 'EUR', 0, 1099.00, 'https://amazon.es/dp/samsung-s24-ultra', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'Samsung Galaxy S24 Ultra%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, pcc_id, 1119.00, 'EUR', 0, 1119.00, 'https://pccomponentes.com/samsung-s24-ultra', 'Oficial', 0.96, 2, 3, true FROM products WHERE canonical_title LIKE 'Samsung Galaxy S24 Ultra%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, aliexpress_id, 989.00, 'EUR', 25.00, 1014.00, 'https://aliexpress.com/item/samsung-s24-ultra', 'Vendedor', 0.82, 12, 20, true FROM products WHERE canonical_title LIKE 'Samsung Galaxy S24 Ultra%';

-- Samsung Galaxy S24+
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'Samsung Galaxy S24+ 256GB Marble Gray', 'Samsung', '887276788951', 'Smartphones', 
'https://images.samsung.com/es/smartphones/galaxy-s24/images/galaxy-s24-plus-highlights-color-marble-gray-mo.jpg');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 899.00, 'EUR', 0, 899.00, 'https://amazon.es/dp/samsung-s24-plus', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'Samsung Galaxy S24+%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, mediamarkt_id, 919.00, 'EUR', 0, 919.00, 'https://mediamarkt.es/samsung-s24-plus', 'Oficial', 0.95, 1, 2, true FROM products WHERE canonical_title LIKE 'Samsung Galaxy S24+%';

-- Samsung Galaxy S24
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'Samsung Galaxy S24 128GB Onyx Black', 'Samsung', '887276788944', 'Smartphones', 
'https://images.samsung.com/es/smartphones/galaxy-s24/images/galaxy-s24-highlights-color-onyx-black-mo.jpg');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 699.00, 'EUR', 0, 699.00, 'https://amazon.es/dp/samsung-s24', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'Samsung Galaxy S24 128GB%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, ebay_id, 649.00, 'EUR', 15.00, 664.00, 'https://ebay.es/itm/samsung-s24', 'Vendedor', 0.78, 5, 7, true FROM products WHERE canonical_title LIKE 'Samsung Galaxy S24 128GB%';

-- iPhone 15 Pro Max
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'iPhone 15 Pro Max 256GB Natural Titanium', 'Apple', '194253401285', 'Smartphones', 
'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-max-black-titanium-select?wid=940&hei=1112&fmt=png-alpha');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 1199.00, 'EUR', 0, 1199.00, 'https://amazon.es/dp/iphone-15-pro-max', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'iPhone 15 Pro Max%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, pcc_id, 1209.00, 'EUR', 0, 1209.00, 'https://pccomponentes.com/iphone-15-pro-max', 'Oficial', 0.96, 2, 3, true FROM products WHERE canonical_title LIKE 'iPhone 15 Pro Max%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, mediamarkt_id, 1219.00, 'EUR', 0, 1219.00, 'https://mediamarkt.es/iphone-15-pro-max', 'Oficial', 0.95, 1, 2, true FROM products WHERE canonical_title LIKE 'iPhone 15 Pro Max%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, aliexpress_id, 1089.00, 'EUR', 25.00, 1114.00, 'https://aliexpress.com/item/iphone-15-pro-max', 'Vendedor', 0.82, 10, 20, true FROM products WHERE canonical_title LIKE 'iPhone 15 Pro Max%';

-- iPhone 15 Pro
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'iPhone 15 Pro 128GB Blue Titanium', 'Apple', '194253401278', 'Smartphones', 
'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-bluetitanium?wid=940&hei=1112&fmt=png-alpha');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 999.00, 'EUR', 0, 999.00, 'https://amazon.es/dp/iphone-15-pro', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'iPhone 15 Pro 128GB%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, pcc_id, 1019.00, 'EUR', 0, 1019.00, 'https://pccomponentes.com/iphone-15-pro', 'Oficial', 0.96, 2, 3, true FROM products WHERE canonical_title LIKE 'iPhone 15 Pro 128GB%';

-- Sony WH-1000XM5
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'Sony WH-1000XM5 Auriculares Inalámbricos Noise Cancelling Negro', 'Sony', '4548736132603', 'Audio', 
'https://www.sony.es/image/5d02da5df552836db894cead8a68f5f3?fmt=pjpeg&wid=330&bgcolor=FFFFFF');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 299.00, 'EUR', 0, 299.00, 'https://amazon.es/dp/sony-wh1000xm5', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'Sony WH-1000XM5%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, mediamarkt_id, 319.00, 'EUR', 0, 319.00, 'https://mediamarkt.es/sony-wh1000xm5', 'Oficial', 0.95, 1, 2, true FROM products WHERE canonical_title LIKE 'Sony WH-1000XM5%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, aliexpress_id, 249.00, 'EUR', 15.00, 264.00, 'https://aliexpress.com/item/sony-xm5', 'Vendedor', 0.75, 15, 25, true FROM products WHERE canonical_title LIKE 'Sony WH-1000XM5%';

-- AirPods Pro
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'Apple AirPods Pro 2ª Gen USB-C', 'Apple', '194253415220', 'Audio', 
'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83?wid=572&hei=572&fmt=jpeg');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 229.00, 'EUR', 0, 229.00, 'https://amazon.es/dp/airpods-pro-2', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'Apple AirPods Pro%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, pcc_id, 239.00, 'EUR', 0, 239.00, 'https://pccomponentes.com/airpods-pro-2', 'Oficial', 0.96, 2, 3, true FROM products WHERE canonical_title LIKE 'Apple AirPods Pro%';

-- MacBook Pro 14"
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'MacBook Pro 14 M3 Pro 512GB Space Black', 'Apple', '194253938224', 'Portátiles', 
'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/mbp14-spacegray-select-202310?wid=452&hei=420&fmt=jpeg');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 1999.00, 'EUR', 0, 1999.00, 'https://amazon.es/dp/macbook-pro-14-m3', 'Oficial', 0.98, 2, 3, true FROM products WHERE canonical_title LIKE 'MacBook Pro 14%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, pcc_id, 2049.00, 'EUR', 0, 2049.00, 'https://pccomponentes.com/macbook-pro-14-m3', 'Oficial', 0.96, 2, 4, true FROM products WHERE canonical_title LIKE 'MacBook Pro 14%';

-- PlayStation 5
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'PlayStation 5 Consola Slim Digital Edition', 'Sony', '711719577669', 'Gaming', 
'https://gmedia.playstation.com/is/image/SIEPDC/ps5-slim-digital-edition-group-image-front-facing?$native_nt$');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 399.00, 'EUR', 0, 399.00, 'https://amazon.es/dp/ps5-slim-digital', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'PlayStation 5%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, mediamarkt_id, 409.00, 'EUR', 0, 409.00, 'https://mediamarkt.es/ps5-slim-digital', 'Oficial', 0.95, 1, 2, true FROM products WHERE canonical_title LIKE 'PlayStation 5%';

-- Nintendo Switch OLED
INSERT INTO products (id, canonical_title, brand, upc, category, canonical_image_url) VALUES 
(gen_random_uuid(), 'Nintendo Switch OLED Blanca', 'Nintendo', '045496453435', 'Gaming', 
'https://assets.nintendo.com/image/upload/f_auto,q_auto/ncom/en_US/switch/site-design-update/oled-background-white');

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, amazon_id, 299.00, 'EUR', 0, 299.00, 'https://amazon.es/dp/switch-oled', 'Oficial', 0.98, 1, 2, true FROM products WHERE canonical_title LIKE 'Nintendo Switch OLED%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, pcc_id, 309.00, 'EUR', 0, 309.00, 'https://pccomponentes.com/switch-oled', 'Oficial', 0.96, 2, 3, true FROM products WHERE canonical_title LIKE 'Nintendo Switch OLED%';

INSERT INTO offers (product_id, source_id, price, currency, shipping_cost, total_price_eur, url, seller_type, confidence_score, delivery_days_min, delivery_days_max, in_stock)
SELECT id, ebay_id, 279.00, 'EUR', 10.00, 289.00, 'https://ebay.es/itm/switch-oled', 'Vendedor', 0.80, 3, 5, true FROM products WHERE canonical_title LIKE 'Nintendo Switch OLED%';

END $$;

-- Verify data
SELECT 
    p.canonical_title, 
    p.brand,
    p.min_price_eur,
    p.offers_count
FROM products p
ORDER BY p.brand, p.canonical_title;
