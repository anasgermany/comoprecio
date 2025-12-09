import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/github_data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/search_bar_widget.dart';
import '../widgets/filter_bar.dart';

/// Search results screen - uses GitHubDataService for real data
class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool _isLoading = true;
  List<ProductData> _results = [];
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);
    
    try {
      final results = await GitHubDataService.instance.searchProducts(_currentQuery);
      setState(() {
        _isLoading = false;
        _results = results;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _results = [];
      });
    }
  }

  void _onSearch(String query) {
    setState(() => _currentQuery = query);
    _loadResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar header
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => context.go('/'),
                  ),
                  Expanded(
                    child: SearchBarWidget(
                      initialQuery: _currentQuery,
                      autofocus: false,
                      onSubmitted: _onSearch,
                    ),
                  ),
                ],
              ),
            ),

            // Filter bar
            const FilterBar(),

            // Search query label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'Resultados para '),
                          TextSpan(
                            text: '"$_currentQuery"',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!_isLoading)
                    Text(
                      '${_results.length} productos',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),

            // Results list
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _results.isEmpty
                      ? _buildEmptyState()
                      : _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
          ),
        ).animate(onPlay: (c) => c.repeat())
            .shimmer(
              duration: 1500.ms,
              color: AppColors.surfaceBright.withValues(alpha: 0.3),
            );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron resultados',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con "$_currentQuery" escrito de otra forma',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final product = _results[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ProductCard(product: product)
              .animate(delay: Duration(milliseconds: 50 * index))
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.1),
        );
      },
    );
  }
}

/// Product card for search results - uses real ProductData
class _ProductCard extends StatelessWidget {
  final ProductData product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final bestOffer = product.bestOffer;
    
    return GestureDetector(
      onTap: () => context.go('/product/${product.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.surfaceVariant,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textMuted,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.brand,
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    product.title,
                    style: AppTypography.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price and store
                  if (bestOffer != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${bestOffer.total.toStringAsFixed(2)}€',
                          style: AppTypography.priceMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (bestOffer.shipping > 0)
                          Text(
                            '+${bestOffer.shipping.toStringAsFixed(0)}€ envío',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.accent,
                            ),
                          )
                        else
                          Row(
                            children: [
                              const Icon(
                                Icons.local_shipping_outlined,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Gratis',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Store and delivery
                    Row(
                      children: [
                        _getSourceWidget(bestOffer.source),
                        const Spacer(),
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bestOffer.delivery.contains('-') 
                              ? '${bestOffer.delivery} días'
                              : bestOffer.delivery,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${product.offersCount} ofertas',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSourceWidget(String sourceId) {
    final sources = {
      'amazon': ('Amazon', '🛒'),
      'pccomponentes': ('PCComponentes', '🖥️'),
      'mediamarkt': ('MediaMarkt', '🔴'),
      'aliexpress': ('AliExpress', '🇨🇳'),
      'ebay': ('eBay', '🏷️'),
      'fnac': ('Fnac', '📀'),
      'carrefour': ('Carrefour', '🛒'),
    };
    
    final source = sources[sourceId] ?? (sourceId, '🏪');
    
    return Row(
      children: [
        Text(source.$2, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(
          source.$1,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
