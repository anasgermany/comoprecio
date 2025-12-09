import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

/// Canonical Product entity
@JsonSerializable()
class Product extends Equatable {
  final String id;
  final String canonicalTitle;
  final String? brand;
  final String? upc;
  final String? ean;
  final String? asin;
  final String? description;
  final String? canonicalImageUrl;
  final String? category;
  final Map<String, dynamic>? attributes;
  final double? minPriceEur;
  final int offersCount;
  final Offer? bestOffer;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.canonicalTitle,
    this.brand,
    this.upc,
    this.ean,
    this.asin,
    this.description,
    this.canonicalImageUrl,
    this.category,
    this.attributes,
    this.minPriceEur,
    this.offersCount = 0,
    this.bestOffer,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Display title (brand + title or just title)
  String get displayTitle {
    if (brand != null && brand!.isNotEmpty) {
      return '$brand $canonicalTitle';
    }
    return canonicalTitle;
  }

  /// Short title (truncated)
  String get shortTitle {
    const maxLength = 60;
    if (canonicalTitle.length <= maxLength) return canonicalTitle;
    return '${canonicalTitle.substring(0, maxLength)}...';
  }

  /// Check if has any identifier
  bool get hasIdentifier => upc != null || ean != null || asin != null;

  /// Get primary identifier
  String? get primaryIdentifier => upc ?? ean ?? asin;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [
        id,
        canonicalTitle,
        brand,
        upc,
        ean,
        asin,
        minPriceEur,
      ];
}

/// Price Offer from a source/store
@JsonSerializable()
class Offer extends Equatable {
  final String id;
  final String productId;
  final String sourceId;
  final String sourceName;
  final String? sourceLogo;
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
  final DateTime createdAt;

  const Offer({
    required this.id,
    required this.productId,
    required this.sourceId,
    required this.sourceName,
    this.sourceLogo,
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
    required this.createdAt,
  });

  /// Format delivery time as string
  String get deliveryTimeText {
    if (deliveryDaysMin == null && deliveryDaysMax == null) {
      return 'Desconocido';
    }
    if (deliveryDaysMin == deliveryDaysMax) {
      return '$deliveryDaysMin días';
    }
    return '$deliveryDaysMin-$deliveryDaysMax días';
  }

  /// Check if shipping is free
  bool get hasFreeShipping => shippingCost == 0;

  /// Get confidence level
  ConfidenceLevel get confidenceLevel {
    if (confidenceScore >= 0.9) return ConfidenceLevel.high;
    if (confidenceScore >= 0.7) return ConfidenceLevel.medium;
    return ConfidenceLevel.low;
  }

  /// Time since last check
  Duration get timeSinceLastCheck => DateTime.now().difference(lastChecked);

  /// Check if data is stale (> 6 hours)
  bool get isStale => timeSinceLastCheck.inHours > 6;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

  @override
  List<Object?> get props => [id, productId, sourceId, totalPriceEur, url];
}

/// Confidence level for product matching
enum ConfidenceLevel {
  high,
  medium,
  low;

  String get label {
    switch (this) {
      case ConfidenceLevel.high:
        return 'Alta';
      case ConfidenceLevel.medium:
        return 'Media';
      case ConfidenceLevel.low:
        return 'Baja';
    }
  }
}

/// Source/Store entity
@JsonSerializable()
class Source extends Equatable {
  final String id;
  final String name;
  final String baseUrl;
  final String country;
  final String sourceType;
  final String? logoUrl;
  final bool active;

  const Source({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.country,
    required this.sourceType,
    this.logoUrl,
    required this.active,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);

  @override
  List<Object?> get props => [id, name, baseUrl, country];
}
