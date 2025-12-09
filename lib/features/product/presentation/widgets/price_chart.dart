import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Price history chart widget
class PriceChart extends StatefulWidget {
  const PriceChart({super.key});

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  int _selectedPeriod = 30; // 30, 90, 365 days

  // Mock price data
  List<FlSpot> get _mockPriceData {
    final now = DateTime.now();
    return List.generate(30, (index) {
      // Simulate price fluctuation
      double basePrice = 1199;
      double variance = (index % 7) * 15 - 30;
      if (index < 10) variance += 50; // Higher prices earlier
      return FlSpot(index.toDouble(), basePrice + variance);
    });
  }

  @override
  Widget build(BuildContext context) {
    final spots = _mockPriceData;
    final minPrice = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxPrice = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final avgPrice = spots.map((s) => s.y).reduce((a, b) => a + b) / spots.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historial de precios',
                style: AppTypography.titleLarge,
              ),
              // Period selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PeriodButton(
                      label: '30d',
                      isSelected: _selectedPeriod == 30,
                      onTap: () => setState(() => _selectedPeriod = 30),
                    ),
                    _PeriodButton(
                      label: '90d',
                      isSelected: _selectedPeriod == 90,
                      onTap: () => setState(() => _selectedPeriod = 90),
                    ),
                    _PeriodButton(
                      label: '1a',
                      isSelected: _selectedPeriod == 365,
                      onTap: () => setState(() => _selectedPeriod = 365),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _StatItem(
                label: 'Mínimo',
                value: '${minPrice.toStringAsFixed(0)}€',
                color: AppColors.primary,
              ),
              const SizedBox(width: 24),
              _StatItem(
                label: 'Promedio',
                value: '${avgPrice.toStringAsFixed(0)}€',
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 24),
              _StatItem(
                label: 'Máximo',
                value: '${maxPrice.toStringAsFixed(0)}€',
                color: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.surfaceVariant,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}€',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      interval: 7,
                      getTitlesWidget: (value, meta) {
                        final daysAgo = 30 - value.toInt();
                        if (daysAgo == 0) return Text('Hoy', 
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ));
                        if (daysAgo == 7) return Text('7d', 
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ));
                        if (daysAgo == 14) return Text('14d', 
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ));
                        if (daysAgo == 21) return Text('21d', 
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ));
                        if (daysAgo == 28) return Text('28d', 
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ));
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: minPrice - 30,
                maxY: maxPrice + 30,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppColors.darkCard,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(2)}€',
                          AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? AppColors.darkBackground : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
