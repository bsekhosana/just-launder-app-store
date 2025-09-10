import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/staff_provider.dart';
import '../../../data/models/staff_member.dart';
import '../../orders/providers/order_provider.dart';
import '../../../data/models/laundrette_order.dart';
import 'driver_details_screen.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await staffProvider.loadStaff('laundrette_business_1');
    await orderProvider.loadOrders('laundrette_business_1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'On Delivery'),
            Tab(text: 'All Drivers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAvailableDriversTab(),
          _buildOnDeliveryTab(),
          _buildAllDriversTab(),
        ],
      ),
    );
  }

  Widget _buildAvailableDriversTab() {
    return Consumer<StaffProvider>(
      builder: (context, staffProvider, child) {
        final availableDrivers =
            staffProvider.drivers
                .where(
                  (driver) =>
                      driver.isActive && !_isDriverOnDelivery(driver.id),
                )
                .toList();

        if (availableDrivers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_car, size: 64, color: AppTheme.lightGrey),
                SizedBox(height: 16),
                Text(
                  'No available drivers',
                  style: TextStyle(fontSize: 18, color: AppTheme.mediumGrey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: availableDrivers.length,
          itemBuilder: (context, index) {
            final driver = availableDrivers[index];
            return _buildDriverCard(driver, showAvailability: true);
          },
        );
      },
    );
  }

  Widget _buildOnDeliveryTab() {
    return Consumer2<StaffProvider, OrderProvider>(
      builder: (context, staffProvider, orderProvider, child) {
        final onDeliveryDrivers =
            staffProvider.drivers
                .where((driver) => _isDriverOnDelivery(driver.id))
                .toList();

        if (onDeliveryDrivers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping, size: 64, color: AppTheme.lightGrey),
                SizedBox(height: 16),
                Text(
                  'No drivers on delivery',
                  style: TextStyle(fontSize: 18, color: AppTheme.mediumGrey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: onDeliveryDrivers.length,
          itemBuilder: (context, index) {
            final driver = onDeliveryDrivers[index];
            return _buildDriverCard(driver, showDeliveryInfo: true);
          },
        );
      },
    );
  }

  Widget _buildAllDriversTab() {
    return Consumer<StaffProvider>(
      builder: (context, staffProvider, child) {
        if (staffProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final drivers = staffProvider.drivers;

        if (drivers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 64, color: AppTheme.lightGrey),
                SizedBox(height: 16),
                Text(
                  'No drivers found',
                  style: TextStyle(fontSize: 18, color: AppTheme.mediumGrey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];
            return _buildDriverCard(driver, showAllInfo: true);
          },
        );
      },
    );
  }

  Widget _buildDriverCard(
    StaffMember driver, {
    bool showAvailability = false,
    bool showDeliveryInfo = false,
    bool showAllInfo = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                  child:
                      driver.profileImageUrl != null
                          ? ClipOval(
                            child: Image.network(
                              driver.profileImageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: AppTheme.primaryBlue,
                                  size: 24,
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.person,
                            color: AppTheme.primaryBlue,
                            size: 24,
                          ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.fullName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        driver.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDriverStatusChip(driver),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: AppTheme.mediumGrey),
                const SizedBox(width: 4),
                Text(
                  driver.phoneNumber ?? 'No phone',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
                ),
                const SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: AppTheme.warningOrange),
                const SizedBox(width: 4),
                Text(
                  '4.8', // Mock rating
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
                ),
              ],
            ),
            if (showAvailability) ...[
              const SizedBox(height: 12),
              _buildAvailabilityInfo(driver),
            ],
            if (showDeliveryInfo) ...[
              const SizedBox(height: 12),
              _buildDeliveryInfo(driver),
            ],
            if (showAllInfo) ...[
              const SizedBox(height: 12),
              _buildDriverStats(driver),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _viewDriverDetails(driver),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                if (showAvailability)
                  ElevatedButton.icon(
                    onPressed: () => _assignDelivery(driver),
                    icon: const Icon(Icons.local_shipping, size: 16),
                    label: const Text('Assign Delivery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverStatusChip(StaffMember driver) {
    Color color;
    String text;

    if (_isDriverOnDelivery(driver.id)) {
      color = AppTheme.primaryGreen;
      text = 'On Delivery';
    } else if (driver.isActive) {
      color = AppTheme.successGreen;
      text = 'Available';
    } else {
      color = AppTheme.mediumGrey;
      text = 'Offline';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAvailabilityInfo(StaffMember driver) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppTheme.successGreen, size: 16),
          const SizedBox(width: 8),
          Text(
            'Ready for delivery assignments',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.successGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(StaffMember driver) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, color: AppTheme.primaryBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                'Currently on delivery',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'ETA: 15 minutes',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverStats(StaffMember driver) {
    return Row(
      children: [
        _buildStatItem('Deliveries', '24', AppTheme.primaryBlue),
        const SizedBox(width: 16),
        _buildStatItem('Rating', '4.8', AppTheme.warningOrange),
        const SizedBox(width: 16),
        _buildStatItem('Earnings', '\$1,250', AppTheme.successGreen),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
        ),
      ],
    );
  }

  bool _isDriverOnDelivery(String driverId) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return orderProvider.orders.any(
      (order) =>
          order.driverId == driverId &&
          (order.status == LaundretteOrderStatus.outForDelivery ||
              order.status == LaundretteOrderStatus.pickedUp),
    );
  }

  void _viewDriverDetails(StaffMember driver) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DriverDetailsScreen(driver: driver),
      ),
    );
  }

  void _assignDelivery(StaffMember driver) {
    // TODO: Implement delivery assignment
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Delivery assignment coming soon'),
        backgroundColor: AppTheme.infoBlue,
      ),
    );
  }
}
