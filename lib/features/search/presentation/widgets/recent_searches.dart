import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Recent searches section
class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  // TODO: Replace with actual data from local storage
  static const List<String> _mockSearches = [
    'iPhone 15 Pro',
    'Samsung Galaxy S24',
    'AirPods Pro',
    'PlayStation 5',
    'Nintendo Switch OLED',
  ];

  @override
  Widget build(BuildContext context) {
    if (_mockSearches.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Búsquedas recientes',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Clear search history
                },
                child: Text(
                  'Limpiar',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _mockSearches.asMap().entries.map((entry) {
              return _SearchChip(
                label: entry.value,
                onTap: () {
                  context.push('/search?q=${Uri.encodeComponent(entry.value)}');
                },
              ).animate(delay: Duration(milliseconds: 50 * entry.key))
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: 0.1);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SearchChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.history_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
