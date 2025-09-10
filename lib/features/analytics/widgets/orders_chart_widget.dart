import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/analytics_provider.dart';

class OrdersChartWidget extends StatelessWidget {
  const OrdersChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final ordersData = analyticsProvider.ordersByDay;

        if (ordersData.isEmpty) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.lightGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No orders data available',
                style: TextStyle(color: AppTheme.mediumGrey, fontSize: 16),
              ),
            ),
          );
        }

        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.lightGrey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Expanded(child: _buildChart(ordersData)),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChart(Map<String, int> ordersData) {
    final entries = ordersData.entries.toList();
    if (entries.isEmpty) return const SizedBox();

    final maxOrders = entries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final minOrders = entries
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);
    final range = maxOrders - minOrders;

    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: OrdersChartPainter(
        data: entries,
        maxValue: maxOrders,
        minValue: minOrders,
        range: range,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLegendItem('Orders', AppTheme.primaryBlue),
        _buildLegendItem('Average', AppTheme.warningOrange),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppTheme.mediumGrey, fontSize: 12),
        ),
      ],
    );
  }
}

class OrdersChartPainter extends CustomPainter {
  final List<MapEntry<String, int>> data;
  final int maxValue;
  final int minValue;
  final int range;

  OrdersChartPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Draw bars
    final barWidth = (size.width / data.length) * 0.6;
    final barSpacing = (size.width / data.length) * 0.4;

    for (int i = 0; i < data.length; i++) {
      final x = i * (barWidth + barSpacing) + barSpacing / 2;
      final normalizedValue =
          range > 0 ? (data[i].value - minValue) / range : 0.5;
      final barHeight = normalizedValue * size.height;
      final y = size.height - barHeight;

      // Bar background
      final backgroundPaint =
          Paint()
            ..color = AppTheme.lightGrey.withOpacity(0.2)
            ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x, 0, barWidth, size.height),
        backgroundPaint,
      );

      // Bar
      final barPaint =
          Paint()
            ..color = AppTheme.primaryBlue
            ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), barPaint);

      // Bar border
      final borderPaint =
          Paint()
            ..color = AppTheme.primaryBlue
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;

      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), borderPaint);
    }

    // Draw average line
    if (data.isNotEmpty) {
      final average =
          data.map((e) => e.value).reduce((a, b) => a + b) / data.length;
      final normalizedAverage = range > 0 ? (average - minValue) / range : 0.5;
      final averageY = size.height - (normalizedAverage * size.height);

      final averagePaint =
          Paint()
            ..color = AppTheme.warningOrange
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      canvas.drawLine(
        Offset(0, averageY),
        Offset(size.width, averageY),
        averagePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
