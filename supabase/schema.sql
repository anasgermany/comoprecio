-- ComoPrecio Database Schema
-- Run this in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Sources (stores/merchants)
CREATE TABLE sources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    base_url VARCHAR(500) NOT NULL,
    country VARCHAR(2) NOT NULL,
    source_type VARCHAR(20) NOT NULL CHECK (source_type IN ('api', 'scrape', 'feed')),
    logo_emoji VARCHAR(10),
    rate_limit_per_hour INTEGER DEFAULT 100,
    active BOOLEAN DEFAULT true,
    config JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Products table (canonical products)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canonical_title VARCHAR(500) NOT NULL,
    brand VARCHAR(200),
    upc VARCHAR(20),
    ean VARCHAR(20),
    asin VARCHAR(20),
    description TEXT,
    canonical_image_url TEXT,
    category VARCHAR(200),
    attributes JSONB DEFAULT '{}',
    min_price_eur DECIMAL(12, 2),
    offers_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Full-text search index on products
CREATE INDEX idx_products_search ON products 
    USING GIN (to_tsvector('spanish', canonical_title || ' ' || COALESCE(brand, '') || ' ' || COALESCE(description, '')));

-- Index for UPC/ASIN lookups
CREATE INDEX idx_products_upc ON products(upc) WHERE upc IS NOT NULL;
CREATE INDEX idx_products_asin ON products(asin) WHERE asin IS NOT NULL;

-- Offers from each source
CREATE TABLE offers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    source_id UUID NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
    price DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
    shipping_cost DECIMAL(12, 2) DEFAULT 0,
    tax_estimate DECIMAL(12, 2) DEFAULT 0,
    total_price_eur DECIMAL(12, 2) NOT NULL,
    url TEXT NOT NULL,
    seller_name VARCHAR(200),
    seller_type VARCHAR(50),
    confidence_score DECIMAL(3, 2) DEFAULT 1.0,
    delivery_days_min INTEGER,
    delivery_days_max INTEGER,
    in_stock BOOLEAN DEFAULT true,
    last_checked TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(product_id, source_id, url)
);

CREATE INDEX idx_offers_product ON offers(product_id);
CREATE INDEX idx_offers_price ON offers(total_price_eur);
CREATE INDEX idx_offers_last_checked ON offers(last_checked);

-- Price history for graphs
CREATE TABLE price_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    source_id UUID NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
    price_eur DECIMAL(12, 2) NOT NULL,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_price_history_product ON price_history(product_id, recorded_at DESC);

-- Price alerts
CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    target_price_eur DECIMAL(12, 2) NOT NULL,
    active BOOLEAN DEFAULT true,
    triggered BOOLEAN DEFAULT false,
    triggered_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

CREATE INDEX idx_alerts_user ON alerts(user_id);
CREATE INDEX idx_alerts_active ON alerts(active) WHERE active = true;

-- Search history
CREATE TABLE searches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID,
    query VARCHAR(500) NOT NULL,
    results_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_searches_query ON searches(query);

-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Function to update min_price_eur on products
CREATE OR REPLACE FUNCTION update_product_min_price()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products 
    SET min_price_eur = (
        SELECT MIN(total_price_eur) FROM offers WHERE product_id = NEW.product_id AND in_stock = true
    ),
    offers_count = (
        SELECT COUNT(*) FROM offers WHERE product_id = NEW.product_id
    )
    WHERE id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_min_price_on_offer AFTER INSERT OR UPDATE ON offers
    FOR EACH ROW EXECUTE FUNCTION update_product_min_price();

-- Insert initial sources
INSERT INTO sources (name, base_url, country, source_type, logo_emoji) VALUES
('Amazon ES', 'https://www.amazon.es', 'ES', 'api', '🛒'),
('PCComponentes', 'https://www.pccomponentes.com', 'ES', 'scrape', '🖥️'),
('MediaMarkt', 'https://www.mediamarkt.es', 'ES', 'scrape', '🔴'),
('El Corte Inglés', 'https://www.elcorteingles.es', 'ES', 'scrape', '🏬'),
('AliExpress', 'https://es.aliexpress.com', 'CN', 'api', '🇨🇳'),
('eBay ES', 'https://www.ebay.es', 'ES', 'api', '🏷️'),
('Fnac', 'https://www.fnac.es', 'ES', 'scrape', '📀'),
('Carrefour', 'https://www.carrefour.es', 'ES', 'scrape', '🛒'),
('Worten', 'https://www.worten.es', 'ES', 'scrape', '🔌');

-- Full-text search function
CREATE OR REPLACE FUNCTION search_products(search_query TEXT, result_limit INTEGER DEFAULT 20)
RETURNS TABLE (
    id UUID,
    canonical_title VARCHAR,
    brand VARCHAR,
    canonical_image_url TEXT,
    category VARCHAR,
    min_price_eur DECIMAL,
    offers_count INTEGER,
    rank REAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.canonical_title,
        p.brand,
        p.canonical_image_url,
        p.category,
        p.min_price_eur,
        p.offers_count,
        ts_rank(
            to_tsvector('spanish', p.canonical_title || ' ' || COALESCE(p.brand, '')),
            plainto_tsquery('spanish', search_query)
        ) AS rank
    FROM products p
    WHERE 
        to_tsvector('spanish', p.canonical_title || ' ' || COALESCE(p.brand, '')) 
        @@ plainto_tsquery('spanish', search_query)
        OR p.canonical_title ILIKE '%' || search_query || '%'
        OR p.brand ILIKE '%' || search_query || '%'
        OR p.upc = search_query
        OR p.asin = search_query
    ORDER BY 
        -- Exact matches first
        CASE WHEN p.canonical_title ILIKE search_query THEN 0 
             WHEN p.upc = search_query OR p.asin = search_query THEN 0
             WHEN p.canonical_title ILIKE search_query || '%' THEN 1
             WHEN p.canonical_title ILIKE '%' || search_query || '%' THEN 2
             ELSE 3 
        END,
        rank DESC,
        p.min_price_eur ASC NULLS LAST
    LIMIT result_limit;
END;
$$ LANGUAGE plpgsql;
