import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/offer_card.dart';
import '../widgets/price_chart.dart';
import 'offer_comparison_screen.dart';

/// Product detail screen with offers comparison
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  _MockProductDetail? _product;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _isLoading = false;
      _product = _getMockProduct();
    });
  }

  _MockProductDetail _getMockProduct() {
    return _MockProductDetail(
      id: widget.productId,
      title: 'iPhone 15 Pro Max 256GB Natural Titanium',
      brand: 'Apple',
      description: 'El iPhone 15 Pro Max cuenta con un diseño de titanio de calidad aeroespacial, el chip A17 Pro, un sistema de cámara Pro de 48MP con zoom óptico 5x, y el botón de Acción.',
      imageUrl: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-max-black-titanium-select?wid=940&hei=1112&fmt=png-alpha',
      upc: '194253401285',
      category: 'Smartphones',
      offers: [
        _MockOffer(
          id: '1',
          storeName: 'Amazon',
          storeLogo: '🛒',
          price: 1199.00,
          shippingCost: 0,
          totalPrice: 1199.00,
          deliveryDays: '1-2',
          sellerType: 'Oficial',
          confidenceScore: 0.98,
          inStock: true,
          url: 'https://amazon.es/dp/B0CHJR9BQG',
          lastChecked: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        _MockOffer(
          id: '2',
          storeName: 'PCComponentes',
          storeLogo: '🖥️',
          price: 1209.00,
          shippingCost: 0,
          totalPrice: 1209.00,
          deliveryDays: '2-3',
          sellerType: 'Oficial',
          confidenceScore: 0.96,
          inStock: true,
          url: 'https://pccomponentes.com/apple-iphone-15-pro-max',
          lastChecked: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        _MockOffer(
          id: '3',
          storeName: 'MediaMarkt',
          storeLogo: '🔴',
          price: 1219.00,
          shippingCost: 0,
          totalPrice: 1219.00,
          deliveryDays: '1-2',
          sellerType: 'Oficial',
          confidenceScore: 0.95,
          inStock: true,
          url: 'https://mediamarkt.es/iphone-15-pro-max',
          lastChecked: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        _MockOffer(
          id: '4',
          storeName: 'AliExpress',
          storeLogo: '🇨🇳',
          price: 1089.00,
          shippingCost: 25.00,
          totalPrice: 1114.00,
          deliveryDays: '10-20',
          sellerType: 'Vendedor',
          confidenceScore: 0.82,
          inStock: true,
          url: 'https://aliexpress.com/item/iphone-15-pro-max',
          lastChecked: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        _MockOffer(
          id: '5',
          storeName: 'eBay',
          storeLogo: '🏷️',
          price: 1150.00,
          shippingCost: 15.00,
          totalPrice: 1165.00,
          deliveryDays: '5-7',
          sellerType: 'Vendedor',
          confidenceScore: 0.78,
          inStock: true,
          url: 'https://ebay.es/itm/iphone-15-pro-max',
          lastChecked: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: AppColors.darkBackground,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.share_rounded),
                      ),
                      onPressed: () {
                        // TODO: Share product
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(40),
                      child: Hero(
                        tag: 'product_${widget.productId}',
                        child: Image.network(
                          _product!.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand
                        Text(
                          _product!.brand,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ).animate().fadeIn(duration: 300.ms),
                        const SizedBox(height: 4),

                        // Title
                        Text(
                          _product!.title,
                          style: AppTypography.headlineMedium,
                        ).animate().fadeIn(delay: 50.ms, duration: 300.ms),
                        const SizedBox(height: 8),

                        // Category & UPC
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _product!.category,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'UPC: ${_product!.upc}',
                              style: AppTypography.mono.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                        const SizedBox(height: 16),

                        // Best price highlight
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.15),
                                AppColors.primary.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mejor precio',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_product!.offers.first.totalPrice.toStringAsFixed(2)}€',
                                    style: AppTypography.priceXLarge.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _product!.offers.first.storeName,
                                    style: AppTypography.titleMedium,
                                  ),
                                  Text(
                                    'Envío gratis · ${_product!.offers.first.deliveryDays} días',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 150.ms, duration: 300.ms)
                            .slideY(begin: 0.1),
                        const SizedBox(height: 16),

                        // Create alert button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showCreateAlertModal(context);
                            },
                            icon: const Icon(Icons.notifications_outlined),
                            label: const Text('Crear alerta de precio'),
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                        const SizedBox(height: 24),

                        // Price history chart
                        const PriceChart(),
                        const SizedBox(height: 24),

                        // All offers header with compare button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ofertas',
                              style: AppTypography.titleLarge,
                            ),
                            TextButton.icon(
                              onPressed: () => _openCompareScreen(context),
                              icon: const Icon(Icons.compare_arrows_rounded, size: 16),
                              label: Text('Comparar (${_product!.offers.length})'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.secondary,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // Offers list
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final offer = _product!.offers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OfferCard(
                            offer: offer,
                            isbestPrice: index == 0,
                          ).animate(delay: Duration(milliseconds: 50 * index))
                              .fadeIn(duration: 300.ms)
                              .slideX(begin: 0.05),
                        );
                      },
                      childCount: _product!.offers.length,
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
    );
  }

  void _openCompareScreen(BuildContext context) {
    // Convert mock offers to comparison offers
    final comparisonOffers = _product!.offers.map((o) {
      final deliveryParts = o.deliveryDays.split('-');
      return ComparisonOffer(
        id: o.id,
        storeName: o.storeName,
        storeLogo: o.storeLogo,
        price: o.price,
        currency: 'EUR',
        shippingCost: o.shippingCost,
        taxEstimate: 0, // IVA included in ES
        totalPriceEur: o.totalPrice,
        deliveryDaysMin: int.tryParse(deliveryParts.first),
        deliveryDaysMax: int.tryParse(deliveryParts.last),
        country: o.storeName == 'AliExpress' ? '🇨🇳 China' : '🇪🇸 España',
        confidenceScore: o.confidenceScore,
        sellerName: o.sellerType == 'Vendedor' ? 'Tercero' : null,
        sellerType: o.sellerType,
        lastChecked: o.lastChecked,
        isFromApi: o.storeName == 'Amazon' || o.storeName == 'eBay',
        inStock: o.inStock,
        url: o.url,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferComparisonScreen(
          offers: comparisonOffers,
          productTitle: _product!.title,
        ),
      ),
    );
  }

  void _showCreateAlertModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crear alerta de precio',
                style: AppTypography.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Te notificaremos cuando el precio baje a tu objetivo.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio objetivo (€)',
                  prefixIcon: const Icon(Icons.euro_rounded),
                  hintText: _product!.offers.first.totalPrice.toStringAsFixed(0),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, 
                              color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text('Alerta creada correctamente'),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Crear alerta'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockProductDetail {
  final String id;
  final String title;
  final String brand;
  final String description;
  final String imageUrl;
  final String upc;
  final String category;
  final List<_MockOffer> offers;

  const _MockProductDetail({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.imageUrl,
    required this.upc,
    required this.category,
    required this.offers,
  });
}

class _MockOffer {
  final String id;
  final String storeName;
  final String storeLogo;
  final double price;
  final double shippingCost;
  final double totalPrice;
  final String deliveryDays;
  final String sellerType;
  final double confidenceScore;
  final bool inStock;
  final String url;
  final DateTime lastChecked;

  const _MockOffer({
    required this.id,
    required this.storeName,
    required this.storeLogo,
    required this.price,
    required this.shippingCost,
    required this.totalPrice,
    required this.deliveryDays,
    required this.sellerType,
    required this.confidenceScore,
    required this.inStock,
    required this.url,
    required this.lastChecked,
  });
}
