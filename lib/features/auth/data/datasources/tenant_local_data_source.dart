import 'package:shared_preferences/shared_preferences.dart';
import '../models/tenant_model.dart';

/// Local data source for tenant authentication data persistence
class TenantLocalDataSource {
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _tenantEmailKey = 'tenant_email';
  static const String _tenantIdKey = 'tenant_id';
  static const String _authTokenKey = 'auth_token';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _mobileKey = 'mobile';
  static const String _roleKey = 'role';
  static const String _emailVerifiedKey = 'email_verified';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Check if tenant is authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  /// Get stored tenant data
  Future<TenantModel?> getStoredTenant() async {
    final prefs = await SharedPreferences.getInstance();

    final isAuth = prefs.getBool(_isAuthenticatedKey) ?? false;
    if (!isAuth) return null;

    final tenantId = prefs.getString(_tenantIdKey);
    if (tenantId == null) return null;

    return TenantModel(
      id: int.parse(tenantId),
      firstName: prefs.getString(_firstNameKey) ?? '',
      lastName: prefs.getString(_lastNameKey) ?? '',
      email: prefs.getString(_tenantEmailKey) ?? '',
      mobile: prefs.getString(_mobileKey) ?? '',
      role: prefs.getString(_roleKey) ?? 'tenant',
      emailVerifiedAt:
          prefs.getBool(_emailVerifiedKey) == true ? DateTime.now() : null,
      onboardingCompleted: prefs.getBool(_onboardingCompletedKey) ?? false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Store tenant data
  Future<void> storeTenant(TenantModel tenant, String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isAuthenticatedKey, true);
    await prefs.setString(_tenantIdKey, tenant.id.toString());
    await prefs.setString(_tenantEmailKey, tenant.email);
    await prefs.setString(_authTokenKey, token);
    await prefs.setString(_firstNameKey, tenant.firstName);
    await prefs.setString(_lastNameKey, tenant.lastName);
    await prefs.setString(_mobileKey, tenant.mobile);
    await prefs.setString(_roleKey, tenant.role);
    await prefs.setBool(_emailVerifiedKey, tenant.isEmailVerified);
    await prefs.setBool(_onboardingCompletedKey, tenant.onboardingCompleted);
  }

  /// Update tenant data
  Future<void> updateTenant(TenantModel tenant) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_firstNameKey, tenant.firstName);
    await prefs.setString(_lastNameKey, tenant.lastName);
    await prefs.setString(_tenantEmailKey, tenant.email);
    await prefs.setString(_mobileKey, tenant.mobile);
    await prefs.setString(_roleKey, tenant.role);
    await prefs.setBool(_emailVerifiedKey, tenant.isEmailVerified);
    await prefs.setBool(_onboardingCompletedKey, tenant.onboardingCompleted);
  }

  /// Update email verification status
  Future<void> updateEmailVerificationStatus(bool verified) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailVerifiedKey, verified);
  }

  /// Update onboarding completion status
  Future<void> updateOnboardingStatus(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  /// Get stored auth token
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  /// Store auth token
  Future<void> storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_isAuthenticatedKey);
    await prefs.remove(_tenantEmailKey);
    await prefs.remove(_tenantIdKey);
    await prefs.remove(_authTokenKey);
    await prefs.remove(_firstNameKey);
    await prefs.remove(_lastNameKey);
    await prefs.remove(_mobileKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_emailVerifiedKey);
    await prefs.remove(_onboardingCompletedKey);
  }

  /// Clear only auth token
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.setBool(_isAuthenticatedKey, false);
  }
}
