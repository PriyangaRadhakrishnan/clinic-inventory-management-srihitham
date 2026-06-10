import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/providers/auth_provider.dart';
import 'module_placeholder_view.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Double safety role check
    if (user?.isAdmin != true) {
      return const ModulePlaceholderView(
        title: AppStrings.roleAccessRestricted,
        description: AppStrings.roleAccessRestrictedDesc,
        icon: Icons.lock_outline_rounded,
        futureSubModules: [
          'Required Role: Admin',
          'Current Role: Staff',
          'Action: Please request administrator privileges to manage users.'
        ],
        isRestricted: true,
      );
    }

    return const ModulePlaceholderView(
      title: 'User Management',
      description: 'Add new staff members, edit profile details, assign roles, and log activity streams.',
      icon: Icons.people_outline_rounded,
      futureSubModules: [
        'Staff Onboarding & Credentials Creation',
        'Role Assignment (Admin / Staff)',
        'Active Session Manager',
        'Account Suspensions & Permissions Controls',
        'Staff Activity Tracking Logs'
      ],
    );
  }
}
