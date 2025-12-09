import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch AliExpress product data from GitHub JSON
class AliExpressService {
  // GitHub raw URLs for AliExpress products
  static const List<String> _aliExpressUrls = [
    'https://raw.githubusercontent.com/anasgermany/Anas/master/WomenBags1.json',
    'https://raw.githubusercontent.com/anasgermany/comoprecio/main/data/aliexpress_products.json',
    'https://raw.githubusercontent.com/anasgermany/comoprecio/main/data/aliexpress_sexy_women.json',
    // Add more category URLs here
  ];
  
  static AliExpressService? _instance;
  List<AliExpressProduct>? _cachedProducts;
  DateTime? _lastFetch;
  
  AliExpressService._();
  
  static AliExpressService get instance {
    _instance ??= AliExpressService._();
    return _instance!;
  }
  
  /// Fetch all AliExpress products from GitHub
  Future<List<AliExpressProduct>> getProducts() async {
    // Return cached if less than 1 hour old
    if (_cachedProducts != null && _lastFetch != null) {
      if (DateTime.now().difference(_lastFetch!).inMinutes < 60) {
        return _cachedProducts!;
      }
    }
    
    final allProducts = <AliExpressProduct>[];
    
    for (final url in _aliExpressUrls) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          // Handle both single products and lists
          if (data is List) {
            for (final item in data) {
              final product = AliExpressProduct.fromJson(item);
              if (product.isValid) {
                allProducts.add(product);
              }
            }
          } else if (data is Map<String, dynamic>) {
            if (data.containsKey('products')) {
              for (final item in data['products']) {
                final product = AliExpressProduct.fromJson(item);
                if (product.isValid) {
                  allProducts.add(product);
                }
              }
            } else {
              final product = AliExpressProduct.fromJson(data);
              if (product.isValid) {
                allProducts.add(product);
              }
            }
          }
        }
      } catch (e) {
        print('Error fetching AliExpress data from $url: $e');
      }
    }
    
    _cachedProducts = allProducts;
    _lastFetch = DateTime.now();
    return allProducts;
  }
  
  /// Search AliExpress products
  Future<List<AliExpressProduct>> searchProducts(String query) async {
    final products = await getProducts();
    final queryLower = query.toLowerCase();
    
    return products.where((p) {
      return p.title.toLowerCase().contains(queryLower);
    }).toList();
  }
}

/// AliExpress product model matching the JSON structure
class AliExpressProduct {
  final String productId;
  final String imageUrl;
  final String? videoUrl;
  final String title;
  final String originPrice;
  final String discountPrice;
  final String discount;
  final String currency;
  final double commissionRate;
  final String commission;
  final int sales;
  final String feedback;
  final String url;
  final String? store;
  
  AliExpressProduct({
    required this.productId,
    required this.imageUrl,
    this.videoUrl,
    required this.title,
    required this.originPrice,
    required this.discountPrice,
    required this.discount,
    required this.currency,
    required this.commissionRate,
    required this.commission,
    required this.sales,
    required this.feedback,
    required this.url,
    this.store,
  });
  
  factory AliExpressProduct.fromJson(Map<String, dynamic> json) {
    return AliExpressProduct(
      productId: (json['ProductId'] ?? json['productId'] ?? '').toString(),
      imageUrl: json['Image Url'] ?? json['ImageUrl'] ?? json['image'] ?? '',
      videoUrl: json['Video Url'] ?? json['VideoUrl'],
      title: json['Product Desc'] ?? json['ProductDesc'] ?? json['title'] ?? '',
      originPrice: json['Origin Price'] ?? json['OriginPrice'] ?? '',
      discountPrice: json['Discount Price'] ?? json['DiscountPrice'] ?? '',
      discount: json['Discount'] ?? json['discount'] ?? '',
      currency: json['Currency'] ?? 'USD',
      commissionRate: (json['Commission Rate'] ?? json['CommissionRate'] ?? 0).toDouble(),
      commission: json['Commission'] ?? '',
      sales: json['Sales180Day'] ?? json['sales'] ?? 0,
      feedback: json['Positive Feedback'] ?? json['PositiveFeedback'] ?? '',
      url: json['Promotion Url'] ?? json['PromotionUrl'] ?? json['url'] ?? '',
      store: json['Store'] ?? json['store'],
    );
  }
  
  bool get isValid => 
      productId.isNotEmpty && 
      title.isNotEmpty && 
      imageUrl.isNotEmpty;
  
  /// Parse price from string like "USD 15.31" -> 15.31
  double? get parsedPrice {
    final match = RegExp(r'[\d,.]+').firstMatch(discountPrice);
    if (match != null) {
      return double.tryParse(match.group(0)!.replaceAll(',', '.'));
    }
    return null;
  }
  
  /// Parse original price
  double? get parsedOriginPrice {
    final match = RegExp(r'[\d,.]+').firstMatch(originPrice);
    if (match != null) {
      return double.tryParse(match.group(0)!.replaceAll(',', '.'));
    }
    return null;
  }
  
  /// Get discount percentage as int
  int? get discountPercent {
    final match = RegExp(r'(\d+)').firstMatch(discount);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }
}
