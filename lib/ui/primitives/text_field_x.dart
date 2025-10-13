import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/motion.dart';
import '../../design_system/icons.dart';
import '../../design_system/color_schemes.dart';

/// Enhanced text field with floating label, states, and animations
/// Provides modern input experience with visual feedback
class TextFieldX extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final bool autofocus;
  final bool enableSuggestions;
  final bool autocorrect;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;
  final List<BoxShadow>? shadows;
  final Duration animationDuration;
  final Curve animationCurve;

  const TextFieldX({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 2.0,
    this.shadows,
    this.animationDuration = AppMotion.normal,
    this.animationCurve = AppCurves.standard,
  });

  @override
  State<TextFieldX> createState() => _TextFieldXState();
}

class _TextFieldXState extends State<TextFieldX>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _labelAnimation;
  late Animation<Color?> _borderColorAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _labelAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _borderColorAnimation = ColorTween(
      begin: widget.borderColor,
      end: widget.focusedBorderColor,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    final effectiveBackgroundColor =
        widget.backgroundColor ?? Colors.grey.shade50;
    final effectiveBorderColor =
        hasError
            ? (widget.errorBorderColor ?? colorScheme.error)
            : (widget.borderColor ?? Colors.grey.withOpacity(0.08));
    final effectiveFocusedBorderColor =
        hasError
            ? (widget.errorBorderColor ?? colorScheme.error)
            : (widget.focusedBorderColor ?? AppColors.primary);

    return Container(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          if (widget.labelText != null) ...[
            AnimatedBuilder(
              animation: _labelAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _labelAnimation.value,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.labelText!,
                    style: AppTypography.inputLabel.copyWith(
                      color:
                          hasError
                              ? colorScheme.error
                              : (_isFocused
                                  ? effectiveFocusedBorderColor
                                  : colorScheme.onSurfaceVariant),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s),
          ],

          // Text Field Container
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: effectiveBackgroundColor,
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(12),
                  border: Border.all(
                    color: _borderColorAnimation.value ?? effectiveBorderColor,
                    width: _isFocused ? 0.8 : 0.3,
                  ),
                  boxShadow:
                      _isFocused
                          ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 16,
                              spreadRadius: 0,
                              offset: const Offset(0, 1),
                            ),
                          ]
                          : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.015),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: const Offset(0, 1),
                            ),
                          ],
                ),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  obscureText: _obscureText,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  validator: widget.validator,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  onTap: widget.onTap,
                  textCapitalization: widget.textCapitalization,
                  textAlign: widget.textAlign,
                  autofocus: widget.autofocus,
                  enableSuggestions: widget.enableSuggestions,
                  autocorrect: widget.autocorrect,
                  style: AppTypography.inputText.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    hintText: widget.hintText,
                    hintStyle: AppTypography.inputHint.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon:
                        widget.prefixWidget ??
                        (widget.prefixIcon != null
                            ? Icon(
                              widget.prefixIcon,
                              color:
                                  hasError
                                      ? colorScheme.error
                                      : (_isFocused
                                          ? effectiveFocusedBorderColor
                                          : colorScheme.onSurfaceVariant),
                              size: 20,
                            )
                            : null),
                    suffixIcon:
                        widget.suffixWidget ??
                        (widget.obscureText
                            ? IconButton(
                              icon: Icon(
                                _obscureText
                                    ? AppIcons.visibilityOff
                                    : AppIcons.visibility,
                                color:
                                    hasError
                                        ? colorScheme.error
                                        : (_isFocused
                                            ? effectiveFocusedBorderColor
                                            : colorScheme.onSurfaceVariant),
                                size: 20,
                              ),
                              onPressed: _toggleObscureText,
                            )
                            : (widget.suffixIcon != null
                                ? Icon(
                                  widget.suffixIcon,
                                  color:
                                      hasError
                                          ? colorScheme.error
                                          : (_isFocused
                                              ? effectiveFocusedBorderColor
                                              : colorScheme.onSurfaceVariant),
                                  size: 20,
                                )
                                : null)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding:
                        widget.padding ??
                        SpacingUtils.all(AppSpacing.inputPadding),
                    counterText: '',
                  ),
                ),
              );
            },
          ),

          // Helper/Error Text
          if (widget.helperText != null || hasError) ...[
            const SizedBox(height: AppSpacing.s),
            AnimatedSwitcher(
              duration: AppMotion.fast,
              child:
                  hasError
                      ? Text(
                        widget.errorText!,
                        key: const ValueKey('error'),
                        style: AppTypography.errorText.copyWith(
                          color: colorScheme.error,
                        ),
                      )
                      : Text(
                        widget.helperText!,
                        key: const ValueKey('helper'),
                        style: AppTypography.inputLabel.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Predefined text field variants
class TextFieldsX {
  /// Standard text field
  static Widget standard({
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    bool enabled = true,
    bool readOnly = false,
    int? maxLines,
    int? minLines,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    void Function()? onTap,
    FocusNode? focusNode,
    double? width,
  }) {
    return TextFieldX(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      width: width,
    );
  }

  /// Email text field with validation
  static Widget email({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    bool enabled = true,
    bool readOnly = false,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    double? width,
  }) {
    return TextFieldX(
      key: key,
      controller: controller,
      labelText: labelText ?? 'Email',
      hintText: hintText ?? 'Enter your email',
      helperText: helperText,
      errorText: errorText,
      prefixIcon: AppIcons.email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: enabled,
      readOnly: readOnly,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      width: width,
    );
  }

  /// Password text field with toggle visibility
  static Widget password({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    bool enabled = true,
    bool readOnly = false,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    double? width,
  }) {
    return TextFieldX(
      key: key,
      controller: controller,
      labelText: labelText ?? 'Password',
      hintText: hintText ?? 'Enter your password',
      helperText: helperText,
      errorText: errorText,
      prefixIcon: AppIcons.password,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      enabled: enabled,
      readOnly: readOnly,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      width: width,
    );
  }

  /// Search text field
  static Widget search({
    TextEditingController? controller,
    String? hintText,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    double? width,
  }) {
    return TextFieldX(
      controller: controller,
      hintText: hintText ?? 'Search...',
      prefixIcon: AppIcons.search,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      width: width,
    );
  }

  /// Multiline text field
  static Widget multiline({
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    int? minLines,
    int? maxLines,
    int? maxLength,
    bool enabled = true,
    bool readOnly = false,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    FocusNode? focusNode,
    double? width,
  }) {
    return TextFieldX(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      minLines: minLines ?? 3,
      maxLines: maxLines ?? 5,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      width: width,
    );
  }
}
