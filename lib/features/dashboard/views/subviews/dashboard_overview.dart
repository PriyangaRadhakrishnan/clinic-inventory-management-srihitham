import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../widgets/stat_card.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final displayName = user?.name ?? 'User';
    final roleName = user?.isAdmin == true ? 'Administrator' : 'Clinical Staff';
    
    final isMobile = ResponsiveLayout.isMobile(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Banner Card
          Card(
            color: AppColors.primaryContainer.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              side: BorderSide(color: AppColors.primary.withOpacity(0.15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.welcomeBackUser}$displayName',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primary,
                                fontSize: isMobile ? 20 : 24,
                              ),
                        ),
                        const SizedBox(height: AppDimensions.spaceXS),
                        Text(
                          'You are logged in as $roleName. Here is an overview of Shri Hitham clinic metrics for today.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: AppDimensions.spaceM),
                    Icon(
                      Icons.spa_outlined, // Muted leaf-like branding icon
                      size: 64,
                      color: AppColors.primary.withOpacity(0.4),
                    ),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Statistics Grid
          GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: AppDimensions.spaceM,
            mainAxisSpacing: AppDimensions.spaceM,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: isMobile ? 1.2 : 1.4,
            children: [
              StatCard(
                title: 'Active Patients',
                value: '142',
                icon: Icons.people_outline_rounded,
                color: AppColors.primary,
                subtitle: '+5 new today',
                onTap: () {},
              ),
              StatCard(
                title: 'Low Stock Items',
                value: '8',
                icon: Icons.medication_liquid_rounded,
                color: AppColors.error,
                subtitle: 'Requires purchase',
                onTap: () {},
              ),
              StatCard(
                title: 'Today\'s Billing',
                value: '₹12,450',
                icon: Icons.payments_outlined,
                color: AppColors.tertiary,
                subtitle: '12 invoices paid',
                onTap: () {},
              ),
              StatCard(
                title: 'Pending Purchases',
                value: '3',
                icon: Icons.local_shipping_outlined,
                color: AppColors.secondary,
                subtitle: 'In transit',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Main Row: Recent Activities & Shortcuts
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activity Log Card
                  Expanded(
                    flex: isWide ? 2 : 0,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.spaceM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Clinic Activity',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            _buildActivityRow(
                              context,
                              time: '10:45 AM',
                              user: 'Suresh Kumar',
                              action: 'Billed patient Amit Sharma (Invoice #SH-1024)',
                              icon: Icons.receipt_long_rounded,
                            ),
                            const Divider(),
                            _buildActivityRow(
                              context,
                              time: '09:30 AM',
                              user: 'Dr. Aditya',
                              action: 'Checked-in Patient Priya Patel (Cardiology Consultation)',
                              icon: Icons.assignment_ind_rounded,
                            ),
                            const Divider(),
                            _buildActivityRow(
                              context,
                              time: 'Yesterday',
                              user: 'System Bot',
                              action: 'Low Stock Alert triggered for Paracetamol 650mg tablets',
                              icon: Icons.warning_amber_rounded,
                              isAlert: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  if (isWide) const SizedBox(width: AppDimensions.spaceM) else const SizedBox(height: AppDimensions.spaceM),

                  // Shortcuts Box
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.spaceM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            _buildShortcutButton(
                              context,
                              icon: Icons.person_add_alt_1_outlined,
                              label: 'Register New Patient',
                            ),
                            const SizedBox(height: AppDimensions.spaceS),
                            _buildShortcutButton(
                              context,
                              icon: Icons.add_circle_outline_rounded,
                              label: 'Add Bill Payment',
                            ),
                            const SizedBox(height: AppDimensions.spaceS),
                            _buildShortcutButton(
                              context,
                              icon: Icons.inventory_2_outlined,
                              label: 'Stock Procurement',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(
    BuildContext context, {
    required String time,
    required String user,
    required String action,
    required IconData icon,
    bool isAlert = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isAlert ? AppColors.errorContainer : AppColors.secondaryContainer,
            child: Icon(
              icon,
              size: 20,
              color: isAlert ? AppColors.error : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
                ),
                const SizedBox(height: 2),
                Text(
                  'By $user • $time',
                  style: TextStyle(fontSize: 12.0, color: AppColors.onSurfaceVariant.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutButton(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Module transition triggered: $label')),
        );
      },
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
    );
  }
}
