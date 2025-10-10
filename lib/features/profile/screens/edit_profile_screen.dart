import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/reusable_otp_screen.dart';
import '../../../core/utils/log_helper.dart';
import '../../auth/providers/auth_provider.dart';

/// Edit Profile screen for updating tenant information
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  bool _isLoading = false;
  bool _isEmailChanged = false;
  bool _isMobileChanged = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tenant = authProvider.currentTenant;

    if (tenant != null) {
      _firstNameController.text = tenant.firstName;
      _lastNameController.text = tenant.lastName;
      _emailController.text = tenant.email;
      _mobileController.text = tenant.mobile;
    }
  }

  void _checkForChanges() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tenant = authProvider.currentTenant;

    if (tenant != null) {
      setState(() {
        _isEmailChanged = _emailController.text.trim() != tenant.email;
        _isMobileChanged = _mobileController.text.trim() != tenant.mobile;
      });
    }
  }

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if email or mobile changed - require OTP verification
    if (_isEmailChanged || _isMobileChanged) {
      await _sendOtpAndNavigateToVerification();
      return;
    }

    // If only name changed, update directly
    await _updateProfile();
  }

  Future<void> _sendOtpAndNavigateToVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final tenant = authProvider.currentTenant;

      if (tenant == null) {
        throw Exception('Tenant not found');
      }

      // Send OTP for profile changes
      final success = await authProvider.sendProfileOtp(type: 'profile_change');

      if (success) {
        LogHelper.auth('OTP sent for profile changes');

        if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReusableOtpScreen(
                  email: tenant.email,
              purpose: 'profile_edit',
              onOtpVerified: _handleOtpVerified,
              onResendOtp: _resendOtp,
                ),
            ),
          );
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            context,
            message: 'Failed to send verification code. Please try again.',
          );
        }
      }
    } catch (e) {
      LogHelper.error('Error sending OTP for profile changes: $e');
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'Failed to send verification code. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleOtpVerified(String otp) async {
    LogHelper.auth('OTP verified for profile changes: $otp');
    await _updateProfile(otp: otp);
  }

  Future<bool> _resendOtp() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.sendProfileOtp(type: 'profile_change');
      
      LogHelper.auth('OTP resent for profile changes');
      return success;
    } catch (e) {
      LogHelper.error('Failed to resend OTP for profile changes: $e');
      return false;
    }
  }

  Future<void> _updateProfile({String? otp}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _mobileController.text.trim().isNotEmpty ? _mobileController.text.trim() : null,
        otp: otp,
      );

      if (success) {
        LogHelper.auth('Profile updated successfully');

        if (mounted) {
          CustomSnackbar.showSuccess(
            context,
            message: 'Profile updated successfully',
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            context,
            message: authProvider.error ?? 'Failed to update profile. Please try again.',
          );
        }
      }
    } catch (e) {
      LogHelper.error('Error updating profile: $e');
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'Failed to update profile. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
        icon: Icons.person,
      iconColor: AppColors.primary.withOpacity(0.15),
      iconSizePercentage: 0.35,
      iconShift: -15.0,
        margin: const EdgeInsets.all(16),
      respectSafeArea: false,
            child: Container(
        color: Colors.white,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Edit Profile',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
            key: _formKey,
            child: Column(
              children: [
                    const SizedBox(height: 40),
                    
                    // Header Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Update Your Profile',
                      style: AppTypography.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Keep your information up to date',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                TextFieldX(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                              prefixIcon: Icons.person,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your first name';
                    }
                    return null;
                  },
                ),

                            const SizedBox(height: 16),

                TextFieldX(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                              prefixIcon: Icons.person,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your last name';
                    }
                    return null;
                  },
                ),

                            const SizedBox(height: 16),

                TextFieldX(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                              prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email address';
                    }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                            const SizedBox(height: 16),

                TextFieldX(
                  controller: _mobileController,
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                              prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                                  if (value.length < 10) {
                        return 'Please enter a valid mobile number';
                      }
                    }
                    return null;
                  },
                ),

                            const SizedBox(height: 32),

                if (_isEmailChanged || _isMobileChanged) ...[
                  Container(
                                padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                                    const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                                        'Changing your email or mobile number requires verification',
                            style: AppTypography.textTheme.bodySmall?.copyWith(
                                          color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                              const SizedBox(height: 16),
                ],

                            AnimatedButton(
                              onPressed: _isLoading ? null : _handleSaveProfile,
                              isLoading: _isLoading,
                              height: 56,
                              child: Text(
                                'Save Changes',
                                style: AppTypography.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
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
        ),
      ),
    );
  }
}