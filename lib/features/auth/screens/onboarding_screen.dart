import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../profile/providers/laundrette_profile_provider.dart';
import '../providers/auth_provider.dart';
import '../../navigation/screens/main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Business Type
  String? _selectedBusinessType;
  final List<String> _businessTypes = ['Private', 'Business'];

  // Step 2: Business Details
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  // Step 3: Subscription Plan
  String? _selectedPlan;
  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Starter',
      'type': 'private',
      'price': 29.99,
      'description': 'Perfect for small laundrettes',
      'features': [
        '1 Branch',
        'Up to 3 Staff',
        'Basic Analytics',
        'Email Support',
      ],
    },
    {
      'name': 'Professional',
      'type': 'business',
      'price': 79.99,
      'description': 'Ideal for growing businesses',
      'features': [
        'Up to 5 Branches',
        'Up to 15 Staff',
        'Advanced Analytics',
        'Priority Support',
      ],
    },
  ];

  // Step 4: Profile Setup
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _businessNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      final profileProvider = Provider.of<LaundretteProfileProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Create profile
      await profileProvider.createProfile(
        businessName: _businessNameController.text.trim(),
        businessType:
            _selectedBusinessType == 'Private' ? 'private' : 'business',
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        selectedPlan: _selectedPlan ?? 'starter',
      );

      // Complete authentication
      await authProvider.completeOnboarding();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Onboarding failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                      decoration: BoxDecoration(
                        color:
                            index <= _currentStep
                                ? AppTheme.primaryBlue
                                : AppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  _buildBusinessTypeStep(),
                  _buildBusinessDetailsStep(),
                  _buildSubscriptionStep(),
                  _buildProfileStep(),
                ],
              ),
            ),
            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Previous',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                _currentStep == 3 ? 'Complete Setup' : 'Next',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessTypeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What type of business are you?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us customize your experience',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
          ),
          const SizedBox(height: 40),
          ...List.generate(_businessTypes.length, (index) {
            final type = _businessTypes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedBusinessType = type);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          _selectedBusinessType == type
                              ? AppTheme.primaryBlue
                              : AppTheme.lightGrey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color:
                        _selectedBusinessType == type
                            ? AppTheme.primaryBlue.withOpacity(0.1)
                            : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        type == 'Private' ? Icons.home : Icons.business,
                        color:
                            _selectedBusinessType == type
                                ? AppTheme.primaryBlue
                                : AppTheme.mediumGrey,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:
                                    _selectedBusinessType == type
                                        ? AppTheme.primaryBlue
                                        : AppTheme.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              type == 'Private'
                                  ? 'Individual or family laundry service'
                                  : 'Commercial laundry business',
                              style: TextStyle(
                                color:
                                    _selectedBusinessType == type
                                        ? AppTheme.primaryBlue
                                        : AppTheme.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedBusinessType == type)
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryBlue,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Details',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about your business',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _businessNameController,
            decoration: InputDecoration(
              labelText: 'Business Name',
              hintText: 'Enter your business name',
              prefixIcon: const Icon(Icons.business_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              hintText: 'Enter your business address',
              prefixIcon: const Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'City',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    hintText: 'State',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _zipCodeController,
            decoration: InputDecoration(
              labelText: 'ZIP Code',
              hintText: 'ZIP Code',
              prefixIcon: const Icon(Icons.local_post_office_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Plan',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the plan that best fits your needs',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
          ),
          const SizedBox(height: 32),
          ...List.generate(_plans.length, (index) {
            final plan = _plans[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedPlan = plan['name'].toLowerCase());
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          _selectedPlan == plan['name'].toLowerCase()
                              ? AppTheme.primaryBlue
                              : AppTheme.lightGrey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color:
                        _selectedPlan == plan['name'].toLowerCase()
                            ? AppTheme.primaryBlue.withOpacity(0.1)
                            : Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _selectedPlan ==
                                                plan['name'].toLowerCase()
                                            ? AppTheme.primaryBlue
                                            : AppTheme.darkGrey,
                                  ),
                                ),
                                Text(
                                  plan['description'],
                                  style: TextStyle(
                                    color:
                                        _selectedPlan ==
                                                plan['name'].toLowerCase()
                                            ? AppTheme.primaryBlue
                                            : AppTheme.mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${plan['price']}/month',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  _selectedPlan == plan['name'].toLowerCase()
                                      ? AppTheme.primaryBlue
                                      : AppTheme.darkGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...plan['features'].map<Widget>(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check,
                                color: AppTheme.successGreen,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                feature,
                                style: TextStyle(
                                  color:
                                      _selectedPlan ==
                                              plan['name'].toLowerCase()
                                          ? AppTheme.primaryBlue
                                          : AppTheme.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfileStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Profile',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about yourself',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
