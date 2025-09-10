import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/staff_provider.dart';
import '../../../data/models/staff_member.dart';
import 'add_edit_staff_screen.dart';
import 'driver_management_screen.dart';
import 'driver_details_screen.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    await staffProvider.loadStaff(
      'laundrette_business_1',
    ); // Mock laundrette ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
        actions: [
          IconButton(
            icon: const Icon(Icons.directions_car),
            onPressed: _openDriverManagement,
            tooltip: 'Driver Management',
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _addStaffMember,
            tooltip: 'Add Staff',
          ),
        ],
      ),
      body: Consumer<StaffProvider>(
        builder: (context, staffProvider, child) {
          if (staffProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (staffProvider.staff.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outlined,
                    size: 64,
                    color: AppTheme.lightGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No staff members found',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.mediumGrey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first staff member to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: staffProvider.staff.length,
            itemBuilder: (context, index) {
              final staffMember = staffProvider.staff[index];
              return _buildStaffCard(staffMember);
            },
          );
        },
      ),
    );
  }

  Widget _buildStaffCard(StaffMember staffMember) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewStaffDetails(staffMember),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                child:
                    staffMember.profileImageUrl != null
                        ? ClipOval(
                          child: Image.network(
                            staffMember.profileImageUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: AppTheme.primaryBlue,
                                size: 24,
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.person,
                          color: AppTheme.primaryBlue,
                          size: 24,
                        ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staffMember.fullName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      staffMember.roleDisplayText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      staffMember.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          staffMember.isActive
                              ? AppTheme.successGreen.withOpacity(0.1)
                              : AppTheme.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            staffMember.isActive
                                ? AppTheme.successGreen
                                : AppTheme.errorRed,
                      ),
                    ),
                    child: Text(
                      staffMember.statusDisplayText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            staffMember.isActive
                                ? AppTheme.successGreen
                                : AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (staffMember.hourlyRate != null &&
                      staffMember.hourlyRate! > 0)
                    Text(
                      '\$${staffMember.hourlyRate!.toStringAsFixed(2)}/hr',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addStaffMember() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddEditStaffScreen()));
  }

  void _openDriverManagement() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DriverManagementScreen()),
    );
  }

  void _viewStaffDetails(StaffMember staffMember) {
    if (staffMember.role == StaffRole.driver) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DriverDetailsScreen(driver: staffMember),
        ),
      );
    } else {
      // TODO: Implement staff details screen for non-drivers
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Staff details coming soon'),
          backgroundColor: AppTheme.infoBlue,
        ),
      );
    }
  }
}
