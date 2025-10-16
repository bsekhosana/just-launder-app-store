import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart';
import '../../orders/providers/order_provider.dart';
import '../../branches/providers/branch_provider.dart';
import '../../staff/providers/staff_provider.dart';
import '../../auth/providers/auth_provider.dart';
import 'analytics_dashboard_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    final analyticsProvider = Provider.of<AnalyticsProvider>(
      context,
      listen: false,
    );

    // Get current laundrette ID from auth provider
    final laundretteId = authProvider.currentLaundretteId;
    if (laundretteId == null) {
      debugPrint('No authenticated tenant found');
      return;
    }

    await Future.wait([
      orderProvider.loadOrders(laundretteId),
      branchProvider.loadBranches(laundretteId),
      staffProvider.loadStaff(laundretteId),
    ]);

    await analyticsProvider.loadAnalytics(
      orders: orderProvider.orders,
      branches: branchProvider.branches,
      staff: staffProvider.staff,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AnalyticsDashboardScreen();
  }
}
