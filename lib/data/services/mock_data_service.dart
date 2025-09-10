import 'dart:math';
import '../models/subscription.dart';
import '../models/laundrette_profile.dart';
import '../models/laundrette_branch.dart';
import '../models/laundrette_order.dart';
import '../models/staff_member.dart';

class MockDataService {
  static final Random _random = Random();

  // Mock Laundrette Profiles
  static List<LaundretteProfile> getMockProfiles() {
    return [
      LaundretteProfile(
        id: 'laundrette_business_1',
        businessName: 'Clean & Fresh Laundrette',
        type: LaundretteType.business,
        email: 'business@cleanfresh.com',
        phoneNumber: '+1-555-0123',
        address: '123 Business St, New York, NY 10001',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
        isActive: true,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      LaundretteProfile(
        id: 'laundrette_private_1',
        businessName: 'Family Laundry Service',
        type: LaundretteType.private,
        email: 'family@laundry.com',
        phoneNumber: '+1-555-0456',
        address: '456 Private Ave, Los Angeles, CA 90210',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90210',
        country: 'USA',
        isActive: true,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  // Mock Subscriptions
  static List<Subscription> getMockSubscriptions() {
    return [
      Subscription(
        id: 'sub_business_1',
        laundretteId: 'laundrette_business_1',
        name: 'Professional Plan',
        type: SubscriptionType.business,
        currentTier: 'professional',
        monthlyPrice: 79.99,
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 365)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        features: {
          SubscriptionFeatures.maxBranches: 5,
          SubscriptionFeatures.maxStaff: 15,
          SubscriptionFeatures.advancedAnalytics: true,
          SubscriptionFeatures.prioritySupport: true,
          SubscriptionFeatures.customBranding: true,
          SubscriptionFeatures.apiAccess: false,
          SubscriptionFeatures.driverManagement: true,
          SubscriptionFeatures.orderAutoAccept: true,
          SubscriptionFeatures.priorityDelivery: true,
        },
      ),
      Subscription(
        id: 'sub_private_1',
        laundretteId: 'laundrette_private_1',
        name: 'Starter Plan',
        type: SubscriptionType.private,
        currentTier: 'starter',
        monthlyPrice: 29.99,
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 180)),
        endDate: DateTime.now().add(const Duration(days: 15)),
        features: {
          SubscriptionFeatures.maxBranches: 1,
          SubscriptionFeatures.maxStaff: 3,
          SubscriptionFeatures.advancedAnalytics: false,
          SubscriptionFeatures.prioritySupport: false,
          SubscriptionFeatures.customBranding: false,
          SubscriptionFeatures.apiAccess: false,
          SubscriptionFeatures.driverManagement: false,
          SubscriptionFeatures.orderAutoAccept: false,
          SubscriptionFeatures.priorityDelivery: false,
        },
      ),
    ];
  }

  // Mock Branches
  static List<LaundretteBranch> getMockBranches() {
    return [
      LaundretteBranch(
        id: 'branch_1',
        laundretteId: 'laundrette_business_1',
        name: 'Downtown Branch',
        address: '123 Business St, New York, NY 10001',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        phoneNumber: '+1-555-0123',
        email: 'downtown@cleanfresh.com',
        status: BranchStatus.open,
        isAutoAcceptOrders: true,
        supportsPriorityDelivery: true,
        operatingHours: {
          'monday': {'open': '08:00', 'close': '20:00'},
          'tuesday': {'open': '08:00', 'close': '20:00'},
          'wednesday': {'open': '08:00', 'close': '20:00'},
          'thursday': {'open': '08:00', 'close': '20:00'},
          'friday': {'open': '08:00', 'close': '20:00'},
          'saturday': {'open': '09:00', 'close': '18:00'},
          'sunday': {'open': '10:00', 'close': '16:00'},
        },
        services: {
          'wash': 15.00,
          'dry': 10.00,
          'iron': 8.00,
          'dry_clean': 25.00,
          'express': 30.00,
        },
        imageUrl: 'https://example.com/branch1.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      LaundretteBranch(
        id: 'branch_2',
        laundretteId: 'laundrette_business_1',
        name: 'Uptown Branch',
        address: '789 Uptown Ave, New York, NY 10025',
        city: 'New York',
        state: 'NY',
        zipCode: '10025',
        phoneNumber: '+1-555-0124',
        email: 'uptown@cleanfresh.com',
        status: BranchStatus.open,
        isAutoAcceptOrders: false,
        supportsPriorityDelivery: true,
        operatingHours: {
          'monday': {'open': '07:00', 'close': '21:00'},
          'tuesday': {'open': '07:00', 'close': '21:00'},
          'wednesday': {'open': '07:00', 'close': '21:00'},
          'thursday': {'open': '07:00', 'close': '21:00'},
          'friday': {'open': '07:00', 'close': '21:00'},
          'saturday': {'open': '08:00', 'close': '19:00'},
          'sunday': {'open': '09:00', 'close': '17:00'},
        },
        services: {
          'wash': 18.00,
          'dry': 12.00,
          'iron': 10.00,
          'dry_clean': 28.00,
          'express': 35.00,
        },
        imageUrl: 'https://example.com/branch2.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LaundretteBranch(
        id: 'branch_3',
        laundretteId: 'laundrette_private_1',
        name: 'Family Laundry',
        address: '456 Private Ave, Los Angeles, CA 90210',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90210',
        phoneNumber: '+1-555-0456',
        email: 'family@laundry.com',
        status: BranchStatus.open,
        isAutoAcceptOrders: false,
        supportsPriorityDelivery: false,
        operatingHours: {
          'monday': {'open': '09:00', 'close': '18:00'},
          'tuesday': {'open': '09:00', 'close': '18:00'},
          'wednesday': {'open': '09:00', 'close': '18:00'},
          'thursday': {'open': '09:00', 'close': '18:00'},
          'friday': {'open': '09:00', 'close': '18:00'},
          'saturday': {'open': '10:00', 'close': '16:00'},
          'sunday': {'closed': 'closed'},
        },
        services: {
          'wash': 12.00,
          'dry': 8.00,
          'iron': 6.00,
          'dry_clean': 20.00,
        },
        imageUrl: 'https://example.com/branch3.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Mock Staff Members
  static List<StaffMember> getMockStaff() {
    return [
      StaffMember(
        id: 'staff_1',
        laundretteId: 'laundrette_business_1',
        name: 'John Smith',
        email: 'john@cleanfresh.com',
        phoneNumber: '+1-555-1001',
        role: StaffRole.manager,
        status: StaffStatus.active,
        branchId: 'branch_1',
        workingHours: {
          'monday': {'start': '08:00', 'end': '17:00'},
          'tuesday': {'start': '08:00', 'end': '17:00'},
          'wednesday': {'start': '08:00', 'end': '17:00'},
          'thursday': {'start': '08:00', 'end': '17:00'},
          'friday': {'start': '08:00', 'end': '17:00'},
        },
        permissions: [
          StaffPermission.manageOrders,
          StaffPermission.manageStaff,
          StaffPermission.viewAnalytics,
          StaffPermission.manageBranches,
        ],
        hireDate: DateTime.now().subtract(const Duration(days: 300)),
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      StaffMember(
        id: 'staff_2',
        laundretteId: 'laundrette_business_1',
        name: 'Sarah Johnson',
        email: 'sarah@cleanfresh.com',
        phoneNumber: '+1-555-1002',
        role: StaffRole.driver,
        status: StaffStatus.active,
        branchId: 'branch_1',
        workingHours: {
          'monday': {'start': '09:00', 'end': '18:00'},
          'tuesday': {'start': '09:00', 'end': '18:00'},
          'wednesday': {'start': '09:00', 'end': '18:00'},
          'thursday': {'start': '09:00', 'end': '18:00'},
          'friday': {'start': '09:00', 'end': '18:00'},
        },
        permissions: [StaffPermission.manageOrders, StaffPermission.viewOrders],
        hireDate: DateTime.now().subtract(const Duration(days: 200)),
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      StaffMember(
        id: 'staff_3',
        laundretteId: 'laundrette_business_1',
        name: 'Mike Wilson',
        email: 'mike@cleanfresh.com',
        phoneNumber: '+1-555-1003',
        role: StaffRole.driver,
        status: StaffStatus.available,
        branchId: 'branch_2',
        workingHours: {
          'monday': {'start': '10:00', 'end': '19:00'},
          'tuesday': {'start': '10:00', 'end': '19:00'},
          'wednesday': {'start': '10:00', 'end': '19:00'},
          'thursday': {'start': '10:00', 'end': '19:00'},
          'friday': {'start': '10:00', 'end': '19:00'},
        },
        permissions: [StaffPermission.manageOrders, StaffPermission.viewOrders],
        hireDate: DateTime.now().subtract(const Duration(days: 100)),
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      StaffMember(
        id: 'staff_4',
        laundretteId: 'laundrette_private_1',
        name: 'Lisa Brown',
        email: 'lisa@laundry.com',
        phoneNumber: '+1-555-2001',
        role: StaffRole.manager,
        status: StaffStatus.active,
        branchId: 'branch_3',
        workingHours: {
          'monday': {'start': '09:00', 'end': '18:00'},
          'tuesday': {'start': '09:00', 'end': '18:00'},
          'wednesday': {'start': '09:00', 'end': '18:00'},
          'thursday': {'start': '09:00', 'end': '18:00'},
          'friday': {'start': '09:00', 'end': '18:00'},
        },
        permissions: [StaffPermission.manageOrders, StaffPermission.viewOrders],
        hireDate: DateTime.now().subtract(const Duration(days: 150)),
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  // Mock Orders
  static List<LaundretteOrder> getMockOrders() {
    final now = DateTime.now();
    final orders = <LaundretteOrder>[];

    // Generate orders for the last 30 days
    for (int i = 0; i < 50; i++) {
      final daysAgo = _random.nextInt(30);
      final createdAt = now.subtract(Duration(days: daysAgo));

      final branches = getMockBranches();
      final branch = branches[_random.nextInt(branches.length)];

      final statuses = LaundretteOrderStatus.values;
      final status = statuses[_random.nextInt(statuses.length)];

      final orderItems = _generateOrderItems();
      final subtotal = orderItems.fold(
        0.0,
        (sum, item) =>
            sum + (item['price'] as double) * (item['quantity'] as int),
      );
      final tax = subtotal * 0.08; // 8% tax
      final total = subtotal + tax;

      orders.add(
        LaundretteOrder(
          id: 'order_${i + 1}',
          laundretteId: branch.laundretteId,
          branchId: branch.id,
          customerId: 'customer_${_random.nextInt(20) + 1}',
          customerName: _getRandomCustomerName(),
          customerPhone: '+1-555-${_random.nextInt(9000) + 1000}',
          customerEmail: 'customer${_random.nextInt(20) + 1}@example.com',
          orderItems: orderItems,
          subtotal: subtotal,
          tax: tax,
          total: total,
          status: status,
          priority:
              _random.nextBool()
                  ? OrderPriority.standard
                  : OrderPriority.priority,
          paymentMethod: _getRandomPaymentMethod(),
          paymentStatus: _getRandomPaymentStatus(),
          specialInstructions:
              _random.nextBool() ? _getRandomInstructions() : null,
          estimatedPickupTime: createdAt.add(
            Duration(hours: _random.nextInt(24) + 1),
          ),
          estimatedDeliveryTime: createdAt.add(
            Duration(hours: _random.nextInt(48) + 24),
          ),
          actualPickupTime:
              status.index >= 2
                  ? createdAt.add(Duration(hours: _random.nextInt(24) + 1))
                  : null,
          actualDeliveryTime:
              status == LaundretteOrderStatus.delivered
                  ? createdAt.add(Duration(hours: _random.nextInt(48) + 24))
                  : null,
          driverId:
              status.index >= 3 ? 'staff_${_random.nextInt(3) + 2}' : null,
          driverName: status.index >= 3 ? _getRandomDriverName() : null,
          rejectionReason:
              status == LaundretteOrderStatus.declined
                  ? _getRandomRejectionReason()
                  : null,
          createdAt: createdAt,
          updatedAt: createdAt.add(Duration(minutes: _random.nextInt(60))),
        ),
      );
    }

    return orders..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static List<Map<String, dynamic>> _generateOrderItems() {
    final services = ['wash', 'dry', 'iron', 'dry_clean', 'express'];
    final items = <Map<String, dynamic>>[];
    final itemCount = _random.nextInt(3) + 1; // 1-3 items per order

    for (int i = 0; i < itemCount; i++) {
      final service = services[_random.nextInt(services.length)];
      final quantity = _random.nextInt(3) + 1; // 1-3 quantity
      final price = _getServicePrice(service);

      items.add({
        'service': service,
        'quantity': quantity,
        'price': price,
        'description': _getServiceDescription(service),
      });
    }

    return items;
  }

  static double _getServicePrice(String service) {
    switch (service) {
      case 'wash':
        return 15.0 + _random.nextDouble() * 10;
      case 'dry':
        return 10.0 + _random.nextDouble() * 5;
      case 'iron':
        return 8.0 + _random.nextDouble() * 4;
      case 'dry_clean':
        return 25.0 + _random.nextDouble() * 10;
      case 'express':
        return 30.0 + _random.nextDouble() * 15;
      default:
        return 15.0;
    }
  }

  static String _getServiceDescription(String service) {
    switch (service) {
      case 'wash':
        return 'Wash and dry service';
      case 'dry':
        return 'Dry cleaning only';
      case 'iron':
        return 'Ironing service';
      case 'dry_clean':
        return 'Professional dry cleaning';
      case 'express':
        return 'Express same-day service';
      default:
        return 'Laundry service';
    }
  }

  static String _getRandomCustomerName() {
    final firstNames = [
      'John',
      'Jane',
      'Mike',
      'Sarah',
      'David',
      'Lisa',
      'Chris',
      'Emma',
      'Alex',
      'Maria',
    ];
    final lastNames = [
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Garcia',
      'Miller',
      'Davis',
      'Rodriguez',
      'Martinez',
    ];

    return '${firstNames[_random.nextInt(firstNames.length)]} ${lastNames[_random.nextInt(lastNames.length)]}';
  }

  static String _getRandomDriverName() {
    final names = [
      'John Smith',
      'Sarah Johnson',
      'Mike Wilson',
      'Lisa Brown',
      'Chris Davis',
    ];
    return names[_random.nextInt(names.length)];
  }

  static String _getRandomPaymentMethod() {
    final methods = ['credit_card', 'debit_card', 'cash', 'paypal'];
    return methods[_random.nextInt(methods.length)];
  }

  static PaymentStatus _getRandomPaymentStatus() {
    final statuses = PaymentStatus.values;
    return statuses[_random.nextInt(statuses.length)];
  }

  static String _getRandomInstructions() {
    final instructions = [
      'Please use gentle cycle',
      'No fabric softener',
      'Hang dry only',
      'Cold water only',
      'Delicate handling required',
      'Extra rinse cycle',
    ];
    return instructions[_random.nextInt(instructions.length)];
  }

  static String _getRandomRejectionReason() {
    final reasons = [
      'Outside service area',
      'Unavailable driver',
      'Branch capacity full',
      'Invalid order details',
      'Payment failed',
    ];
    return reasons[_random.nextInt(reasons.length)];
  }

  // Mock Analytics Data
  static Map<String, dynamic> getMockAnalyticsData() {
    final orders = getMockOrders();
    final branches = getMockBranches();
    final staff = getMockStaff();

    // Calculate basic metrics
    final totalOrders = orders.length;
    final completedOrders =
        orders.where((o) => o.status == LaundretteOrderStatus.delivered).length;
    final pendingOrders =
        orders
            .where(
              (o) =>
                  o.status == LaundretteOrderStatus.pending ||
                  o.status == LaundretteOrderStatus.approved ||
                  o.status == LaundretteOrderStatus.confirmed,
            )
            .length;
    final cancelledOrders =
        orders
            .where(
              (o) =>
                  o.status == LaundretteOrderStatus.cancelled ||
                  o.status == LaundretteOrderStatus.declined,
            )
            .length;

    final totalRevenue = orders.fold(0.0, (sum, order) => sum + order.total);
    final averageOrderValue =
        totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

    // Revenue by day (last 7 days)
    final revenueByDay = <String, double>{};
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayOrders =
          orders
              .where(
                (o) =>
                    o.createdAt.year == date.year &&
                    o.createdAt.month == date.month &&
                    o.createdAt.day == date.day,
              )
              .toList();
      revenueByDay[dateKey] = dayOrders.fold(
        0.0,
        (sum, order) => sum + order.total,
      );
    }

    // Orders by day (last 7 days)
    final ordersByDay = <String, int>{};
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayOrders =
          orders
              .where(
                (o) =>
                    o.createdAt.year == date.year &&
                    o.createdAt.month == date.month &&
                    o.createdAt.day == date.day,
              )
              .toList();
      ordersByDay[dateKey] = dayOrders.length;
    }

    // Revenue by branch
    final revenueByBranch = <String, double>{};
    final ordersByBranch = <String, int>{};
    for (final branch in branches) {
      final branchOrders =
          orders.where((o) => o.branchId == branch.id).toList();
      revenueByBranch[branch.name] = branchOrders.fold(
        0.0,
        (sum, order) => sum + order.total,
      );
      ordersByBranch[branch.name] = branchOrders.length;
    }

    // Top services
    final serviceCount = <String, int>{};
    for (final order in orders) {
      for (final item in order.orderItems) {
        final service = item['service'] as String;
        serviceCount[service] =
            (serviceCount[service] ?? 0) + (item['quantity'] as int);
      }
    }
    final topServices =
        serviceCount.entries
            .map((e) => {'service': e.key, 'count': e.value})
            .toList()
          ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

    // Top customers
    final customerOrders = <String, List<LaundretteOrder>>{};
    for (final order in orders) {
      customerOrders[order.customerId] ??= [];
      customerOrders[order.customerId]!.add(order);
    }
    final topCustomers =
        customerOrders.entries
            .map(
              (e) => {
                'customerId': e.key,
                'customerName': e.value.first.customerName,
                'orderCount': e.value.length,
                'totalSpent': e.value.fold(
                  0.0,
                  (sum, order) => sum + order.total,
                ),
              },
            )
            .toList()
          ..sort(
            (a, b) => (b['totalSpent'] as double).compareTo(
              a['totalSpent'] as double,
            ),
          );

    // Staff performance
    final staffPerformance = <Map<String, dynamic>>[];
    for (final member in staff) {
      if (member.role == StaffRole.driver) {
        final driverOrders =
            orders.where((o) => o.driverId == member.id).toList();
        final completedOrders =
            driverOrders
                .where((o) => o.status == LaundretteOrderStatus.delivered)
                .length;

        staffPerformance.add({
          'staffId': member.id,
          'name': member.name,
          'totalOrders': driverOrders.length,
          'completedOrders': completedOrders,
          'completionRate':
              driverOrders.isNotEmpty
                  ? (completedOrders / driverOrders.length) * 100
                  : 0.0,
          'totalRevenue': driverOrders.fold(
            0.0,
            (sum, order) => sum + order.total,
          ),
        });
      }
    }
    staffPerformance.sort(
      (a, b) => (b['completionRate'] as double).compareTo(
        a['completionRate'] as double,
      ),
    );

    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'pendingOrders': pendingOrders,
      'cancelledOrders': cancelledOrders,
      'totalRevenue': totalRevenue,
      'averageOrderValue': averageOrderValue,
      'revenueByDay': revenueByDay,
      'ordersByDay': ordersByDay,
      'revenueByBranch': revenueByBranch,
      'ordersByBranch': ordersByBranch,
      'topServices': topServices,
      'topCustomers': topCustomers,
      'staffPerformance': staffPerformance,
      'customerSatisfaction': 4.2,
      'driverEfficiency': 85.0,
      'totalDeliveries': completedOrders,
      'averageDeliveryTime': 2.5, // hours
    };
  }
}
