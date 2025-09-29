import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/branches/data/models/laundrette_branch.dart';

/// Remote data source for tenant branch API calls
class TenantBranchRemoteDataSource {
  static const String baseUrl = 'https://justlaunder.co.uk/api/v1';
  static const String localBaseUrl = 'http://127.0.0.1:8000/api/v1';

  // Use local URL for development, production URL for release
  static String get apiBaseUrl =>
      const bool.fromEnvironment('dart.vm.product') ? baseUrl : localBaseUrl;

  static String? _authToken;
  static String? _deviceId;
  static String? _deviceName;
  static String? _platform;

  /// Initialize with device information
  static Future<void> initialize({
    required String deviceId,
    String? deviceName,
    String? platform,
  }) async {
    _deviceId = deviceId;
    _deviceName = deviceName;
    _platform = platform ?? 'android';

    // Load stored auth token
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  /// Set authentication token
  static Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Clear authentication token
  static Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Get headers for API requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    if (_deviceId != null) 'X-Device-ID': _deviceId!,
    if (_deviceName != null) 'X-Device-Name': _deviceName!,
    if (_platform != null) 'X-Platform': _platform!,
  };

  /// Get all branches for tenant
  Future<List<LaundretteBranch>> getBranches() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/tenant/branches'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final branchesData = data['data'] as List;

        return branchesData
            .map((json) => _mapToLaundretteBranch(json))
            .toList();
      } else {
        throw Exception('Failed to load branches: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get branch by ID
  Future<LaundretteBranch> getBranchById(String branchId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/tenant/branches/$branchId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _mapToLaundretteBranch(data['data']);
      } else {
        throw Exception('Failed to load branch: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Create new branch
  Future<LaundretteBranch> createBranch(Map<String, dynamic> branchData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/tenant/branches'),
        headers: _headers,
        body: jsonEncode(branchData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return _mapToLaundretteBranch(data['data']);
      } else {
        throw Exception('Failed to create branch: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Update branch
  Future<LaundretteBranch> updateBranch(
    String branchId,
    Map<String, dynamic> branchData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$apiBaseUrl/tenant/branches/$branchId'),
        headers: _headers,
        body: jsonEncode(branchData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _mapToLaundretteBranch(data['data']);
      } else {
        throw Exception('Failed to update branch: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Delete branch
  Future<bool> deleteBranch(String branchId) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiBaseUrl/tenant/branches/$branchId'),
        headers: _headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Map API response to LaundretteBranch model
  LaundretteBranch _mapToLaundretteBranch(Map<String, dynamic> json) {
    return LaundretteBranch(
      id: json['id'].toString(),
      laundretteId: json['tenant_id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      address: json['address']?['address'] as String? ?? '',
      city: json['address']?['city'] as String? ?? '',
      postcode: json['address']?['postcode'] as String? ?? '',
      country: json['address']?['country'] as String? ?? 'South Africa',
      latitude: (json['address']?['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['address']?['longitude'] as num?)?.toDouble() ?? 0.0,
      status: _mapBranchStatus(json['is_active']),
      isOpen: json['is_active'] == 1 || json['is_active'] == true,
      operatingHours: _mapOperatingHours(json['working_hours']),
      bagPricing: _mapBagPricing(json['bag_pricing']),
      servicePricing: _mapServicePricing(json['service_pricing']),
      autoAcceptOrders: json['auto_accept_orders'] == true,
      supportsPriorityDelivery: json['supports_priority_delivery'] == true,
      phoneNumber: json['phone'] as String?,
      email: json['email'] as String?,
      maxConcurrentOrders: json['max_concurrent_orders'] as int? ?? 10,
      currentOrderCount: json['current_order_count'] as int? ?? 0,
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Map branch status
  BranchStatus _mapBranchStatus(dynamic isActive) {
    if (isActive == 1 || isActive == true) {
      return BranchStatus.active;
    }
    return BranchStatus.inactive;
  }

  /// Map operating hours
  Map<String, String> _mapOperatingHours(dynamic workingHours) {
    if (workingHours == null || workingHours is! List) {
      return {
        'monday': '08:00-18:00',
        'tuesday': '08:00-18:00',
        'wednesday': '08:00-18:00',
        'thursday': '08:00-18:00',
        'friday': '08:00-18:00',
        'saturday': '09:00-17:00',
        'sunday': '10:00-16:00',
      };
    }

    final Map<String, String> hours = {};
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    for (int i = 0; i < workingHours.length && i < 7; i++) {
      final dayData = workingHours[i] as Map<String, dynamic>?;
      if (dayData != null) {
        final openTime = dayData['open_time'] as String? ?? '08:00';
        final closeTime = dayData['close_time'] as String? ?? '18:00';
        final isClosed = dayData['is_closed'] == true;

        hours[dayNames[i]] = isClosed ? 'Closed' : '$openTime-$closeTime';
      }
    }

    return hours;
  }

  /// Map bag pricing
  Map<String, double> _mapBagPricing(dynamic bagPricing) {
    if (bagPricing == null || bagPricing is! List) {
      return {
        'small': 15.99,
        'medium': 19.99,
        'large': 24.99,
        'extra_large': 29.99,
      };
    }

    final Map<String, double> pricing = {};
    for (final item in bagPricing) {
      if (item is Map<String, dynamic>) {
        final bagType = item['bag_type']?['name'] as String?;
        final price = (item['price_per_kg'] as num?)?.toDouble();
        if (bagType != null && price != null) {
          pricing[bagType.toLowerCase()] = price;
        }
      }
    }

    return pricing;
  }

  /// Map service pricing
  Map<String, double> _mapServicePricing(dynamic servicePricing) {
    if (servicePricing == null || servicePricing is! List) {
      return {
        'wash_and_fold': 2.50,
        'dry_clean': 8.99,
        'ironing': 1.99,
        'express': 5.00,
        'stain_removal': 3.50,
      };
    }

    final Map<String, double> pricing = {};
    for (final item in servicePricing) {
      if (item is Map<String, dynamic>) {
        final serviceName = item['service_option']?['name'] as String?;
        final price = (item['additional_price'] as num?)?.toDouble() ?? 0.0;
        if (serviceName != null) {
          pricing[serviceName.toLowerCase().replaceAll(' ', '_')] = price;
        }
      }
    }

    return pricing;
  }
}


