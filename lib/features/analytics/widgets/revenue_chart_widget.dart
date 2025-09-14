import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../providers/analytics_provider.dart';

class RevenueChartWidget extends StatelessWidget {
  const RevenueChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final revenueData = analyticsProvider.revenueByDay;

        if (revenueData.isEmpty) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No revenue data available',
                style: TextStyle(color: AppColors.mediumGrey, fontSize: 16),
              ),
            ),
          );
        }

        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Expanded(child: _buildChart(revenueData)),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChart(Map<String, double> revenueData) {
    final entries = revenueData.entries.toList();
    if (entries.isEmpty) return const SizedBox();

    final maxRevenue = entries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final minRevenue = entries
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);
    final range = maxRevenue - minRevenue;

    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: RevenueChartPainter(
        data: entries,
        maxValue: maxRevenue,
        minValue: minRevenue,
        range: range,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLegendItem('Revenue', AppColors.primary),
        _buildLegendItem('Trend', AppColors.success),
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
          style: const TextStyle(color: AppColors.mediumGrey, fontSize: 12),
        ),
      ],
    );
  }
}

class RevenueChartPainter extends CustomPainter {
  final List<MapEntry<String, double>> data;
  final double maxValue;
  final double minValue;
  final double range;

  RevenueChartPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final path = Path();
    final points = <Offset>[];

    // Calculate points
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedValue =
          range > 0 ? (data[i].value - minValue) / range : 0.5;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Draw line
    paint.color = AppColors.primary;
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, paint);

    // Draw points
    paint.style = PaintingStyle.fill;
    paint.color = AppColors.primary;
    for (final point in points) {
      canvas.drawCircle(point, 4, paint);
    }

    // Draw area under curve
    final areaPath = Path();
    areaPath.addPath(path, Offset.zero);
    areaPath.lineTo(size.width, size.height);
    areaPath.lineTo(0, size.height);
    areaPath.close();

    final areaPaint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    canvas.drawPath(areaPath, areaPaint);

    // Draw trend line (simplified)
    if (points.length > 1) {
      final trendPaint =
          Paint()
            ..color = AppColors.success
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;

      final startPoint = points.first;
      final endPoint = points.last;
      canvas.drawLine(startPoint, endPoint, trendPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
