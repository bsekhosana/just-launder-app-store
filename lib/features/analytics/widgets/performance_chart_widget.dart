import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/analytics_provider.dart';

class PerformanceChartWidget extends StatelessWidget {
  const PerformanceChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final staffPerformance = analyticsProvider.staffPerformance;

        if (staffPerformance.isEmpty) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.lightGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No performance data available',
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
              Expanded(child: _buildChart(staffPerformance)),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChart(List<Map<String, dynamic>> staffPerformance) {
    if (staffPerformance.isEmpty) return const SizedBox();

    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: PerformanceChartPainter(data: staffPerformance),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLegendItem('Completion Rate', AppTheme.successGreen),
        _buildLegendItem('Orders', AppTheme.primaryBlue),
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

class PerformanceChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  PerformanceChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final barWidth = (size.width / data.length) * 0.6;
    final barSpacing = (size.width / data.length) * 0.4;

    for (int i = 0; i < data.length; i++) {
      final completionRate = data[i]['completionRate'] as double;
      final orderCount = data[i]['totalOrders'] as int;

      final x = i * (barWidth + barSpacing) + barSpacing / 2;

      // Completion rate bar
      final completionHeight = (completionRate / 100) * (size.height * 0.6);
      final completionY = size.height * 0.4 - completionHeight;

      final completionPaint =
          Paint()
            ..color = AppTheme.successGreen
            ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x, completionY, barWidth * 0.4, completionHeight),
        completionPaint,
      );

      // Order count bar
      final orderHeight =
          (orderCount / 50.0) * (size.height * 0.6); // Assuming max 50 orders
      final orderY = size.height * 0.4 - orderHeight;

      final orderPaint =
          Paint()
            ..color = AppTheme.primaryBlue
            ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x + barWidth * 0.5, orderY, barWidth * 0.4, orderHeight),
        orderPaint,
      );

      // Draw completion rate percentage
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${completionRate.toStringAsFixed(0)}%',
          style: const TextStyle(
            color: AppTheme.darkGrey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth * 0.2 - textPainter.width / 2, completionY - 15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
