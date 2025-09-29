import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/password_generator.dart';

/// Enhanced password input field with generator and visibility toggle
class PasswordInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool showGenerator;
  final bool showVisibilityToggle;
  final Map<String, dynamic>? passwordRequirements;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;

  const PasswordInputField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.showGenerator = true,
    this.showVisibilityToggle = true,
    this.passwordRequirements,
    this.controller,
    this.focusNode,
    this.contentPadding,
    this.decoration,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;
  bool _isGenerating = false;
  PasswordValidationResult? _validationResult;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.passwordRequirements != null) {
      _validationResult = PasswordGenerator.validatePassword(
        _controller.text,
        requirements: widget.passwordRequirements,
      );
      setState(() {});
    }
    widget.onChanged?.call(_controller.text);
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _generatePassword() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      // Add a small delay to show loading state
      await Future.delayed(const Duration(milliseconds: 300));

      final password = PasswordGenerator.generate(
        requirements: widget.passwordRequirements,
      );

      _controller.text = password;
      _onTextChanged();

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Secure password generated!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          decoration: _buildDecoration(),
        ),
        if (_validationResult != null) ...[
          const SizedBox(height: 8),
          _buildPasswordStrength(),
        ],
      ],
    );
  }

  InputDecoration _buildDecoration() {
    return (widget.decoration ??
            InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              contentPadding: widget.contentPadding,
            ))
        .copyWith(suffixIcon: _buildSuffixIcon());
  }

  Widget _buildSuffixIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showGenerator) ...[
          IconButton(
            onPressed: _isGenerating ? null : _generatePassword,
            icon:
                _isGenerating
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.casino),
            tooltip: 'Generate secure password',
          ),
        ],
        if (widget.showVisibilityToggle) ...[
          IconButton(
            onPressed: _toggleVisibility,
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            tooltip: _obscureText ? 'Show password' : 'Hide password',
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordStrength() {
    if (_validationResult == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password Strength: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              _validationResult!.strength.displayName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Color(
                  int.parse(
                        _validationResult!.strength.color.substring(1),
                        radix: 16,
                      ) +
                      0xFF000000,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: _getStrengthValue(_validationResult!.strength),
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Color(
              int.parse(
                    _validationResult!.strength.color.substring(1),
                    radix: 16,
                  ) +
                  0xFF000000,
            ),
          ),
        ),
        if (_validationResult!.errors.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._validationResult!.errors.map(
            (error) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: Colors.red[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      error,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.red[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  double _getStrengthValue(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }
}

/// Password requirements widget
class PasswordRequirements extends StatelessWidget {
  final Map<String, dynamic> requirements;
  final String? password;

  const PasswordRequirements({
    super.key,
    required this.requirements,
    this.password,
  });

  @override
  Widget build(BuildContext context) {
    final validationResult =
        password != null
            ? PasswordGenerator.validatePassword(
              password!,
              requirements: requirements,
            )
            : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements:',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildRequirement(
            context,
            'At least ${requirements['minLength'] ?? 8} characters',
            _checkMinLength(),
          ),
          _buildRequirement(
            context,
            'At least one uppercase letter',
            _checkUppercase(),
          ),
          _buildRequirement(
            context,
            'At least one lowercase letter',
            _checkLowercase(),
          ),
          _buildRequirement(context, 'At least one number', _checkNumbers()),
          _buildRequirement(
            context,
            'At least one special character',
            _checkSymbols(),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(BuildContext context, String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isValid ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isValid ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _checkMinLength() {
    if (password == null) return false;
    return password!.length >= (requirements['minLength'] ?? 8);
  }

  bool _checkUppercase() {
    if (password == null) return false;
    return password!.contains(RegExp(r'[A-Z]'));
  }

  bool _checkLowercase() {
    if (password == null) return false;
    return password!.contains(RegExp(r'[a-z]'));
  }

  bool _checkNumbers() {
    if (password == null) return false;
    return password!.contains(RegExp(r'[0-9]'));
  }

  bool _checkSymbols() {
    if (password == null) return false;
    return password!.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'));
  }
}
