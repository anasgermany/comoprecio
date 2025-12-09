import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'product.dart';

part 'alert.g.dart';

/// Price alert entity
@JsonSerializable()
class PriceAlert extends Equatable {
  final String id;
  final String userId;
  final String productId;
  final Product? product;
  final double targetPriceEur;
  final double? currentMinPrice;
  final bool active;
  final bool triggered;
  final DateTime? triggeredAt;
  final DateTime createdAt;

  const PriceAlert({
    required this.id,
    required this.userId,
    required this.productId,
    this.product,
    required this.targetPriceEur,
    this.currentMinPrice,
    required this.active,
    required this.triggered,
    this.triggeredAt,
    required this.createdAt,
  });

  /// Check if current price meets target
  bool get targetMet =>
      currentMinPrice != null && currentMinPrice! <= targetPriceEur;

  /// Get percentage difference from target
  double? get percentageFromTarget {
    if (currentMinPrice == null) return null;
    return ((currentMinPrice! - targetPriceEur) / targetPriceEur) * 100;
  }

  /// Get status label
  String get statusLabel {
    if (!active) return 'Pausada';
    if (triggered) return '¡Precio alcanzado!';
    if (targetMet) return '¡Disponible!';
    return 'Monitoreando';
  }

  factory PriceAlert.fromJson(Map<String, dynamic> json) =>
      _$PriceAlertFromJson(json);

  Map<String, dynamic> toJson() => _$PriceAlertToJson(this);

  PriceAlert copyWith({
    String? id,
    String? userId,
    String? productId,
    Product? product,
    double? targetPriceEur,
    double? currentMinPrice,
    bool? active,
    bool? triggered,
    DateTime? triggeredAt,
    DateTime? createdAt,
  }) {
    return PriceAlert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      targetPriceEur: targetPriceEur ?? this.targetPriceEur,
      currentMinPrice: currentMinPrice ?? this.currentMinPrice,
      active: active ?? this.active,
      triggered: triggered ?? this.triggered,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, productId, targetPriceEur, active];
}
