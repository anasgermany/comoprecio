import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

/// Product search and data service using Supabase
class ProductService {
  final SupabaseClient _client;
  
  ProductService() : _client = SupabaseConfig.client;
  
  /// Search products by keyword
  /// Uses the search_products SQL function for full-text search
  Future<List<ProductSearchResult>> searchProducts(
    String query, {
    int limit = 20,
  }) async {
    // Call the search function
    final response = await _client
        .rpc('search_products', params: {
          'search_query': query,
          'result_limit': limit,
        });
    
    if (response == null) return [];
    
    return (response as List)
        .map((row) => ProductSearchResult.fromJson(row))
        .toList();
  }
  
  /// Get product details with all offers
  Future<ProductDetail?> getProduct(String productId) async {
    // Get product
    final productResponse = await _client
        .from('products')
        .select()
        .eq('id', productId)
        .single();
    
    if (productResponse == null) return null;
    
    // Get offers with source info
    final offersResponse = await _client
        .from('offers')
        .select('''
          *,
          sources:source_id (name, logo_emoji, country)
        ''')
        .eq('product_id', productId)
        .order('total_price_eur', ascending: true);
    
    final offers = (offersResponse as List)
        .map((row) => OfferDetail.fromJson(row))
        .toList();
    
    return ProductDetail.fromJson(productResponse, offers);
  }
  
  /// Get price history for a product
  Future<List<PriceHistoryPoint>> getPriceHistory(
    String productId, {
    int days = 30,
  }) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    
    final response = await _client
        .from('price_history')
        .select('''
          price_eur,
          recorded_at,
          sources:source_id (name)
        ''')
        .eq('product_id', productId)
        .gte('recorded_at', cutoff.toIso8601String())
        .order('recorded_at', ascending: true);
    
    return (response as List)
        .map((row) => PriceHistoryPoint.fromJson(row))
        .toList();
  }
  
  /// Get all sources (stores)
  Future<List<StoreSource>> getSources() async {
    final response = await _client
        .from('sources')
        .select()
        .eq('active', true)
        .order('name');
    
    return (response as List)
        .map((row) => StoreSource.fromJson(row))
        .toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

class ProductSearchResult {
  final String id;
  final String title;
  final String? brand;
  final String? imageUrl;
  final String? category;
  final double? minPrice;
  final int offersCount;
  final double rank;
  
  ProductSearchResult({
    required this.id,
    required this.title,
    this.brand,
    this.imageUrl,
    this.category,
    this.minPrice,
    required this.offersCount,
    required this.rank,
  });
  
  factory ProductSearchResult.fromJson(Map<String, dynamic> json) {
    return ProductSearchResult(
      id: json['id'],
      title: json['canonical_title'],
      brand: json['brand'],
      imageUrl: json['canonical_image_url'],
      category: json['category'],
      minPrice: json['min_price_eur']?.toDouble(),
      offersCount: json['offers_count'] ?? 0,
      rank: json['rank']?.toDouble() ?? 0,
    );
  }
}

class ProductDetail {
  final String id;
  final String title;
  final String? brand;
  final String? description;
  final String? imageUrl;
  final String? category;
  final String? upc;
  final String? asin;
  final double? minPrice;
  final List<OfferDetail> offers;
  
  ProductDetail({
    required this.id,
    required this.title,
    this.brand,
    this.description,
    this.imageUrl,
    this.category,
    this.upc,
    this.asin,
    this.minPrice,
    required this.offers,
  });
  
  factory ProductDetail.fromJson(Map<String, dynamic> json, List<OfferDetail> offers) {
    return ProductDetail(
      id: json['id'],
      title: json['canonical_title'],
      brand: json['brand'],
      description: json['description'],
      imageUrl: json['canonical_image_url'],
      category: json['category'],
      upc: json['upc'],
      asin: json['asin'],
      minPrice: json['min_price_eur']?.toDouble(),
      offers: offers,
    );
  }
}

class OfferDetail {
  final String id;
  final double price;
  final String currency;
  final double shippingCost;
  final double taxEstimate;
  final double totalPriceEur;
  final String url;
  final String? sellerName;
  final String? sellerType;
  final double confidenceScore;
  final int? deliveryDaysMin;
  final int? deliveryDaysMax;
  final bool inStock;
  final DateTime lastChecked;
  final String sourceName;
  final String? sourceLogo;
  final String? sourceCountry;
  
  OfferDetail({
    required this.id,
    required this.price,
    required this.currency,
    required this.shippingCost,
    required this.taxEstimate,
    required this.totalPriceEur,
    required this.url,
    this.sellerName,
    this.sellerType,
    required this.confidenceScore,
    this.deliveryDaysMin,
    this.deliveryDaysMax,
    required this.inStock,
    required this.lastChecked,
    required this.sourceName,
    this.sourceLogo,
    this.sourceCountry,
  });
  
  factory OfferDetail.fromJson(Map<String, dynamic> json) {
    final source = json['sources'] as Map<String, dynamic>?;
    return OfferDetail(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] ?? 'EUR',
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0,
      taxEstimate: (json['tax_estimate'] as num?)?.toDouble() ?? 0,
      totalPriceEur: (json['total_price_eur'] as num).toDouble(),
      url: json['url'],
      sellerName: json['seller_name'],
      sellerType: json['seller_type'],
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 1.0,
      deliveryDaysMin: json['delivery_days_min'],
      deliveryDaysMax: json['delivery_days_max'],
      inStock: json['in_stock'] ?? true,
      lastChecked: DateTime.parse(json['last_checked']),
      sourceName: source?['name'] ?? 'Unknown',
      sourceLogo: source?['logo_emoji'],
      sourceCountry: source?['country'],
    );
  }
  
  String get deliveryDaysText {
    if (deliveryDaysMin == null && deliveryDaysMax == null) return 'N/A';
    if (deliveryDaysMin == deliveryDaysMax) return '$deliveryDaysMin días';
    return '$deliveryDaysMin-$deliveryDaysMax días';
  }
}

class PriceHistoryPoint {
  final double price;
  final DateTime date;
  final String? sourceName;
  
  PriceHistoryPoint({
    required this.price,
    required this.date,
    this.sourceName,
  });
  
  factory PriceHistoryPoint.fromJson(Map<String, dynamic> json) {
    final source = json['sources'] as Map<String, dynamic>?;
    return PriceHistoryPoint(
      price: (json['price_eur'] as num).toDouble(),
      date: DateTime.parse(json['recorded_at']),
      sourceName: source?['name'],
    );
  }
}

class StoreSource {
  final String id;
  final String name;
  final String baseUrl;
  final String country;
  final String sourceType;
  final String? logoEmoji;
  final bool active;
  
  StoreSource({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.country,
    required this.sourceType,
    this.logoEmoji,
    required this.active,
  });
  
  factory StoreSource.fromJson(Map<String, dynamic> json) {
    return StoreSource(
      id: json['id'],
      name: json['name'],
      baseUrl: json['base_url'],
      country: json['country'],
      sourceType: json['source_type'],
      logoEmoji: json['logo_emoji'],
      active: json['active'] ?? true,
    );
  }
}
