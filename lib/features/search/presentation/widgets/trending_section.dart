import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Trending products section
class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  // TODO: Replace with actual trending data from API
  static const List<_TrendingProduct> _mockTrending = [
    _TrendingProduct(
      id: '1',
      title: 'iPhone 15 Pro Max 256GB',
      imageUrl: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-max-black-titanium-select?wid=940&hei=1112&fmt=png-alpha',
      minPrice: 1199.00,
      priceChange: -5.2,
      offersCount: 12,
    ),
    _TrendingProduct(
      id: '2',
      title: 'Samsung Galaxy S24 Ultra',
      imageUrl: 'https://images.samsung.com/es/smartphones/galaxy-s24-ultra/images/galaxy-s24-ultra-highlights-color-titanium-gray-mo.jpg',
      minPrice: 1099.00,
      priceChange: -3.8,
      offersCount: 8,
    ),
    _TrendingProduct(
      id: '3',
      title: 'PlayStation 5 Slim',
      imageUrl: 'https://media.direct.playstation.com/is/image/sierequesthandler/ps5-slim-edition-packshot-01-en-28jun23',
      minPrice: 449.00,
      priceChange: -10.0,
      offersCount: 15,
    ),
    _TrendingProduct(
      id: '4',
      title: 'AirPods Pro 2nd Gen',
      imageUrl: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83?wid=1144&hei=1144&fmt=jpeg',
      minPrice: 229.00,
      priceChange: -8.5,
      offersCount: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.trending_down_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Bajadas de precio',
                      style: AppTypography.titleLarge,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    context.push('/search?q=trending');
                  },
                  child: Text(
                    'Ver más',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _mockTrending.length,
              itemBuilder: (context, index) {
                final product = _mockTrending[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < _mockTrending.length - 1 ? 12 : 0,
                  ),
                  child: _TrendingCard(product: product)
                      .animate(delay: Duration(milliseconds: 50 * index))
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: 0.1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingProduct {
  final String id;
  final String title;
  final String imageUrl;
  final double minPrice;
  final double priceChange;
  final int offersCount;

  const _TrendingProduct({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.minPrice,
    required this.priceChange,
    required this.offersCount,
  });
}

class _TrendingCard extends StatelessWidget {
  final _TrendingProduct product;

  const _TrendingCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/product/${product.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.surfaceVariant,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textMuted,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    // Price drop badge
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${product.priceChange.toStringAsFixed(1)}%',
                          style: AppTypography.badge.copyWith(
                            color: AppColors.darkBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                product.title,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Price
              Row(
                children: [
                  Text(
                    '${product.minPrice.toStringAsFixed(2)}€',
                    style: AppTypography.priceMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${product.offersCount} ofertas',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
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
}
