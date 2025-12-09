import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Side-by-side offer comparison screen
/// Allows selecting up to 3 offers to compare their details
class OfferComparisonScreen extends StatefulWidget {
  final List<ComparisonOffer> offers;
  final String productTitle;

  const OfferComparisonScreen({
    super.key,
    required this.offers,
    required this.productTitle,
  });

  @override
  State<OfferComparisonScreen> createState() => _OfferComparisonScreenState();
}

class _OfferComparisonScreenState extends State<OfferComparisonScreen> {
  late List<ComparisonOffer> _selectedOffers;

  @override
  void initState() {
    super.initState();
    // Pre-select first 3 offers
    _selectedOffers = widget.offers.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar ofertas'),
        actions: [
          TextButton.icon(
            onPressed: _showOfferSelector,
            icon: const Icon(Icons.swap_horiz_rounded, size: 18),
            label: const Text('Cambiar'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Product title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.darkCard,
            child: Text(
              widget.productTitle,
              style: AppTypography.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Comparison table
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Store headers
                  _ComparisonRow(
                    label: 'Tienda',
                    values: _selectedOffers
                        .map((o) => _StoreHeader(offer: o))
                        .toList(),
                    isHeader: true,
                  ),

                  const Divider(height: 1),

                  // Price breakdown section
                  _SectionLabel(label: '💰 PRECIO'),
                  
                  _ComparisonRow(
                    label: 'Precio base',
                    values: _selectedOffers
                        .map((o) => _PriceCell(
                              value: o.price,
                              currency: o.currency,
                            ))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'Envío',
                    values: _selectedOffers
                        .map((o) => _ShippingCell(cost: o.shippingCost))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'Impuestos est.',
                    values: _selectedOffers
                        .map((o) => _PriceCell(
                              value: o.taxEstimate,
                              currency: 'EUR',
                              isMuted: true,
                            ))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'TOTAL',
                    values: _selectedOffers
                        .map((o) => _TotalPriceCell(
                              value: o.totalPriceEur,
                              isBest: o == _getBestOffer(),
                            ))
                        .toList(),
                    isHighlighted: true,
                  ),

                  const SizedBox(height: 8),
                  const Divider(height: 1),

                  // Delivery section
                  _SectionLabel(label: '🚚 ENVÍO'),

                  _ComparisonRow(
                    label: 'Tiempo entrega',
                    values: _selectedOffers
                        .map((o) => _DeliveryCell(
                              minDays: o.deliveryDaysMin,
                              maxDays: o.deliveryDaysMax,
                            ))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'País origen',
                    values: _selectedOffers
                        .map((o) => _TextCell(value: o.country))
                        .toList(),
                  ),

                  const Divider(height: 1),

                  // Trust section
                  _SectionLabel(label: '✅ CONFIANZA'),

                  _ComparisonRow(
                    label: 'Coincidencia',
                    values: _selectedOffers
                        .map((o) => _ConfidenceCell(score: o.confidenceScore))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'Vendedor',
                    values: _selectedOffers
                        .map((o) => _TextCell(
                              value: o.sellerName ?? 'Oficial',
                              subtitle: o.sellerType,
                            ))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'Última comprobación',
                    values: _selectedOffers
                        .map((o) => _LastCheckedCell(time: o.lastChecked))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'Fuente',
                    values: _selectedOffers
                        .map((o) => _SourceCell(
                              isApi: o.isFromApi,
                            ))
                        .toList(),
                  ),

                  _ComparisonRow(
                    label: 'Stock',
                    values: _selectedOffers
                        .map((o) => _StockCell(inStock: o.inStock))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _selectedOffers.map((offer) {
                        final isBest = offer == _getBestOffer();
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () => _openOffer(offer),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isBest
                                    ? AppColors.primary
                                    : AppColors.surfaceVariant,
                                foregroundColor: isBest
                                    ? AppColors.darkBackground
                                    : AppColors.textPrimary,
                              ),
                              child: Text(
                                isBest ? 'Mejor opción' : 'Ir a tienda',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ComparisonOffer _getBestOffer() {
    return _selectedOffers.reduce((a, b) =>
        a.totalPriceEur < b.totalPriceEur ? a : b);
  }

  void _showOfferSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccionar ofertas (máx. 3)',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.offers.map((offer) {
                final isSelected = _selectedOffers.contains(offer);
                return FilterChip(
                  selected: isSelected,
                  label: Text('${offer.storeName} - ${offer.totalPriceEur.toStringAsFixed(0)}€'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected && _selectedOffers.length < 3) {
                        _selectedOffers.add(offer);
                      } else if (!selected) {
                        _selectedOffers.remove(offer);
                      }
                    });
                    if (_selectedOffers.length >= 2) {
                      Navigator.pop(context);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _openOffer(ComparisonOffer offer) async {
    final uri = Uri.parse(offer.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Data model for comparison
class ComparisonOffer {
  final String id;
  final String storeName;
  final String storeLogo;
  final double price;
  final String currency;
  final double shippingCost;
  final double taxEstimate;
  final double totalPriceEur;
  final int? deliveryDaysMin;
  final int? deliveryDaysMax;
  final String country;
  final double confidenceScore;
  final String? sellerName;
  final String? sellerType;
  final DateTime lastChecked;
  final bool isFromApi;
  final bool inStock;
  final String url;

  const ComparisonOffer({
    required this.id,
    required this.storeName,
    required this.storeLogo,
    required this.price,
    required this.currency,
    required this.shippingCost,
    required this.taxEstimate,
    required this.totalPriceEur,
    this.deliveryDaysMin,
    this.deliveryDaysMax,
    required this.country,
    required this.confidenceScore,
    this.sellerName,
    this.sellerType,
    required this.lastChecked,
    required this.isFromApi,
    required this.inStock,
    required this.url,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final List<Widget> values;
  final bool isHeader;
  final bool isHighlighted;

  const _ComparisonRow({
    required this.label,
    required this.values,
    this.isHeader = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isHighlighted
          ? AppColors.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: (isHeader ? AppTypography.labelLarge : AppTypography.bodySmall)
                  .copyWith(
                color: isHighlighted ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isHighlighted ? FontWeight.w600 : null,
              ),
            ),
          ),
          ...values.map((v) => Expanded(child: Center(child: v))),
        ],
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final ComparisonOffer offer;

  const _StoreHeader({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          offer.storeLogo,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          offer.storeName,
          style: AppTypography.labelMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PriceCell extends StatelessWidget {
  final double value;
  final String currency;
  final bool isMuted;

  const _PriceCell({
    required this.value,
    required this.currency,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${value.toStringAsFixed(2)}€',
      style: AppTypography.bodyMedium.copyWith(
        color: isMuted ? AppColors.textMuted : AppColors.textPrimary,
      ),
    );
  }
}

class _ShippingCell extends StatelessWidget {
  final double cost;

  const _ShippingCell({required this.cost});

  @override
  Widget build(BuildContext context) {
    if (cost == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            'Gratis',
            style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
          ),
        ],
      );
    }
    return Text(
      '+${cost.toStringAsFixed(2)}€',
      style: AppTypography.bodyMedium.copyWith(color: AppColors.accent),
    );
  }
}

class _TotalPriceCell extends StatelessWidget {
  final double value;
  final bool isBest;

  const _TotalPriceCell({
    required this.value,
    required this.isBest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${value.toStringAsFixed(2)}€',
          style: AppTypography.priceMedium.copyWith(
            color: isBest ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        if (isBest)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'MEJOR',
              style: AppTypography.badge.copyWith(
                color: AppColors.darkBackground,
              ),
            ),
          ),
      ],
    );
  }
}

class _DeliveryCell extends StatelessWidget {
  final int? minDays;
  final int? maxDays;

  const _DeliveryCell({this.minDays, this.maxDays});

  @override
  Widget build(BuildContext context) {
    if (minDays == null && maxDays == null) {
      return Text(
        '—',
        style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
      );
    }

    final text = minDays == maxDays
        ? '$minDays días'
        : '$minDays-$maxDays días';

    Color color = AppColors.textPrimary;
    if (maxDays != null && maxDays! <= 3) {
      color = AppColors.primary;
    } else if (maxDays != null && maxDays! > 10) {
      color = AppColors.accent;
    }

    return Text(
      text,
      style: AppTypography.bodyMedium.copyWith(color: color),
    );
  }
}

class _TextCell extends StatelessWidget {
  final String value;
  final String? subtitle;

  const _TextCell({required this.value, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
      ],
    );
  }
}

class _ConfidenceCell extends StatelessWidget {
  final double score;

  const _ConfidenceCell({required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    if (score >= 0.9) {
      color = AppColors.primary;
      label = 'Alta';
      icon = Icons.verified_rounded;
    } else if (score >= 0.7) {
      color = AppColors.accent;
      label = 'Media';
      icon = Icons.check_circle_outline;
    } else {
      color = AppColors.error;
      label = 'Baja';
      icon = Icons.warning_amber_rounded;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              '${(score * 100).toInt()}%',
              style: AppTypography.labelLarge.copyWith(color: color),
            ),
          ],
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: color),
        ),
      ],
    );
  }
}

class _LastCheckedCell extends StatelessWidget {
  final DateTime time;

  const _LastCheckedCell({required this.time});

  @override
  Widget build(BuildContext context) {
    final diff = DateTime.now().difference(time);
    String text;
    Color color = AppColors.textSecondary;

    if (diff.inMinutes < 60) {
      text = 'Hace ${diff.inMinutes}m';
      color = AppColors.primary;
    } else if (diff.inHours < 6) {
      text = 'Hace ${diff.inHours}h';
    } else if (diff.inHours < 24) {
      text = 'Hace ${diff.inHours}h';
      color = AppColors.accent;
    } else {
      text = 'Hace ${diff.inDays}d';
      color = AppColors.error;
    }

    return Text(
      text,
      style: AppTypography.bodySmall.copyWith(color: color),
    );
  }
}

class _SourceCell extends StatelessWidget {
  final bool isApi;

  const _SourceCell({required this.isApi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isApi
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isApi ? 'API' : 'Scraping',
        style: AppTypography.labelSmall.copyWith(
          color: isApi ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _StockCell extends StatelessWidget {
  final bool inStock;

  const _StockCell({required this.inStock});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          inStock ? Icons.check_circle : Icons.cancel,
          size: 14,
          color: inStock ? AppColors.inStock : AppColors.outOfStock,
        ),
        const SizedBox(width: 4),
        Text(
          inStock ? 'Sí' : 'No',
          style: AppTypography.bodySmall.copyWith(
            color: inStock ? AppColors.inStock : AppColors.outOfStock,
          ),
        ),
      ],
    );
  }
}
