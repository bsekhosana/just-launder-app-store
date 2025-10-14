import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/theme.dart';
import '../../../core/widgets/watermark_background.dart';
import '../providers/branch_configuration_provider.dart';
import '../data/models/branch_configuration_model.dart';

/// Screen for viewing payment dashboard and revenue analytics
class PaymentDashboardScreen extends StatefulWidget {
  final String? branchId;

  const PaymentDashboardScreen({super.key, this.branchId});

  @override
  State<PaymentDashboardScreen> createState() => _PaymentDashboardScreenState();
}

class _PaymentDashboardScreenState extends State<PaymentDashboardScreen> {
  String _selectedPeriod = 'month';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final provider = context.read<BranchConfigurationProvider>();
    await provider.loadPaymentDashboard(branchId: widget.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadDashboard,
            icon: const Icon(FontAwesomeIcons.arrowRotateRight),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: WatermarkBackground(
        icon: FontAwesomeIcons.chartLine,
        child: Consumer<BranchConfigurationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingDashboard) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.triangleExclamation,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppSpacing.l),
                      Text(
                        provider.errorMessage!,
                        style: AppTypography.textTheme.bodyLarge?.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      ElevatedButton(
                        onPressed: _loadDashboard,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final dashboard = provider.dashboard;
            if (dashboard == null) {
              return const Center(child: Text('No data available'));
            }

            return RefreshIndicator(
              onRefresh: _loadDashboard,
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Revenue overview card with gradient
                    CardX(
                      elevation: AppElevations.high,
                      borderRadius: AppRadii.xl,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Revenue',
                                style: AppTypography.textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Icon(
                                FontAwesomeIcons.sterlingSign,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.m),
                          Text(
                            dashboard.formattedTotalRevenue,
                            style: AppTypography.textTheme.displayLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Period selector
                    CardX(
                      elevation: AppElevations.card,
                      borderRadius: AppRadii.l,
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Row(
                        children:
                            ['today', 'week', 'month'].map((period) {
                              final isSelected = period == _selectedPeriod;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: AppSpacing.xs,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() => _selectedPeriod = period);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isSelected
                                              ? AppColors.primary
                                              : Colors.transparent,
                                      foregroundColor:
                                          isSelected
                                              ? Colors.white
                                              : AppColors.onSurfaceVariant,
                                      elevation: 0,
                                    ),
                                    child: Text(period.toUpperCase()),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Revenue breakdown
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Today',
                            dashboard.formattedTodayRevenue,
                            FontAwesomeIcons.calendarDay,
                            AppColors.info,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: _buildStatCard(
                            'This Week',
                            dashboard.formattedWeekRevenue,
                            FontAwesomeIcons.calendarWeek,
                            AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'This Month',
                            dashboard.formattedMonthRevenue,
                            FontAwesomeIcons.calendar,
                            AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: _buildStatCard(
                            'Orders',
                            '${dashboard.totalOrders}',
                            FontAwesomeIcons.boxOpen,
                            AppColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Order status breakdown
                    CardX(
                      elevation: AppElevations.card,
                      borderRadius: AppRadii.l,
                      padding: const EdgeInsets.all(AppSpacing.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.chartPie,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Text(
                                'Order Status',
                                style: AppTypography.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.l),
                          _buildStatusRow(
                            'Paid Orders',
                            dashboard.paidOrders,
                            AppColors.success,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          _buildStatusRow(
                            'Pending Payment',
                            dashboard.pendingPaymentOrders,
                            AppColors.warning,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          _buildStatusRow(
                            'Refund Requests',
                            dashboard.refundRequests,
                            AppColors.error,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Recent transactions
                    if (dashboard.recentTransactions.isNotEmpty) ...[
                      CardX(
                        elevation: AppElevations.card,
                        borderRadius: AppRadii.l,
                        padding: const EdgeInsets.all(AppSpacing.l),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.receipt,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppSpacing.m),
                                    Text(
                                      'Recent Transactions',
                                      style: AppTypography.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to full transactions list
                                  },
                                  child: const Text('View All'),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.l),
                            ...dashboard.recentTransactions
                                .take(5)
                                .map((tx) => _buildTransactionItem(tx)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return CardX(
      elevation: AppElevations.card,
      borderRadius: AppRadii.l,
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.s),
          Text(
            value,
            style: AppTypography.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.m),
            Text(label, style: AppTypography.textTheme.bodyMedium),
          ],
        ),
        Text(
          count.toString(),
          style: AppTypography.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(RecentTransactionModel transaction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color:
                  transaction.isCompleted
                      ? AppColors.successContainer
                      : AppColors.warningContainer,
              borderRadius: BorderRadius.circular(AppRadii.s),
            ),
            child: Icon(
              FontAwesomeIcons.arrowRight,
              size: 14,
              color:
                  transaction.isCompleted
                      ? AppColors.success
                      : AppColors.warning,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.orderSlug,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDate(transaction.createdAt),
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.formattedAmount,
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
