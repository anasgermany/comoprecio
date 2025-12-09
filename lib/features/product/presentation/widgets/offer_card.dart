import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../screens/product_detail_screen.dart';

/// Offer card for product detail
class OfferCard extends StatelessWidget {
  final dynamic offer; // _MockOffer from product_detail_screen
  final bool isbestPrice;

  const OfferCard({
    super.key,
    required this.offer,
    this.isbestPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openUrl(offer.url),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isbestPrice
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.surfaceVariant,
              width: isbestPrice ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        offer.storeLogo,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Store info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              offer.storeName,
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(width: 8),
                            if (isbestPrice)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'MEJOR PRECIO',
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.darkBackground,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              offer.sellerType,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _ConfidenceBadge(score: offer.confidenceScore),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${offer.totalPrice.toStringAsFixed(2)}€',
                        style: AppTypography.priceLarge.copyWith(
                          color: isbestPrice
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (offer.shippingCost > 0) ...[
                        Text(
                          '${offer.price.toStringAsFixed(2)}€ + ${offer.shippingCost.toStringAsFixed(2)}€',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Envío gratis',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Bottom row
              Row(
                children: [
                  // Delivery
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${offer.deliveryDays} días',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Stock
                  Icon(
                    offer.inStock
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    size: 14,
                    color: offer.inStock
                        ? AppColors.inStock
                        : AppColors.outOfStock,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    offer.inStock ? 'En stock' : 'Sin stock',
                    style: AppTypography.labelSmall.copyWith(
                      color: offer.inStock
                          ? AppColors.inStock
                          : AppColors.outOfStock,
                    ),
                  ),
                  const Spacer(),

                  // Last checked
                  Text(
                    _formatLastChecked(offer.lastChecked),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),

                  // Go arrow
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: AppColors.darkBackground,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastChecked(DateTime lastChecked) {
    final diff = DateTime.now().difference(lastChecked);
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours}h';
    } else {
      return 'Hace ${diff.inDays}d';
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final double score;

  const _ConfidenceBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (score >= 0.9) {
      color = AppColors.confidenceHigh;
      label = 'Alta coincidencia';
    } else if (score >= 0.7) {
      color = AppColors.confidenceMedium;
      label = 'Media coincidencia';
    } else {
      color = AppColors.confidenceLow;
      label = 'Baja coincidencia';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${(score * 100).toInt()}%',
          style: AppTypography.labelSmall.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
