/**
 * AliExpress Automatic Scraper
 * 
 * Script que abre un navegador visible, va a AliExpress,
 * hace scroll automático y captura todos los productos.
 * 
 * USO:
 *   cd scraper
 *   npm install
 *   node aliexpress-auto-scraper.js "samsung galaxy"
 * 
 * El navegador se abre y puedes ver cómo scrapea.
 * Al final guarda el JSON en ../data/aliexpress_products.json
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Configuration
const SEARCH_TERM = process.argv[2] || 'women clothes';
const MAX_PRODUCTS = 200;
const OUTPUT_FILE = path.join(__dirname, '..', 'data', 'aliexpress_products.json');

console.log(`
╔════════════════════════════════════════════════╗
║   🕷️  AliExpress Automatic Scraper            ║
║   Buscando: "${SEARCH_TERM}"                   ║
╚════════════════════════════════════════════════╝
`);

async function scrapeAliExpress() {
    // Launch browser with visible window
    const browser = await puppeteer.launch({
        headless: false, // VISIBLE - puedes ver lo que hace
        defaultViewport: { width: 1280, height: 900 },
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();

    // Set user agent to avoid detection
    await page.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');

    const products = [];
    const seenIds = new Set();

    try {
        console.log('🌐 Abriendo AliExpress...');
        await page.goto('https://www.aliexpress.com', {
            waitUntil: 'networkidle2',
            timeout: 60000
        });

        // Wait a bit for page to fully load
        await delay(3000);

        // Handle any popups or cookie banners
        try {
            await page.click('[class*="close"]', { timeout: 2000 });
        } catch (e) { } // Ignore if no popup

        console.log('🔍 Buscando:', SEARCH_TERM);

        // Type in search box and search
        const searchSelectors = [
            'input[type="search"]',
            'input[class*="search"]',
            '#search-words',
            'input[placeholder*="search"]',
            'input[name="SearchText"]'
        ];

        let searchFound = false;
        for (const selector of searchSelectors) {
            try {
                await page.waitForSelector(selector, { timeout: 3000 });
                await page.type(selector, SEARCH_TERM, { delay: 50 });
                await page.keyboard.press('Enter');
                searchFound = true;
                break;
            } catch (e) { }
        }

        if (!searchFound) {
            // Try navigating directly to search URL
            console.log('📎 Navegando a búsqueda directamente...');
            await page.goto(`https://www.aliexpress.com/wholesale?SearchText=${encodeURIComponent(SEARCH_TERM)}`, {
                waitUntil: 'networkidle2',
                timeout: 60000
            });
        }

        // Wait for results
        console.log('⏳ Esperando resultados...');
        await delay(5000);

        // Scroll and scrape
        let scrollCount = 0;
        const maxScrolls = 50;

        while (products.length < MAX_PRODUCTS && scrollCount < maxScrolls) {
            console.log(`📜 Scroll ${scrollCount + 1}/${maxScrolls}...`);

            // Extract products from current view
            const newProducts = await page.evaluate(() => {
                const items = [];

                // Various selectors for product cards
                const cardSelectors = [
                    '[class*="search-item-card"]',
                    '[class*="product-item"]',
                    '.search-card-item',
                    '[class*="manhattan--container"]',
                    'a[href*="/item/"]'
                ];

                let cards = [];
                for (const selector of cardSelectors) {
                    const found = document.querySelectorAll(selector);
                    if (found.length > 0) {
                        cards = found;
                        break;
                    }
                }

                cards.forEach((card, index) => {
                    try {
                        // Find title
                        const titleEl = card.querySelector('[class*="title"], h3, [class*="Title"]');
                        const title = titleEl?.textContent?.trim() || '';

                        // Find image
                        const imgEl = card.querySelector('img');
                        let imageUrl = imgEl?.src || imgEl?.getAttribute('data-src') || '';
                        if (imageUrl.startsWith('//')) imageUrl = 'https:' + imageUrl;

                        // Find price
                        const priceEls = card.querySelectorAll('[class*="price"], span[class*="Price"]');
                        let price = '';
                        let originalPrice = '';
                        priceEls.forEach(el => {
                            const text = el.textContent?.trim() || '';
                            if (text.match(/[\d,.]/) && text.length < 20) {
                                if (!price) price = text;
                                else if (!originalPrice) originalPrice = text;
                            }
                        });

                        // Find link
                        const linkEl = card.querySelector('a[href*="/item/"]') || card.closest('a');
                        let productUrl = linkEl?.href || '';

                        // Extract product ID from URL
                        const idMatch = productUrl.match(/\/item\/(\d+)/);
                        const productId = idMatch ? idMatch[1] : `ali-${Date.now()}-${index}`;

                        // Find discount
                        const discountEl = card.querySelector('[class*="discount"]');
                        const discount = discountEl?.textContent?.trim() || '';

                        if (title && imageUrl) {
                            items.push({
                                productId,
                                title: title.substring(0, 200),
                                price,
                                originalPrice,
                                discount,
                                imageUrl,
                                productUrl,
                                source: 'AliExpress'
                            });
                        }
                    } catch (e) { }
                });

                return items;
            });

            // Add new products (avoid duplicates)
            for (const product of newProducts) {
                if (!seenIds.has(product.productId)) {
                    seenIds.add(product.productId);
                    products.push(product);
                    console.log(`  ✅ ${products.length}. ${product.title.substring(0, 50)}...`);
                }
            }

            // Scroll down
            await page.evaluate(() => {
                window.scrollBy(0, window.innerHeight);
            });

            await delay(2000);
            scrollCount++;
        }

        console.log(`\n✨ Total productos capturados: ${products.length}`);

    } catch (error) {
        console.error('❌ Error:', error.message);
    }

    // Save products
    if (products.length > 0) {
        const output = {
            source: 'AliExpress',
            searchTerm: SEARCH_TERM,
            scrapedAt: new Date().toISOString(),
            count: products.length,
            products: products
        };

        // Ensure directory exists
        const dir = path.dirname(OUTPUT_FILE);
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }

        fs.writeFileSync(OUTPUT_FILE, JSON.stringify(output, null, 2), 'utf8');
        console.log(`\n💾 Guardado en: ${OUTPUT_FILE}`);
        console.log(`📤 Ahora ejecuta: git add . && git commit -m "Add AliExpress products" && git push`);
    }

    // Keep browser open for 5 seconds so user can see
    console.log('\n🖥️ Navegador se cerrará en 5 segundos...');
    await delay(5000);

    await browser.close();
    console.log('✅ Completado!');
}

function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Run
scrapeAliExpress().catch(console.error);
