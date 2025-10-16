import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/chip_x.dart';
import '../providers/tenant_order_provider.dart';

class OrderAnalyticsWidget extends StatelessWidget {
  final Map<String, dynamic> analytics;
  final Map<String, dynamic> statistics;
  final TimePeriod timePeriod;
  final Function(TimePeriod) onTimePeriodChanged;

  const OrderAnalyticsWidget({
    super.key,
    required this.analytics,
    required this.statistics,
    required this.timePeriod,
    required this.onTimePeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Analytics',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildTimePeriodSelector(),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            _buildAnalyticsGrid(),
            const SizedBox(height: AppSpacing.l),
            _buildChartsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Row(
      children:
          TimePeriod.values.map((period) {
            final isSelected = period == timePeriod;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: AnimatedButton(
                onPressed: () => onTimePeriodChanged(period),
                backgroundColor:
                    isSelected ? AppColors.primary : Colors.transparent,
                child: Text(
                  _getTimePeriodLabel(period),
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color:
                        isSelected ? Colors.white : AppColors.onSurfaceVariant,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  String _getTimePeriodLabel(TimePeriod period) {
    switch (period) {
      case TimePeriod.today:
        return 'Today';
      case TimePeriod.week:
        return 'Week';
      case TimePeriod.month:
        return 'Month';
      case TimePeriod.year:
        return 'Year';
    }
  }

  Widget _buildAnalyticsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: AppSpacing.m,
      mainAxisSpacing: AppSpacing.m,
      children: [
        _buildAnalyticsCard(
          'Total Orders',
          '${statistics['total_orders'] ?? 0}',
          AppIcons.orders,
          AppColors.primary,
        ),
        _buildAnalyticsCard(
          'Revenue',
          '£${(statistics['total_revenue'] ?? 0.0).toStringAsFixed(2)}',
          AppIcons.dollar,
          AppColors.success,
        ),
        _buildAnalyticsCard(
          'Avg Order Value',
          '£${(statistics['average_order_value'] ?? 0.0).toStringAsFixed(2)}',
          AppIcons.trendingUp,
          AppColors.info,
        ),
        _buildAnalyticsCard(
          'Completion Rate',
          '${(statistics['completion_rate'] ?? 0.0).toStringAsFixed(1)}%',
          AppIcons.checkCircle,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
          child: Padding(
            padding: SpacingUtils.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: color, size: 24),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(AppIcons.trendingUp, color: color, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  value,
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: AppMotion.normal)
        .slideY(begin: 0.3, end: 0.0, duration: AppMotion.normal);
  }

  Widget _buildChartsSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Status Distribution',
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        _buildStatusDistributionChart(),
        const SizedBox(height: AppSpacing.l),
        Text(
          'Revenue Trends',
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        _buildRevenueTrendChart(),
      ],
    );
  }

  Widget _buildStatusDistributionChart() {
    final colorScheme = Theme.of(context).colorScheme;
    final statusData =
        statistics['status_distribution'] as Map<String, dynamic>? ?? {};

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.m),
        child: Column(
          children:
              [
                'Pending',
                'Confirmed',
                'In Progress',
                'Ready',
                'Delivered',
                'Completed',
              ].map((status) {
                final count = statusData[status.toLowerCase()] ?? 0;
                final total = statusData.values.fold<int>(
                  0,
                  (sum, value) => sum + (value as int),
                );
                final percentage = total > 0 ? (count / total * 100) : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          status,
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.outline.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        '$count',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildRevenueTrendChart() {
    final colorScheme = Theme.of(context).colorScheme;
    final revenueData = analytics['revenue_trend'] as List<dynamic>? ?? [];

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.m),
        child: Column(
          children: [
            if (revenueData.isEmpty)
              Center(
                child: Text(
                  'No revenue data available',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                child: CustomPaint(
                  painter: RevenueChartPainter(revenueData),
                  size: Size.infinite,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.info;
      case 'in progress':
        return AppColors.primary;
      case 'ready':
        return AppColors.warning;
      case 'delivered':
        return AppColors.success;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.onSurfaceVariant;
    }
  }
}

class RevenueChartPainter extends CustomPainter {
  final List<dynamic> data;

  RevenueChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint =
        Paint()
          ..color = AppColors.primary
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final fillPaint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final maxValue = data.fold<double>(0, (max, item) {
      final value = (item['revenue'] as num?)?.toDouble() ?? 0.0;
      return value > max ? value : max;
    });

    if (maxValue == 0) return;

    final stepX = size.width / (data.length - 1);
    final stepY = size.height / maxValue;

    for (int i = 0; i < data.length; i++) {
      final value = (data[i]['revenue'] as num?)?.toDouble() ?? 0.0;
      final x = i * stepX;
      final y = size.height - (value * stepY);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final value = (data[i]['revenue'] as num?)?.toDouble() ?? 0.0;
      final x = i * stepX;
      final y = size.height - (value * stepY);

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
