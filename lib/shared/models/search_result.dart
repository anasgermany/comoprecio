import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'product.dart';

part 'search_result.g.dart';

/// Search response wrapper
@JsonSerializable()
class SearchResponse extends Equatable {
  final List<ProductSummary> results;
  final int total;
  final String query;
  final SearchFilters? filtersApplied;

  const SearchResponse({
    required this.results,
    required this.total,
    required this.query,
    this.filtersApplied,
  });

  bool get hasResults => results.isNotEmpty;
  bool get hasMore => results.length < total;

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);

  @override
  List<Object?> get props => [results, total, query];
}

/// Product summary for search results
@JsonSerializable()
class ProductSummary extends Equatable {
  final String id;
  final String title;
  final String? brand;
  final String? imageUrl;
  final double? minPriceEur;
  final int offersCount;
  final OfferSummary? bestOffer;

  const ProductSummary({
    required this.id,
    required this.title,
    this.brand,
    this.imageUrl,
    this.minPriceEur,
    required this.offersCount,
    this.bestOffer,
  });

  String get displayTitle => brand != null ? '$brand $title' : title;

  factory ProductSummary.fromJson(Map<String, dynamic> json) =>
      _$ProductSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSummaryToJson(this);

  @override
  List<Object?> get props => [id, title, minPriceEur];
}

/// Minimal offer info for listing
@JsonSerializable()
class OfferSummary extends Equatable {
  final String sourceName;
  final double totalPriceEur;
  final double shippingCost;
  final String? deliveryDays;
  final bool inStock;

  const OfferSummary({
    required this.sourceName,
    required this.totalPriceEur,
    required this.shippingCost,
    this.deliveryDays,
    required this.inStock,
  });

  bool get hasFreeShipping => shippingCost == 0;

  factory OfferSummary.fromJson(Map<String, dynamic> json) =>
      _$OfferSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$OfferSummaryToJson(this);

  @override
  List<Object?> get props => [sourceName, totalPriceEur];
}

/// Search filters
@JsonSerializable()
class SearchFilters extends Equatable {
  final String? country;
  final int? maxDeliveryDays;
  final bool? freeShipping;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? sources;
  final SearchSortOrder sortOrder;

  const SearchFilters({
    this.country,
    this.maxDeliveryDays,
    this.freeShipping,
    this.minPrice,
    this.maxPrice,
    this.sources,
    this.sortOrder = SearchSortOrder.priceAsc,
  });

  bool get hasFilters =>
      country != null ||
      maxDeliveryDays != null ||
      freeShipping == true ||
      minPrice != null ||
      maxPrice != null ||
      sources != null;

  factory SearchFilters.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFiltersToJson(this);

  SearchFilters copyWith({
    String? country,
    int? maxDeliveryDays,
    bool? freeShipping,
    double? minPrice,
    double? maxPrice,
    List<String>? sources,
    SearchSortOrder? sortOrder,
  }) {
    return SearchFilters(
      country: country ?? this.country,
      maxDeliveryDays: maxDeliveryDays ?? this.maxDeliveryDays,
      freeShipping: freeShipping ?? this.freeShipping,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sources: sources ?? this.sources,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
        country,
        maxDeliveryDays,
        freeShipping,
        minPrice,
        maxPrice,
        sources,
        sortOrder,
      ];
}

/// Sort order for search results
enum SearchSortOrder {
  @JsonValue('price_asc')
  priceAsc,
  @JsonValue('price_desc')
  priceDesc,
  @JsonValue('relevance')
  relevance;

  String get label {
    switch (this) {
      case SearchSortOrder.priceAsc:
        return 'Precio: menor a mayor';
      case SearchSortOrder.priceDesc:
        return 'Precio: mayor a menor';
      case SearchSortOrder.relevance:
        return 'Relevancia';
    }
  }

  String get apiValue {
    switch (this) {
      case SearchSortOrder.priceAsc:
        return 'price_asc';
      case SearchSortOrder.priceDesc:
        return 'price_desc';
      case SearchSortOrder.relevance:
        return 'relevance';
    }
  }
}
