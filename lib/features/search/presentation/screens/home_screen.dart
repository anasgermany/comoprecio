import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/search_bar_widget.dart';
import '../widgets/trending_section.dart';
import '../widgets/recent_searches.dart';
import '../widgets/category_grid.dart';

/// Home screen with search and discovery
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with logo and search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo & Title
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.compare_arrows_rounded,
                            color: AppColors.darkBackground,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ComoPrecio',
                              style: AppTypography.headlineMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Encuentra el mejor precio',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                    
                    const SizedBox(height: 24),
                    
                    // Search Bar
                    const SearchBarWidget()
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 400.ms)
                        .slideY(begin: 0.1),
                    
                    const SizedBox(height: 8),
                    
                    // Scan UPC hint
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          // TODO: Open barcode scanner
                        },
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 18,
                        ),
                        label: const Text('Escanear código de barras'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  ],
                ),
              ),
            ),
            
            // Recent Searches
            const SliverToBoxAdapter(
              child: RecentSearches(),
            ),
            
            // Categories
            const SliverToBoxAdapter(
              child: CategoryGrid(),
            ),
            
            // Trending Products
            const SliverToBoxAdapter(
              child: TrendingSection(),
            ),
            
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
