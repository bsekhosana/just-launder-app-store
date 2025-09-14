import 'package:flutter/material.dart';
import '../../../data/models/laundrette_profile.dart';
import '../../../data/models/subscription.dart';

/// Laundrette profile provider for managing business profile
class LaundretteProfileProvider extends ChangeNotifier {
  LaundretteProfile? _currentProfile;
  Subscription? _currentSubscription;
  bool _isLoading = false;

  LaundretteProfile? get currentProfile => _currentProfile;
  Subscription? get currentSubscription => _currentSubscription;
  bool get isLoading => _isLoading;

  /// Create new laundrette profile during onboarding
  Future<void> createProfile({
    required String businessName,
    required String businessType,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required String firstName,
    required String lastName,
    required String phone,
    required String selectedPlan,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create new profile
      _currentProfile = LaundretteProfile(
        id: 'laundrette_new_1',
        ownerId: 'user_new_1',
        businessName: businessName,
        type:
            businessType == 'private'
                ? LaundretteType.private
                : LaundretteType.business,
        businessRegistrationNumber:
            'REG${DateTime.now().millisecondsSinceEpoch}',
        taxId: 'TAX${DateTime.now().millisecondsSinceEpoch}',
        description: 'New laundry business',
        logoUrl: null,
        website: null,
        phoneNumber: phone,
        email: 'new@laundrette.com',
        address: address,
        city: city,
        postcode: zipCode,
        country: 'USA',
        latitude: 40.7128,
        longitude: -74.0060,
        isActive: true,
        isVerified: false,
        settings: {
          'notifications': true,
          'autoAcceptOrders': false,
          'priorityDelivery': false,
          'firstName': firstName,
          'lastName': lastName,
          'onboardingCompleted': true,
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create subscription based on selected plan
      _currentSubscription = Subscription(
        id: 'sub_new_1',
        laundretteId: 'laundrette_new_1',
        name: selectedPlan == 'starter' ? 'Starter Plan' : 'Professional Plan',
        type:
            businessType == 'private'
                ? SubscriptionType.private
                : SubscriptionType.business,
        businessTier:
            businessType == 'business'
                ? (selectedPlan == 'starter'
                    ? BusinessTier.starter
                    : BusinessTier.professional)
                : null,
        privateTier:
            businessType == 'private'
                ? (selectedPlan == 'starter'
                    ? PrivateTier.basic
                    : PrivateTier.premium)
                : null,
        description:
            selectedPlan == 'starter'
                ? 'Starter plan for small businesses'
                : 'Professional plan for growing businesses',
        monthlyPrice: selectedPlan == 'starter' ? 29.99 : 79.99,
        currency: 'USD',
        isActive: true,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        features:
            selectedPlan == 'starter'
                ? {
                  SubscriptionFeatures.maxBranches: 1,
                  SubscriptionFeatures.maxStaff: 3,
                  SubscriptionFeatures.advancedAnalytics: false,
                  SubscriptionFeatures.prioritySupport: false,
                  SubscriptionFeatures.customBranding: false,
                  SubscriptionFeatures.apiAccess: false,
                  // Driver management removed - handled by standalone app
                  SubscriptionFeatures.orderAutoAccept: false,
                  SubscriptionFeatures.priorityDelivery: false,
                }
                : {
                  SubscriptionFeatures.maxBranches: 5,
                  SubscriptionFeatures.maxStaff: 15,
                  SubscriptionFeatures.advancedAnalytics: true,
                  SubscriptionFeatures.prioritySupport: true,
                  SubscriptionFeatures.customBranding: true,
                  SubscriptionFeatures.apiAccess: false,
                  // Driver management removed - handled by standalone app
                  SubscriptionFeatures.orderAutoAccept: true,
                  SubscriptionFeatures.priorityDelivery: true,
                },
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Load laundrette profile
  Future<void> loadProfile(String laundretteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with real API call
      if (laundretteId == 'laundrette_business_1') {
        _currentProfile = LaundretteProfile(
          id: 'laundrette_business_1',
          ownerId: 'user_business_1',
          businessName: 'Elite Laundry Services',
          type: LaundretteType.business,
          businessRegistrationNumber: 'REG123456789',
          taxId: 'TAX987654321',
          description:
              'Premium laundry services for businesses and individuals',
          logoUrl: 'https://example.com/logo.png',
          website: 'https://elitelaundry.com',
          phoneNumber: '+1-555-0123',
          email: 'info@elitelaundry.com',
          address: '123 Business Street',
          city: 'New York',
          postcode: '10001',
          country: 'USA',
          latitude: 40.7128,
          longitude: -74.0060,
          isActive: true,
          isVerified: true,
          settings: {
            'notifications': true,
            'autoAcceptOrders': false,
            'priorityDelivery': true,
          },
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
          updatedAt: DateTime.now(),
        );

        _currentSubscription = Subscription(
          id: 'sub_business_pro',
          laundretteId: 'laundrette_business_1',
          type: SubscriptionType.business,
          businessTier: BusinessTier.professional,
          name: 'Business Professional',
          description: 'Professional plan for growing businesses',
          monthlyPrice: 99.99,
          currency: 'USD',
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 335)),
          isActive: true,
          features: {
            SubscriptionFeatures.maxBranches: 5,
            SubscriptionFeatures.maxStaff: 15,
            SubscriptionFeatures.advancedAnalytics: true,
            SubscriptionFeatures.prioritySupport: true,
            SubscriptionFeatures.customBranding: true,
            SubscriptionFeatures.apiAccess: true,
            SubscriptionFeatures.multiLocationManagement: true,
            // Driver management removed - handled by standalone app
            SubscriptionFeatures.orderAutoAccept: true,
            SubscriptionFeatures.priorityDelivery: true,
            SubscriptionFeatures.customPricing: true,
            SubscriptionFeatures.staffScheduling: true,
            SubscriptionFeatures.inventoryManagement: true,
            SubscriptionFeatures.customerCommunication: true,
            SubscriptionFeatures.reportingAndInsights: true,
          },
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        );
      } else if (laundretteId == 'laundrette_private_1') {
        _currentProfile = LaundretteProfile(
          id: 'laundrette_private_1',
          ownerId: 'user_private_1',
          businessName: 'Home Laundry Solutions',
          type: LaundretteType.private,
          description: 'Personal laundry service from home',
          phoneNumber: '+1-555-0456',
          email: 'home@laundrysolutions.com',
          address: '456 Home Avenue',
          city: 'Los Angeles',
          postcode: '90210',
          country: 'USA',
          latitude: 34.0522,
          longitude: -118.2437,
          isActive: true,
          isVerified: false,
          settings: {
            'notifications': true,
            'autoAcceptOrders': true,
            'priorityDelivery': false,
          },
          createdAt: DateTime.now().subtract(const Duration(days: 180)),
          updatedAt: DateTime.now(),
        );

        _currentSubscription = Subscription(
          id: 'sub_private_premium',
          laundretteId: 'laundrette_private_1',
          type: SubscriptionType.private,
          privateTier: PrivateTier.premium,
          name: 'Private Premium',
          description: 'Premium plan for home-based laundrettes',
          monthlyPrice: 29.99,
          currency: 'USD',
          startDate: DateTime.now().subtract(const Duration(days: 15)),
          endDate: DateTime.now().add(const Duration(days: 350)),
          isActive: true,
          features: {
            SubscriptionFeatures.maxBranches: 1,
            SubscriptionFeatures.maxStaff: 3,
            SubscriptionFeatures.advancedAnalytics: false,
            SubscriptionFeatures.prioritySupport: false,
            SubscriptionFeatures.customBranding: false,
            SubscriptionFeatures.apiAccess: false,
            SubscriptionFeatures.multiLocationManagement: false,
            // Driver management removed - handled by standalone app
            SubscriptionFeatures.orderAutoAccept: true,
            SubscriptionFeatures.priorityDelivery: false,
            SubscriptionFeatures.customPricing: true,
            SubscriptionFeatures.staffScheduling: false,
            SubscriptionFeatures.inventoryManagement: false,
            SubscriptionFeatures.customerCommunication: true,
            SubscriptionFeatures.reportingAndInsights: false,
          },
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile
  Future<bool> updateProfile(LaundretteProfile updatedProfile) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _currentProfile = updatedProfile;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update subscription
  Future<bool> updateSubscription(Subscription updatedSubscription) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _currentSubscription = updatedSubscription;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
