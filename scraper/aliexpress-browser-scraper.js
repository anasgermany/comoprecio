/**
 * AliExpress Local Scraper
 * 
 * Este script se ejecuta en el navegador mientras navegas AliExpress.
 * Captura los productos que ves mientras haces scroll.
 * 
 * INSTRUCCIONES:
 * 1. Abre AliExpress en Chrome
 * 2. Abre DevTools (F12)
 * 3. Ve a la pestaña "Console"
 * 4. Copia y pega todo este código
 * 5. Presiona Enter
 * 6. Haz scroll en la página - los productos se capturan automáticamente
 * 7. Cuando termines, escribe: downloadProducts()
 */

(function () {
    'use strict';

    // Storage for scraped products
    const scrapedProducts = [];
    const scrapedIds = new Set();

    console.log('🚀 AliExpress Scraper iniciado!');
    console.log('📜 Haz scroll para capturar productos');
    console.log('💾 Escribe downloadProducts() cuando termines');

    // Product selectors for AliExpress
    const SELECTORS = {
        // Search results page
        productCard: '[class*="search-item-card"], [class*="product-item"], .search-card-item, [data-product-id]',
        title: '[class*="title"], .manhattan--titleText, h3',
        price: '[class*="price"], .manhattan--price-sale, .search-card-item--price',
        originalPrice: '[class*="origPrice"], .manhattan--price-del, [class*="original"]',
        discount: '[class*="discount"], .manhattan--discount',
        image: 'img[src*="alicdn"], img[data-src*="alicdn"]',
        sales: '[class*="sold"], [class*="trade"]',
        rating: '[class*="rating"], [class*="star"]',
        store: '[class*="store"], .manhattan--store'
    };

    /**
     * Extract product data from a DOM element
     */
    function extractProduct(element) {
        try {
            // Get product ID from various sources
            let productId = element.getAttribute('data-product-id') ||
                element.querySelector('a')?.href?.match(/\/item\/(\d+)/)?.[1] ||
                Date.now() + Math.random().toString(36).substr(2, 9);

            // Skip if already scraped
            if (scrapedIds.has(productId)) return null;

            // Get image
            const imgEl = element.querySelector(SELECTORS.image);
            let imageUrl = imgEl?.src || imgEl?.getAttribute('data-src') || '';
            if (imageUrl.startsWith('//')) imageUrl = 'https:' + imageUrl;

            // Get title
            const titleEl = element.querySelector(SELECTORS.title);
            const title = titleEl?.textContent?.trim() || '';
            if (!title) return null;

            // Get prices
            const priceEl = element.querySelector(SELECTORS.price);
            let priceText = priceEl?.textContent?.trim() || '';

            const originalPriceEl = element.querySelector(SELECTORS.originalPrice);
            let originalPriceText = originalPriceEl?.textContent?.trim() || '';

            // Parse prices
            const parsePrice = (text) => {
                if (!text) return null;
                const match = text.match(/[\d,.]+/);
                return match ? parseFloat(match[0].replace(',', '.')) : null;
            };

            const currentPrice = parsePrice(priceText);
            const originalPrice = parsePrice(originalPriceText) || currentPrice;

            // Get currency
            let currency = 'EUR';
            if (priceText.includes('$') || priceText.includes('USD')) currency = 'USD';
            if (priceText.includes('€') || priceText.includes('EUR')) currency = 'EUR';

            // Get discount
            const discountEl = element.querySelector(SELECTORS.discount);
            let discount = discountEl?.textContent?.trim() || '';
            if (!discount && originalPrice && currentPrice && originalPrice > currentPrice) {
                discount = Math.round((1 - currentPrice / originalPrice) * 100) + '%';
            }

            // Get sales info
            const salesEl = element.querySelector(SELECTORS.sales);
            let sales = salesEl?.textContent?.trim() || '';
            const salesMatch = sales.match(/(\d+)/);
            const salesCount = salesMatch ? parseInt(salesMatch[1]) : 0;

            // Get link
            const linkEl = element.querySelector('a[href*="/item/"]');
            let productUrl = linkEl?.href || '';

            // Get store name
            const storeEl = element.querySelector(SELECTORS.store);
            const storeName = storeEl?.textContent?.trim() || 'AliExpress';

            // Create product object
            const product = {
                ProductId: productId,
                ImageUrl: imageUrl,
                VideoUrl: '', // Would need API for this
                ProductDesc: title,
                OriginPrice: originalPrice ? `${currency} ${originalPrice.toFixed(2)}` : '',
                DiscountPrice: currentPrice ? `${currency} ${currentPrice.toFixed(2)}` : '',
                Discount: discount,
                Currency: currency,
                CommissionRate: 0,
                Commission: '',
                Sales180Day: salesCount,
                PositiveFeedback: '',
                PromotionUrl: productUrl,
                Store: storeName,
                ScrapedAt: new Date().toISOString()
            };

            scrapedIds.add(productId);
            return product;

        } catch (error) {
            console.error('Error extracting product:', error);
            return null;
        }
    }

    /**
     * Scan the page for products
     */
    function scanPage() {
        const productElements = document.querySelectorAll(SELECTORS.productCard);
        let newCount = 0;

        productElements.forEach(element => {
            const product = extractProduct(element);
            if (product) {
                scrapedProducts.push(product);
                newCount++;
            }
        });

        if (newCount > 0) {
            console.log(`✅ +${newCount} productos (Total: ${scrapedProducts.length})`);
        }
    }

    /**
     * Download products as JSON
     */
    window.downloadProducts = function () {
        if (scrapedProducts.length === 0) {
            console.log('❌ No hay productos para descargar');
            return;
        }

        const data = {
            source: 'AliExpress',
            scrapedAt: new Date().toISOString(),
            count: scrapedProducts.length,
            products: scrapedProducts
        };

        const json = JSON.stringify(data, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        const url = URL.createObjectURL(blob);

        const a = document.createElement('a');
        a.href = url;
        a.download = `aliexpress_products_${Date.now()}.json`;
        a.click();

        console.log(`💾 Descargado: ${scrapedProducts.length} productos`);
        console.log('📤 Ahora sube este archivo a GitHub');
    };

    /**
     * Show current products in console
     */
    window.showProducts = function () {
        console.table(scrapedProducts.map(p => ({
            ID: p.ProductId,
            Title: p.ProductDesc.substring(0, 50) + '...',
            Price: p.DiscountPrice,
            Discount: p.Discount
        })));
    };

    /**
     * Clear scraped products
     */
    window.clearProducts = function () {
        scrapedProducts.length = 0;
        scrapedIds.clear();
        console.log('🗑️ Productos borrados');
    };

    // Set up scroll listener
    let scrollTimeout;
    window.addEventListener('scroll', () => {
        clearTimeout(scrollTimeout);
        scrollTimeout = setTimeout(scanPage, 500);
    });

    // Initial scan
    setTimeout(scanPage, 1000);

    // Periodic scan
    setInterval(scanPage, 3000);

    // Add visual indicator
    const indicator = document.createElement('div');
    indicator.id = 'ali-scraper-indicator';
    indicator.innerHTML = `
    <div style="
      position: fixed;
      top: 10px;
      right: 10px;
      background: linear-gradient(135deg, #ff6b35, #ff4757);
      color: white;
      padding: 12px 20px;
      border-radius: 12px;
      font-family: -apple-system, BlinkMacSystemFont, sans-serif;
      font-size: 14px;
      z-index: 99999;
      box-shadow: 0 4px 20px rgba(0,0,0,0.3);
      cursor: pointer;
    ">
      🕷️ Scraper activo: <span id="product-count">0</span> productos
    </div>
  `;
    document.body.appendChild(indicator);

    // Update indicator
    setInterval(() => {
        const countEl = document.getElementById('product-count');
        if (countEl) countEl.textContent = scrapedProducts.length;
    }, 1000);

    // Click indicator to download
    indicator.onclick = window.downloadProducts;

    console.log('\n📋 COMANDOS DISPONIBLES:');
    console.log('  downloadProducts() - Descargar JSON');
    console.log('  showProducts()     - Ver productos en consola');
    console.log('  clearProducts()    - Borrar productos');

})();
