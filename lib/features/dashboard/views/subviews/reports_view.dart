import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/providers/auth_provider.dart';
import 'module_placeholder_view.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

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
          'Action: Please request administrator privileges to view reports.'
        ],
        isRestricted: true,
      );
    }

    return const ModulePlaceholderView(
      title: 'Analytical Reports',
      description: 'Clinic performance audit, patient demographics, sales analysis, and inventory valuation metrics.',
      icon: Icons.bar_chart_rounded,
      futureSubModules: [
        'Revenue & Billing Performance',
        'Inventory Turnover & Stock Valuations',
        'Patient Flow & Appointment Demographics',
        'Audit Logs & Clinician Activity Reports',
        'Custom Data Exports (Excel, PDF)'
      ],
    );
  }
}
