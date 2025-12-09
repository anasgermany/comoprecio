/**
 * ComoPrecio Price Scraper
 * 
 * Scrapes prices from Spanish online stores and saves to products.json
 * Run with: node scraper.js
 */

const axios = require('axios');
const cheerio = require('cheerio');
const fs = require('fs');
const path = require('path');

// Configuration
const OUTPUT_PATH = path.join(__dirname, '..', 'data', 'products.json');
const USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

// Store configurations
const STORES = {
  amazon: {
    id: 'amazon',
    name: 'Amazon ES',
    logo: '🛒',
    country: 'ES',
    baseUrl: 'https://www.amazon.es'
  },
  pccomponentes: {
    id: 'pccomponentes',
    name: 'PCComponentes',
    logo: '🖥️',
    country: 'ES',
    baseUrl: 'https://www.pccomponentes.com'
  },
  mediamarkt: {
    id: 'mediamarkt',
    name: 'MediaMarkt',
    logo: '🔴',
    country: 'ES',
    baseUrl: 'https://www.mediamarkt.es'
  },
  aliexpress: {
    id: 'aliexpress',
    name: 'AliExpress',
    logo: '🇨🇳',
    country: 'CN',
    baseUrl: 'https://es.aliexpress.com'
  },
  ebay: {
    id: 'ebay',
    name: 'eBay ES',
    logo: '🏷️',
    country: 'ES',
    baseUrl: 'https://www.ebay.es'
  },
  fnac: {
    id: 'fnac',
    name: 'Fnac',
    logo: '📀',
    country: 'ES',
    baseUrl: 'https://www.fnac.es'
  },
  carrefour: {
    id: 'carrefour',
    name: 'Carrefour',
    logo: '🛒',
    country: 'ES',
    baseUrl: 'https://www.carrefour.es'
  }
};

// Products to scrape (define search terms and expected products)
const PRODUCTS_TO_SCRAPE = [
  {
    id: 'samsung-s24-ultra-256gb',
    searchTerms: ['Samsung Galaxy S24 Ultra 256GB'],
    brand: 'Samsung',
    category: 'Smartphones',
    stores: ['amazon', 'pccomponentes', 'mediamarkt', 'aliexpress']
  },
  {
    id: 'samsung-s24-plus-256gb',
    searchTerms: ['Samsung Galaxy S24+ 256GB', 'Samsung Galaxy S24 Plus 256GB'],
    brand: 'Samsung',
    category: 'Smartphones',
    stores: ['amazon', 'pccomponentes', 'mediamarkt']
  },
  {
    id: 'iphone-15-pro-max-256gb',
    searchTerms: ['iPhone 15 Pro Max 256GB'],
    brand: 'Apple',
    category: 'Smartphones',
    stores: ['amazon', 'pccomponentes', 'mediamarkt', 'fnac', 'aliexpress']
  },
  {
    id: 'iphone-15-pro-128gb',
    searchTerms: ['iPhone 15 Pro 128GB'],
    brand: 'Apple',
    category: 'Smartphones',
    stores: ['amazon', 'pccomponentes', 'mediamarkt']
  },
  {
    id: 'sony-wh1000xm5',
    searchTerms: ['Sony WH-1000XM5', 'Sony WH1000XM5'],
    brand: 'Sony',
    category: 'Audio',
    stores: ['amazon', 'mediamarkt', 'fnac', 'aliexpress']
  },
  {
    id: 'airpods-pro-2',
    searchTerms: ['AirPods Pro 2', 'AirPods Pro USB-C'],
    brand: 'Apple',
    category: 'Audio',
    stores: ['amazon', 'pccomponentes', 'mediamarkt', 'fnac']
  },
  {
    id: 'ps5-slim-digital',
    searchTerms: ['PlayStation 5 Slim Digital', 'PS5 Slim Digital'],
    brand: 'Sony',
    category: 'Gaming',
    stores: ['amazon', 'mediamarkt', 'pccomponentes', 'carrefour']
  },
  {
    id: 'nintendo-switch-oled',
    searchTerms: ['Nintendo Switch OLED'],
    brand: 'Nintendo',
    category: 'Gaming',
    stores: ['amazon', 'pccomponentes', 'mediamarkt', 'ebay']
  }
];

// ═══════════════════════════════════════════════════════════════════════════
// SCRAPING FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Fetch HTML from URL with retries
 */
async function fetchHtml(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await axios.get(url, {
        headers: {
          'User-Agent': USER_AGENT,
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8',
        },
        timeout: 15000
      });
      return response.data;
    } catch (error) {
      console.log(`  ⚠️ Retry ${i + 1}/${retries} for ${url}`);
      if (i === retries - 1) throw error;
      await sleep(2000 * (i + 1));
    }
  }
}

/**
 * Sleep helper
 */
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Parse price from string (handles €, comma as decimal)
 */
function parsePrice(priceStr) {
  if (!priceStr) return null;
  const cleaned = priceStr
    .replace(/[^\d,\.]/g, '')
    .replace(',', '.');
  const price = parseFloat(cleaned);
  return isNaN(price) ? null : price;
}

// ═══════════════════════════════════════════════════════════════════════════
// STORE-SPECIFIC SCRAPERS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Scrape Amazon ES search results
 */
async function scrapeAmazon(searchTerm) {
  const url = `https://www.amazon.es/s?k=${encodeURIComponent(searchTerm)}`;
  console.log(`  🛒 Amazon: ${searchTerm}`);
  
  try {
    const html = await fetchHtml(url);
    const $ = cheerio.load(html);
    
    const results = [];
    $('[data-component-type="s-search-result"]').slice(0, 3).each((i, el) => {
      const title = $(el).find('h2 a span').text().trim();
      const priceWhole = $(el).find('.a-price-whole').first().text();
      const priceFraction = $(el).find('.a-price-fraction').first().text();
      const link = $(el).find('h2 a').attr('href');
      
      if (priceWhole) {
        const price = parsePrice(`${priceWhole}${priceFraction}`);
        if (price) {
          results.push({
            title,
            price,
            shipping: 0, // Amazon ES usually has free shipping for Prime
            url: `https://www.amazon.es${link}`,
            stock: true
          });
        }
      }
    });
    
    return results[0] || null;
  } catch (error) {
    console.log(`  ❌ Amazon error: ${error.message}`);
    return null;
  }
}

/**
 * Scrape PCComponentes search results
 */
async function scrapePCComponentes(searchTerm) {
  const url = `https://www.pccomponentes.com/buscar/?query=${encodeURIComponent(searchTerm)}`;
  console.log(`  🖥️ PCComponentes: ${searchTerm}`);
  
  try {
    const html = await fetchHtml(url);
    const $ = cheerio.load(html);
    
    const firstProduct = $('[data-product-name]').first();
    if (firstProduct.length) {
      const title = firstProduct.attr('data-product-name');
      const priceStr = firstProduct.find('[data-product-price]').attr('data-product-price');
      const link = firstProduct.find('a').first().attr('href');
      
      const price = parsePrice(priceStr);
      if (price) {
        return {
          title,
          price,
          shipping: 0, // PCComponentes usually has free shipping over 25€
          url: link?.startsWith('http') ? link : `https://www.pccomponentes.com${link}`,
          stock: true
        };
      }
    }
    return null;
  } catch (error) {
    console.log(`  ❌ PCComponentes error: ${error.message}`);
    return null;
  }
}

/**
 * Scrape MediaMarkt search results
 */
async function scrapeMediaMarkt(searchTerm) {
  const url = `https://www.mediamarkt.es/es/search.html?query=${encodeURIComponent(searchTerm)}`;
  console.log(`  🔴 MediaMarkt: ${searchTerm}`);
  
  try {
    const html = await fetchHtml(url);
    const $ = cheerio.load(html);
    
    const firstProduct = $('[data-test="mms-search-srp-productlist-item"]').first();
    if (firstProduct.length) {
      const title = firstProduct.find('[data-test="product-title"]').text().trim();
      const priceStr = firstProduct.find('[data-test="product-price"]').text();
      const link = firstProduct.find('a').first().attr('href');
      
      const price = parsePrice(priceStr);
      if (price) {
        return {
          title,
          price,
          shipping: 0,
          url: link?.startsWith('http') ? link : `https://www.mediamarkt.es${link}`,
          stock: true
        };
      }
    }
    return null;
  } catch (error) {
    console.log(`  ❌ MediaMarkt error: ${error.message}`);
    return null;
  }
}

// Store scraper mapping
const SCRAPERS = {
  amazon: scrapeAmazon,
  pccomponentes: scrapePCComponentes,
  mediamarkt: scrapeMediaMarkt,
  // Add more scrapers here
};

// ═══════════════════════════════════════════════════════════════════════════
// MAIN SCRAPER
// ═══════════════════════════════════════════════════════════════════════════

async function scrapeAllProducts() {
  console.log('🚀 Starting ComoPrecio Scraper...\n');
  
  const products = [];
  
  for (const productConfig of PRODUCTS_TO_SCRAPE) {
    console.log(`\n📦 Scraping: ${productConfig.id}`);
    
    const offers = [];
    const searchTerm = productConfig.searchTerms[0];
    
    for (const storeId of productConfig.stores) {
      const scraper = SCRAPERS[storeId];
      
      if (scraper) {
        const result = await scraper(searchTerm);
        
        if (result) {
          offers.push({
            source: storeId,
            price: result.price,
            shipping: result.shipping,
            total: result.price + result.shipping,
            url: result.url,
            stock: result.stock,
            delivery: storeId === 'aliexpress' ? '10-20' : '1-3',
            confidence: 0.90
          });
          console.log(`    ✅ ${storeId}: ${result.price}€`);
        }
      } else {
        // Use placeholder for stores without scraper yet
        console.log(`    ⏭️ ${storeId}: No scraper yet, using placeholder`);
      }
      
      // Rate limiting
      await sleep(1500);
    }
    
    // Sort offers by total price
    offers.sort((a, b) => a.total - b.total);
    
    products.push({
      id: productConfig.id,
      title: searchTerm,
      brand: productConfig.brand,
      category: productConfig.category,
      upc: null, // Would need product API for this
      image: getDefaultImage(productConfig.brand, productConfig.id),
      offers
    });
  }
  
  return products;
}

/**
 * Get default product image based on brand/id
 */
function getDefaultImage(brand, productId) {
  const images = {
    'samsung-s24-ultra': 'https://images.samsung.com/es/smartphones/galaxy-s24-ultra/images/galaxy-s24-ultra-highlights-color-titanium-black-mo.jpg',
    'samsung-s24-plus': 'https://images.samsung.com/es/smartphones/galaxy-s24/images/galaxy-s24-plus-highlights-color-marble-gray-mo.jpg',
    'iphone-15-pro-max': 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-max-black-titanium-select',
    'iphone-15-pro': 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-bluetitanium',
    'sony-wh1000xm5': 'https://www.sony.es/image/5d02da5df552836db894cead8a68f5f3',
    'airpods-pro': 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83',
    'ps5': 'https://gmedia.playstation.com/is/image/SIEPDC/ps5-slim-digital-edition-front',
    'nintendo-switch': 'https://assets.nintendo.com/image/upload/ncom/en_US/switch/site-design-update/hardware-lineup-oled-white'
  };
  
  for (const [key, url] of Object.entries(images)) {
    if (productId.includes(key)) return url;
  }
  
  return 'https://via.placeholder.com/400x400?text=' + encodeURIComponent(brand);
}

/**
 * Save products to JSON file
 */
function saveProducts(products) {
  const output = {
    last_updated: new Date().toISOString(),
    sources: Object.values(STORES),
    products
  };
  
  fs.writeFileSync(OUTPUT_PATH, JSON.stringify(output, null, 2), 'utf8');
  console.log(`\n✅ Saved ${products.length} products to ${OUTPUT_PATH}`);
}

/**
 * Load existing products to merge with new data
 */
function loadExistingProducts() {
  try {
    const data = fs.readFileSync(OUTPUT_PATH, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    return { products: [] };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN
// ═══════════════════════════════════════════════════════════════════════════

async function main() {
  const isTest = process.argv.includes('--test');
  
  if (isTest) {
    console.log('🧪 Running in test mode...\n');
    const result = await scrapeAmazon('iPhone 15 Pro Max');
    console.log('Test result:', result);
    return;
  }
  
  try {
    const products = await scrapeAllProducts();
    saveProducts(products);
    
    console.log('\n🎉 Scraping complete!');
    console.log(`   Products: ${products.length}`);
    console.log(`   Total offers: ${products.reduce((sum, p) => sum + p.offers.length, 0)}`);
  } catch (error) {
    console.error('❌ Scraper failed:', error);
    process.exit(1);
  }
}

main();
