import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Horizontal filter bar for search results
class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String _selectedSort = 'price_asc';
  bool _freeShippingOnly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Sort dropdown
          _FilterChip(
            label: 'Precio ↑',
            icon: Icons.sort_rounded,
            isSelected: true,
            onTap: () {
              _showSortModal(context);
            },
          ),
          const SizedBox(width: 8),
          
          // Free shipping toggle
          _FilterChip(
            label: 'Envío gratis',
            icon: Icons.local_shipping_outlined,
            isSelected: _freeShippingOnly,
            onTap: () {
              setState(() {
                _freeShippingOnly = !_freeShippingOnly;
              });
            },
          ),
          const SizedBox(width: 8),
          
          // Country filter
          _FilterChip(
            label: 'País',
            icon: Icons.public_rounded,
            isSelected: false,
            onTap: () {
              _showCountryModal(context);
            },
          ),
          const SizedBox(width: 8),
          
          // Delivery time filter
          _FilterChip(
            label: 'Entrega',
            icon: Icons.schedule_rounded,
            isSelected: false,
            onTap: () {
              _showDeliveryModal(context);
            },
          ),
          const SizedBox(width: 8),
          
          // Store filter
          _FilterChip(
            label: 'Tienda',
            icon: Icons.store_rounded,
            isSelected: false,
            onTap: () {
              _showStoreModal(context);
            },
          ),
        ],
      ),
    );
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ordenar por',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 16),
            _SortOption(
              label: 'Precio: menor a mayor',
              isSelected: _selectedSort == 'price_asc',
              onTap: () {
                setState(() => _selectedSort = 'price_asc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Precio: mayor a menor',
              isSelected: _selectedSort == 'price_desc',
              onTap: () {
                setState(() => _selectedSort = 'price_desc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Relevancia',
              isSelected: _selectedSort == 'relevance',
              onTap: () {
                setState(() => _selectedSort = 'relevance');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCountryModal(BuildContext context) {
    // TODO: Implement country filter modal
  }

  void _showDeliveryModal(BuildContext context) {
    // TODO: Implement delivery time filter modal
  }

  void _showStoreModal(BuildContext context) {
    // TODO: Implement store filter modal
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: AppTypography.bodyLarge.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      contentPadding: EdgeInsets.zero,
    );
  }
}
