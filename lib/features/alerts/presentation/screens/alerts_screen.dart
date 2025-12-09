import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Alerts list screen
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alertas de precio',
                    style: AppTypography.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Te notificamos cuando baje el precio',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Alerts list
            Expanded(
              child: _mockAlerts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _mockAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = _mockAlerts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AlertCard(alert: alert)
                              .animate(delay: Duration(milliseconds: 50 * index))
                              .fadeIn(duration: 300.ms)
                              .slideX(begin: 0.05),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sin alertas activas',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Busca un producto y crea una\nalerta de precio',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  static final List<_MockAlert> _mockAlerts = [
    _MockAlert(
      id: '1',
      productTitle: 'iPhone 15 Pro Max 256GB',
      productImage: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-max-black-titanium-select?wid=940&hei=1112&fmt=png-alpha',
      targetPrice: 1100.00,
      currentPrice: 1199.00,
      isTriggered: false,
    ),
    _MockAlert(
      id: '2',
      productTitle: 'AirPods Pro 2nd Gen',
      productImage: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83?wid=1144&hei=1144&fmt=jpeg',
      targetPrice: 200.00,
      currentPrice: 199.00,
      isTriggered: true,
    ),
    _MockAlert(
      id: '3',
      productTitle: 'Samsung Galaxy S24 Ultra',
      productImage: 'https://images.samsung.com/es/smartphones/galaxy-s24-ultra/images/galaxy-s24-ultra-highlights-color-titanium-gray-mo.jpg',
      targetPrice: 999.00,
      currentPrice: 1099.00,
      isTriggered: false,
    ),
  ];
}

class _MockAlert {
  final String id;
  final String productTitle;
  final String productImage;
  final double targetPrice;
  final double currentPrice;
  final bool isTriggered;

  const _MockAlert({
    required this.id,
    required this.productTitle,
    required this.productImage,
    required this.targetPrice,
    required this.currentPrice,
    required this.isTriggered,
  });

  double get percentageFromTarget =>
      ((currentPrice - targetPrice) / targetPrice) * 100;
}

class _AlertCard extends StatelessWidget {
  final _MockAlert alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alert.isTriggered
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.surfaceVariant,
          width: alert.isTriggered ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.network(
              alert.productImage,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (alert.isTriggered)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '¡PRECIO ALCANZADO!',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.darkBackground,
                      ),
                    ),
                  ),
                Text(
                  alert.productTitle,
                  style: AppTypography.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Objetivo: ${alert.targetPrice.toStringAsFixed(0)}€',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Actual: ${alert.currentPrice.toStringAsFixed(0)}€',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Progress indicator
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      value: alert.isTriggered
                          ? 1.0
                          : (alert.targetPrice / alert.currentPrice).clamp(0, 1),
                      backgroundColor: AppColors.surfaceVariant,
                      color: alert.isTriggered
                          ? AppColors.primary
                          : AppColors.accent,
                      strokeWidth: 4,
                    ),
                  ),
                  Icon(
                    alert.isTriggered
                        ? Icons.check_rounded
                        : Icons.trending_down_rounded,
                    size: 20,
                    color: alert.isTriggered
                        ? AppColors.primary
                        : AppColors.accent,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                alert.isTriggered
                    ? '¡Listo!'
                    : '${alert.percentageFromTarget.toStringAsFixed(0)}%',
                style: AppTypography.labelSmall.copyWith(
                  color: alert.isTriggered
                      ? AppColors.primary
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
