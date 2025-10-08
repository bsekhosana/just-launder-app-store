import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/theme.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/widgets/reusable_otp_screen.dart';
import '../../../core/utils/log_helper.dart';
import '../../auth/providers/auth_provider.dart';

/// Edit Profile screen for updating user information
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
    final user = authProvider.currentUser;

    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _mobileController.text = user.mobile ?? '';
    }
  }

  void _checkForChanges() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user != null) {
      setState(() {
        _isEmailChanged = _emailController.text.trim() != user.email;
        _isMobileChanged = _mobileController.text.trim() != (user.mobile ?? '');
      });
    }
  }

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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

      // Send OTP first
      final success = await authProvider.sendProfileOtp(type: 'email');

      if (success) {
        LogHelper.auth('OTP sent for profile edit');

        if (mounted) {
          // Navigate to OTP verification screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ReusableOtpScreen(
                    email: _emailController.text.trim(),
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
            message:
                authProvider.error ??
                'Failed to send verification code. Please try again.',
          );
        }
      }
    } catch (e) {
      LogHelper.error('Failed to send OTP for profile edit: $e');

      if (mounted) {
        CustomSnackbar.showError(
          'Failed to send verification code. Please try again.',
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

  void _navigateToOtpVerification() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ReusableOtpScreen(
              email: _emailController.text.trim(),
              purpose: 'profile_edit',
              onOtpVerified: _handleOtpVerified,
              onResendOtp: _resendOtp,
            ),
      ),
    );
  }

  Future<void> _handleOtpVerified(String otp) async {
    LogHelper.auth('OTP verified for profile edit: $otp');

    // Proceed with profile update with OTP
    await _updateProfile(otp: otp);
  }

  Future<bool> _resendOtp() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.sendProfileOtp(type: 'email');

      if (!success) {
        throw Exception(authProvider.error ?? 'Failed to send OTP');
      }

      LogHelper.auth('OTP resent for profile edit');
      return true;
    } catch (e) {
      LogHelper.error('Failed to resend OTP for profile edit: $e');
      return false;
    }
  }

  Future<void> _updateProfile({String? otp}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.updateProfileWithOtp(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        mobile:
            _mobileController.text.trim().isNotEmpty
                ? _mobileController.text.trim()
                : null,
        otp: otp,
      );

      if (success) {
        LogHelper.auth('Profile updated successfully');

        if (mounted) {
          CustomSnackbar.showSuccess('Profile updated successfully!');
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            authProvider.error ?? 'Failed to update profile. Please try again.',
          );
        }
      }
    } catch (e) {
      LogHelper.error('Failed to update profile: $e');

      if (mounted) {
        CustomSnackbar.showError('Failed to update profile. Please try again.');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: WatermarkBackground(
        icon: Icons.person,
        iconColor: AppColors.primary,
        margin: const EdgeInsets.all(16),
        opacity: 0.10,
        iconSizePercentage: 0.45,
        iconShift: -15.0,
        child: AnimatedAuthScreen(
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          icon: Padding(
            padding: EdgeInsets.all(AppSpacing.l),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: AppColors.primary, size: 40),
            ),
          ),
          showAppBar: true,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.xxl),

                // First Name
                TextFieldX(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.l),

                // Last Name
                TextFieldX(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.l),

                // Email
                TextFieldX(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.l),

                // Mobile
                TextFieldX(
                  controller: _mobileController,
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _checkForChanges(),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (!RegExp(
                        r'^\+?[1-9]\d{1,14}$',
                      ).hasMatch(value.replaceAll(' ', ''))) {
                        return 'Please enter a valid mobile number';
                      }
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.xl),

                // OTP requirement notice
                if (_isEmailChanged || _isMobileChanged) ...[
                  Container(
                    padding: EdgeInsets.all(AppSpacing.m),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppRadii.m),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: AppSpacing.s),
                        Expanded(
                          child: Text(
                            'Changing email or mobile number requires verification. You will receive an OTP to confirm the changes.',
                            style: AppTypography.textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.l),
                ],

                // Save button
                AnimatedButton(
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleSaveProfile,
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  borderRadius: BorderRadius.circular(AppRadii.l),
                  height: 56,
                  child: Text(
                    'Save Changes',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
