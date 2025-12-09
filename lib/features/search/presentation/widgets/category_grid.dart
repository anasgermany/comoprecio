import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Category grid for quick navigation
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const List<_Category> _categories = [
    _Category(
      name: 'Electrónica',
      icon: Icons.devices_rounded,
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
      query: 'electronics',
    ),
    _Category(
      name: 'Móviles',
      icon: Icons.smartphone_rounded,
      gradient: [Color(0xFF11998e), Color(0xFF38ef7d)],
      query: 'smartphones',
    ),
    _Category(
      name: 'Gaming',
      icon: Icons.sports_esports_rounded,
      gradient: [Color(0xFFf093fb), Color(0xFFf5576c)],
      query: 'gaming',
    ),
    _Category(
      name: 'Audio',
      icon: Icons.headphones_rounded,
      gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      query: 'audio headphones',
    ),
    _Category(
      name: 'Hogar',
      icon: Icons.home_rounded,
      gradient: [Color(0xFFfa709a), Color(0xFFfee140)],
      query: 'home appliances',
    ),
    _Category(
      name: 'Moda',
      icon: Icons.checkroom_rounded,
      gradient: [Color(0xFFa8edea), Color(0xFFfed6e3)],
      query: 'fashion',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categorías',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _CategoryCard(category: category)
                  .animate(delay: Duration(milliseconds: 50 * index))
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.9, 0.9));
            },
          ),
        ],
      ),
    );
  }
}

class _Category {
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final String query;

  const _Category({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.query,
  });
}

class _CategoryCard extends StatelessWidget {
  final _Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/search?q=${Uri.encodeComponent(category.query)}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: category.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: category.gradient[0].withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
