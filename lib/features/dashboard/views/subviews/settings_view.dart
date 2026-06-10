import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/providers/auth_provider.dart';
import 'module_placeholder_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
          'Action: Please request administrator privileges to configure settings.'
        ],
        isRestricted: true,
      );
    }

    return const ModulePlaceholderView(
      title: 'System Settings',
      description: 'Configure clinic metadata, database sync intervals, notifications, and print layouts.',
      icon: Icons.settings_outlined,
      futureSubModules: [
        'Clinic Details Setup (Address, Logo, License)',
        'Database Backup & Restore Hub',
        'SMS & Email Alert Configurations',
        'Prescription Print Customizations',
        'Billing Rates & Tax Setup'
      ],
    );
  }
}
