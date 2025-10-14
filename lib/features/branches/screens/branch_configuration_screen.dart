import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/theme.dart';
import '../../../core/widgets/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/watermark_background.dart';
import '../providers/branch_configuration_provider.dart';
import '../data/models/branch_configuration_model.dart';

/// Screen for configuring branch payment and operational settings
class BranchConfigurationScreen extends StatefulWidget {
  final String branchId;
  final String branchName;

  const BranchConfigurationScreen({
    super.key,
    required this.branchId,
    required this.branchName,
  });

  @override
  State<BranchConfigurationScreen> createState() =>
      _BranchConfigurationScreenState();
}

class _BranchConfigurationScreenState extends State<BranchConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _maxOrdersController = TextEditingController();
  final _bundleDiscountController = TextEditingController();
  final _priorityFeeController = TextEditingController();

  bool _autoApprove = false;
  bool _enableBundleDiscount = false;
  bool _supportsPriority = false;
  bool _acceptsOnline = true;
  bool _acceptsCash = false;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  @override
  void dispose() {
    _maxOrdersController.dispose();
    _bundleDiscountController.dispose();
    _priorityFeeController.dispose();
    super.dispose();
  }

  Future<void> _loadConfiguration() async {
    final provider = context.read<BranchConfigurationProvider>();
    await provider.loadBranchConfiguration(widget.branchId);

    if (provider.configuration != null) {
      final config = provider.configuration!;
      setState(() {
        _autoApprove = config.autoApproveOrders;
        _enableBundleDiscount = config.enableBundleDiscount;
        _supportsPriority = config.supportsPriorityDelivery;
        _acceptsOnline = config.acceptsOnlinePayments;
        _acceptsCash = config.acceptsCashPayments;
        _maxOrdersController.text = config.maxConcurrentOrders.toString();
        _bundleDiscountController.text =
            config.bundleDiscountPercentage.toString();
        _priorityFeeController.text = config.priorityDeliveryFee.toString();
      });
    }
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BranchConfigurationProvider>();

    final updates = {
      'auto_approve_orders': _autoApprove,
      'enable_bundle_discount': _enableBundleDiscount,
      'bundle_discount_percentage':
          double.tryParse(_bundleDiscountController.text) ?? 0.0,
      'max_concurrent_orders': int.tryParse(_maxOrdersController.text) ?? 50,
      'supports_priority_delivery': _supportsPriority,
      'priority_delivery_fee':
          double.tryParse(_priorityFeeController.text) ?? 0.0,
      'accepts_online_payments': _acceptsOnline,
      'accepts_cash_payments': _acceptsCash,
    };

    final success = await provider.updateBranchConfiguration(
      widget.branchId,
      updates,
    );

    if (success && mounted) {
      CustomSnackbar.showSuccess(context, 'Configuration updated successfully');
    } else if (mounted) {
      CustomSnackbar.showError(
        context,
        provider.errorMessage ?? 'Failed to update configuration',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Configure ${widget.branchName}'),
        elevation: 0,
      ),
      body: WatermarkBackground(
        icon: FontAwesomeIcons.gear,
        child: Consumer<BranchConfigurationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Management Section
                    _buildSectionCard(
                      'Order Management',
                      FontAwesomeIcons.boxOpen,
                      [
                        _buildSwitchTile(
                          'Auto-Approve Orders',
                          'Automatically approve orders without manual review',
                          _autoApprove,
                          (value) => setState(() => _autoApprove = value),
                        ),
                        const Divider(height: AppSpacing.l),
                        _buildTextFieldTile(
                          'Max Concurrent Orders',
                          'Maximum number of orders to accept at once',
                          _maxOrdersController,
                          TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter max orders';
                            }
                            final num = int.tryParse(value);
                            if (num == null || num < 1) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Discounts Section
                    _buildSectionCard(
                      'Discounts & Promotions',
                      FontAwesomeIcons.tag,
                      [
                        _buildSwitchTile(
                          'Enable Bundle Discount',
                          'Offer discount when customer orders all 3 services',
                          _enableBundleDiscount,
                          (value) =>
                              setState(() => _enableBundleDiscount = value),
                        ),
                        if (_enableBundleDiscount) ...[
                          const Divider(height: AppSpacing.l),
                          _buildTextFieldTile(
                            'Bundle Discount Percentage',
                            'Discount percentage for bundle orders',
                            _bundleDiscountController,
                            const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            suffix: '%',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter discount percentage';
                              }
                              final num = double.tryParse(value);
                              if (num == null || num < 0 || num > 100) {
                                return 'Please enter 0-100';
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Delivery Options Section
                    _buildSectionCard(
                      'Delivery Options',
                      FontAwesomeIcons.truck,
                      [
                        _buildSwitchTile(
                          'Priority Delivery',
                          'Offer express delivery service',
                          _supportsPriority,
                          (value) => setState(() => _supportsPriority = value),
                        ),
                        if (_supportsPriority) ...[
                          const Divider(height: AppSpacing.l),
                          _buildTextFieldTile(
                            'Priority Delivery Fee',
                            'Additional fee for priority delivery',
                            _priorityFeeController,
                            const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            prefix: '£',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter priority fee';
                              }
                              final num = double.tryParse(value);
                              if (num == null || num < 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Payment Methods Section
                    _buildSectionCard(
                      'Payment Methods',
                      FontAwesomeIcons.creditCard,
                      [
                        _buildSwitchTile(
                          'Accept Online Payments',
                          'Accept card and wallet payments',
                          _acceptsOnline,
                          (value) => setState(() => _acceptsOnline = value),
                        ),
                        const Divider(height: AppSpacing.l),
                        _buildSwitchTile(
                          'Accept Cash Payments',
                          'Accept cash on delivery',
                          _acceptsCash,
                          (value) => setState(() => _acceptsCash = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Save button
                    AnimatedButton(
                      onPressed: provider.isSaving ? null : _saveConfiguration,
                      backgroundColor: AppColors.primary,
                      child:
                          provider.isSaving
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Save Configuration',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                    const SizedBox(height: AppSpacing.l),

                    // Info notice
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      decoration: BoxDecoration(
                        color: AppColors.infoContainer,
                        borderRadius: BorderRadius.circular(AppRadii.m),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            FontAwesomeIcons.circleInfo,
                            color: AppColors.info,
                            size: 16,
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              'Changes will take effect immediately for new orders. Existing orders will not be affected.',
                              style: AppTypography.textTheme.bodySmall
                                  ?.copyWith(color: AppColors.onSurface),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return CardX(
      elevation: AppElevations.card,
      borderRadius: AppRadii.l,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.s),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.m),
              Text(
                title,
                style: AppTypography.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildTextFieldTile(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType keyboardType, {
    String? prefix,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.m),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.m,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
