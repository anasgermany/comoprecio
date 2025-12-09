import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch product data from GitHub JSON
class GitHubDataService {
  // GitHub raw URL for the products database
  static const String _baseUrl = 'https://raw.githubusercontent.com/anasgermany/comoprecio/main';
  
  // Set to false to fetch from GitHub, true to use embedded data
  static const bool _useLocalData = true;
  
  static GitHubDataService? _instance;
  ProductDatabase? _cachedData;
  DateTime? _lastFetch;
  
  GitHubDataService._();
  
  static GitHubDataService get instance {
    _instance ??= GitHubDataService._();
    return _instance!;
  }
  
  /// Fetch products database from GitHub (or local cache)
  Future<ProductDatabase> getDatabase() async {
    // Return cached data if less than 1 hour old
    if (_cachedData != null && _lastFetch != null) {
      if (DateTime.now().difference(_lastFetch!).inHours < 1) {
        return _cachedData!;
      }
    }
    
    try {
      if (_useLocalData) {
        // For now, return embedded data
        _cachedData = _getEmbeddedData();
      } else {
        final response = await http.get(Uri.parse('$_baseUrl/products.json'));
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          _cachedData = ProductDatabase.fromJson(json);
        }
      }
      _lastFetch = DateTime.now();
      return _cachedData ?? _getEmbeddedData();
    } catch (e) {
      // Fallback to embedded data on error
      return _getEmbeddedData();
    }
  }
  
  /// Search products by query
  Future<List<ProductData>> searchProducts(String query) async {
    final db = await getDatabase();
    final queryLower = query.toLowerCase().trim();
    
    if (queryLower.isEmpty) {
      return db.products.take(10).toList();
    }
    
    // Search logic: title, brand, category
    final results = db.products.where((p) {
      final titleMatch = p.title.toLowerCase().contains(queryLower);
      final brandMatch = p.brand.toLowerCase().contains(queryLower);
      final categoryMatch = p.category.toLowerCase().contains(queryLower);
      final upcMatch = p.upc == queryLower;
      return titleMatch || brandMatch || categoryMatch || upcMatch;
    }).toList();
    
    // Sort by best price
    results.sort((a, b) {
      final aPrice = a.bestOffer?.total ?? double.infinity;
      final bPrice = b.bestOffer?.total ?? double.infinity;
      return aPrice.compareTo(bPrice);
    });
    
    return results;
  }
  
  /// Get product by ID
  Future<ProductData?> getProduct(String id) async {
    final db = await getDatabase();
    try {
      return db.products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Get source info by ID
  Future<SourceData?> getSource(String sourceId) async {
    final db = await getDatabase();
    try {
      return db.sources.firstWhere((s) => s.id == sourceId);
    } catch (e) {
      return null;
    }
  }
  
  /// Embedded data for offline/initial use
  ProductDatabase _getEmbeddedData() {
    return ProductDatabase(
      lastUpdated: DateTime.now(),
      sources: [
        SourceData(id: 'amazon', name: 'Amazon ES', logo: '🛒', country: 'ES'),
        SourceData(id: 'pccomponentes', name: 'PCComponentes', logo: '🖥️', country: 'ES'),
        SourceData(id: 'mediamarkt', name: 'MediaMarkt', logo: '🔴', country: 'ES'),
        SourceData(id: 'aliexpress', name: 'AliExpress', logo: '🇨🇳', country: 'CN'),
        SourceData(id: 'ebay', name: 'eBay ES', logo: '🏷️', country: 'ES'),
        SourceData(id: 'fnac', name: 'Fnac', logo: '📀', country: 'ES'),
        SourceData(id: 'carrefour', name: 'Carrefour', logo: '🛒', country: 'ES'),
      ],
      products: [
        // Samsung products
        ProductData(
          id: 'samsung-s24-ultra-256gb',
          title: 'Samsung Galaxy S24 Ultra 256GB Titanium Black',
          brand: 'Samsung',
          category: 'Smartphones',
          upc: '887276788968',
          image: 'https://images.samsung.com/es/smartphones/galaxy-s24-ultra/images/galaxy-s24-ultra-highlights-color-titanium-black-mo.jpg',
          offers: [
            OfferData(source: 'amazon', price: 1099.00, shipping: 0, total: 1099.00, url: 'https://www.amazon.es/dp/B0CQMXC1L8', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 1119.00, shipping: 0, total: 1119.00, url: 'https://www.pccomponentes.com/samsung-galaxy-s24-ultra', stock: true, delivery: '2-3', confidence: 0.96),
            OfferData(source: 'mediamarkt', price: 1129.00, shipping: 0, total: 1129.00, url: 'https://www.mediamarkt.es/samsung-galaxy-s24-ultra', stock: true, delivery: '1-2', confidence: 0.95),
            OfferData(source: 'aliexpress', price: 989.00, shipping: 25.00, total: 1014.00, url: 'https://es.aliexpress.com/item/samsung-s24-ultra', stock: true, delivery: '12-20', confidence: 0.82),
          ],
        ),
        ProductData(
          id: 'samsung-s24-plus-256gb',
          title: 'Samsung Galaxy S24+ 256GB Marble Gray',
          brand: 'Samsung',
          category: 'Smartphones',
          upc: '887276788951',
          image: 'https://images.samsung.com/es/smartphones/galaxy-s24/images/galaxy-s24-plus-highlights-color-marble-gray-mo.jpg',
          offers: [
            OfferData(source: 'amazon', price: 899.00, shipping: 0, total: 899.00, url: 'https://www.amazon.es/dp/B0CQMXWG3L', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 909.00, shipping: 0, total: 909.00, url: 'https://www.pccomponentes.com/samsung-galaxy-s24-plus', stock: true, delivery: '2-3', confidence: 0.96),
          ],
        ),
        ProductData(
          id: 'samsung-s24-128gb',
          title: 'Samsung Galaxy S24 128GB Onyx Black',
          brand: 'Samsung',
          category: 'Smartphones',
          upc: '887276788944',
          image: 'https://images.samsung.com/es/smartphones/galaxy-s24/images/galaxy-s24-highlights-color-onyx-black-mo.jpg',
          offers: [
            OfferData(source: 'amazon', price: 699.00, shipping: 0, total: 699.00, url: 'https://www.amazon.es/dp/B0CQMXR1N2', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'ebay', price: 649.00, shipping: 15.00, total: 664.00, url: 'https://www.ebay.es/itm/samsung-s24', stock: true, delivery: '5-7', confidence: 0.78),
            OfferData(source: 'aliexpress', price: 599.00, shipping: 20.00, total: 619.00, url: 'https://es.aliexpress.com/item/samsung-s24', stock: true, delivery: '15-25', confidence: 0.75),
          ],
        ),
        ProductData(
          id: 'samsung-galaxy-a54',
          title: 'Samsung Galaxy A54 5G 128GB Awesome Graphite',
          brand: 'Samsung',
          category: 'Smartphones',
          upc: '8806094897418',
          image: 'https://images.samsung.com/es/smartphones/galaxy-a54-5g/images/galaxy-a54-5g-highlights-kv.jpg',
          offers: [
            OfferData(source: 'amazon', price: 349.00, shipping: 0, total: 349.00, url: 'https://www.amazon.es/dp/samsung-a54', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'carrefour', price: 329.00, shipping: 0, total: 329.00, url: 'https://www.carrefour.es/samsung-a54', stock: true, delivery: '2-4', confidence: 0.90),
          ],
        ),
        // Apple products
        ProductData(
          id: 'iphone-15-pro-max-256gb',
          title: 'iPhone 15 Pro Max 256GB Natural Titanium',
          brand: 'Apple',
          category: 'Smartphones',
          upc: '194253401285',
          image: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-max-black-titanium-select?wid=940&hei=1112&fmt=png-alpha',
          offers: [
            OfferData(source: 'amazon', price: 1199.00, shipping: 0, total: 1199.00, url: 'https://www.amazon.es/dp/B0CHJR9BQG', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 1209.00, shipping: 0, total: 1209.00, url: 'https://www.pccomponentes.com/iphone-15-pro-max', stock: true, delivery: '2-3', confidence: 0.96),
            OfferData(source: 'mediamarkt', price: 1219.00, shipping: 0, total: 1219.00, url: 'https://www.mediamarkt.es/iphone-15-pro-max', stock: true, delivery: '1-2', confidence: 0.95),
            OfferData(source: 'aliexpress', price: 1089.00, shipping: 25.00, total: 1114.00, url: 'https://es.aliexpress.com/item/iphone-15-pro-max', stock: true, delivery: '10-20', confidence: 0.82),
          ],
        ),
        ProductData(
          id: 'iphone-15-pro-128gb',
          title: 'iPhone 15 Pro 128GB Blue Titanium',
          brand: 'Apple',
          category: 'Smartphones',
          upc: '194253401278',
          image: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-bluetitanium?wid=940&hei=1112&fmt=png-alpha',
          offers: [
            OfferData(source: 'amazon', price: 999.00, shipping: 0, total: 999.00, url: 'https://www.amazon.es/dp/B0CHJR45SZ', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 1019.00, shipping: 0, total: 1019.00, url: 'https://www.pccomponentes.com/iphone-15-pro', stock: true, delivery: '2-3', confidence: 0.96),
          ],
        ),
        ProductData(
          id: 'iphone-15-128gb',
          title: 'iPhone 15 128GB Pink',
          brand: 'Apple',
          category: 'Smartphones',
          upc: '194253401261',
          image: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-finish-select-202309-6-1inch-pink?wid=940&hei=1112&fmt=png-alpha',
          offers: [
            OfferData(source: 'amazon', price: 799.00, shipping: 0, total: 799.00, url: 'https://www.amazon.es/dp/B0CHJKM1XY', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'mediamarkt', price: 819.00, shipping: 0, total: 819.00, url: 'https://www.mediamarkt.es/iphone-15', stock: true, delivery: '1-2', confidence: 0.95),
          ],
        ),
        // Audio
        ProductData(
          id: 'sony-wh1000xm5',
          title: 'Sony WH-1000XM5 Auriculares Inalámbricos Noise Cancelling Negro',
          brand: 'Sony',
          category: 'Audio',
          upc: '4548736132603',
          image: 'https://www.sony.es/image/5d02da5df552836db894cead8a68f5f3?fmt=pjpeg&wid=330&bgcolor=FFFFFF',
          offers: [
            OfferData(source: 'amazon', price: 299.00, shipping: 0, total: 299.00, url: 'https://www.amazon.es/dp/B09XSXF1Q9', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'mediamarkt', price: 319.00, shipping: 0, total: 319.00, url: 'https://www.mediamarkt.es/sony-wh1000xm5', stock: true, delivery: '1-2', confidence: 0.95),
            OfferData(source: 'aliexpress', price: 249.00, shipping: 15.00, total: 264.00, url: 'https://es.aliexpress.com/item/sony-xm5', stock: true, delivery: '15-25', confidence: 0.75),
          ],
        ),
        ProductData(
          id: 'airpods-pro-2',
          title: 'Apple AirPods Pro 2ª Gen USB-C',
          brand: 'Apple',
          category: 'Audio',
          upc: '194253415220',
          image: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83?wid=572&hei=572&fmt=jpeg',
          offers: [
            OfferData(source: 'amazon', price: 229.00, shipping: 0, total: 229.00, url: 'https://www.amazon.es/dp/B0CHWNNV4P', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 239.00, shipping: 0, total: 239.00, url: 'https://www.pccomponentes.com/airpods-pro-2', stock: true, delivery: '2-3', confidence: 0.96),
          ],
        ),
        // Gaming
        ProductData(
          id: 'ps5-slim-digital',
          title: 'PlayStation 5 Consola Slim Digital Edition',
          brand: 'Sony',
          category: 'Gaming',
          upc: '711719577669',
          image: 'https://gmedia.playstation.com/is/image/SIEPDC/ps5-slim-digital-edition-front',
          offers: [
            OfferData(source: 'amazon', price: 399.00, shipping: 0, total: 399.00, url: 'https://www.amazon.es/dp/ps5-slim-digital', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'mediamarkt', price: 409.00, shipping: 0, total: 409.00, url: 'https://www.mediamarkt.es/ps5-slim-digital', stock: true, delivery: '1-2', confidence: 0.95),
          ],
        ),
        ProductData(
          id: 'nintendo-switch-oled',
          title: 'Nintendo Switch OLED Blanca',
          brand: 'Nintendo',
          category: 'Gaming',
          upc: '045496453435',
          image: 'https://assets.nintendo.com/image/upload/f_auto,q_auto/ncom/en_US/switch/site-design-update/hardware-lineup-oled-white',
          offers: [
            OfferData(source: 'amazon', price: 299.00, shipping: 0, total: 299.00, url: 'https://www.amazon.es/dp/switch-oled', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 309.00, shipping: 0, total: 309.00, url: 'https://www.pccomponentes.com/switch-oled', stock: true, delivery: '2-3', confidence: 0.96),
            OfferData(source: 'ebay', price: 279.00, shipping: 10.00, total: 289.00, url: 'https://www.ebay.es/itm/switch-oled', stock: true, delivery: '3-5', confidence: 0.80),
          ],
        ),
        // Laptops
        ProductData(
          id: 'macbook-pro-14-m3',
          title: 'MacBook Pro 14 M3 Pro 512GB Space Black',
          brand: 'Apple',
          category: 'Portátiles',
          upc: '194253938224',
          image: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/mbp14-spacegray-select-202310?wid=452&hei=420&fmt=jpeg',
          offers: [
            OfferData(source: 'amazon', price: 1999.00, shipping: 0, total: 1999.00, url: 'https://www.amazon.es/dp/macbook-pro-14-m3', stock: true, delivery: '2-3', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 2049.00, shipping: 0, total: 2049.00, url: 'https://www.pccomponentes.com/macbook-pro-14-m3', stock: true, delivery: '2-4', confidence: 0.96),
          ],
        ),
        ProductData(
          id: 'asus-rog-zephyrus-g14',
          title: 'ASUS ROG Zephyrus G14 RTX 4060 Ryzen 9 32GB',
          brand: 'ASUS',
          category: 'Portátiles',
          upc: '195553658744',
          image: 'https://dlcdnwebimgs.asus.com/gain/3E82C0F8-0E18-4F76-9BAB-5B8A4F9F4F51/w717/h525',
          offers: [
            OfferData(source: 'amazon', price: 1499.00, shipping: 0, total: 1499.00, url: 'https://www.amazon.es/dp/asus-rog-zephyrus-g14', stock: true, delivery: '1-2', confidence: 0.98),
            OfferData(source: 'pccomponentes', price: 1479.00, shipping: 0, total: 1479.00, url: 'https://www.pccomponentes.com/asus-rog-zephyrus-g14', stock: true, delivery: '1-2', confidence: 0.96),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

class ProductDatabase {
  final DateTime lastUpdated;
  final List<SourceData> sources;
  final List<ProductData> products;
  
  ProductDatabase({
    required this.lastUpdated,
    required this.sources,
    required this.products,
  });
  
  factory ProductDatabase.fromJson(Map<String, dynamic> json) {
    return ProductDatabase(
      lastUpdated: DateTime.parse(json['last_updated']),
      sources: (json['sources'] as List)
          .map((s) => SourceData.fromJson(s))
          .toList(),
      products: (json['products'] as List)
          .map((p) => ProductData.fromJson(p))
          .toList(),
    );
  }
}

class SourceData {
  final String id;
  final String name;
  final String logo;
  final String country;
  
  SourceData({
    required this.id,
    required this.name,
    required this.logo,
    required this.country,
  });
  
  factory SourceData.fromJson(Map<String, dynamic> json) {
    return SourceData(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      country: json['country'],
    );
  }
}

class ProductData {
  final String id;
  final String title;
  final String brand;
  final String category;
  final String? upc;
  final String image;
  final List<OfferData> offers;
  
  ProductData({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    this.upc,
    required this.image,
    required this.offers,
  });
  
  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      title: json['title'],
      brand: json['brand'],
      category: json['category'],
      upc: json['upc'],
      image: json['image'],
      offers: (json['offers'] as List)
          .map((o) => OfferData.fromJson(o))
          .toList(),
    );
  }
  
  /// Best offer is the one with lowest total price
  OfferData? get bestOffer {
    if (offers.isEmpty) return null;
    return offers.reduce((a, b) => a.total < b.total ? a : b);
  }
  
  /// Number of offers
  int get offersCount => offers.length;
}

class OfferData {
  final String source;
  final double price;
  final double shipping;
  final double total;
  final String url;
  final bool stock;
  final String delivery;
  final double confidence;
  
  OfferData({
    required this.source,
    required this.price,
    required this.shipping,
    required this.total,
    required this.url,
    required this.stock,
    required this.delivery,
    required this.confidence,
  });
  
  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      source: json['source'],
      price: (json['price'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      url: json['url'],
      stock: json['stock'] ?? true,
      delivery: json['delivery'] ?? 'N/A',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
    );
  }
  
  bool get hasFreeShipping => shipping == 0;
}
