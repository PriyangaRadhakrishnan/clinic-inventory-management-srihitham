import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/shri_hitham_logo.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/navigation_provider.dart';

class LeftNavigationDrawer extends StatelessWidget {
  final bool isPermanent;

  const LeftNavigationDrawer({
    super.key,
    this.isPermanent = false,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final navProvider = Provider.of<NavigationProvider>(context);
    
    final user = authProvider.user;
    final name = user?.name ?? 'Guest User';
    final isAdmin = user?.isAdmin == true;
    
    final roleString = isAdmin ? AppStrings.roleAdmin : (user?.isStaff == true ? AppStrings.roleStaff : AppStrings.roleUnknown);
    final roleBadgeColor = isAdmin ? AppColors.adminBadge : AppColors.staffBadge;
    final roleBadgeBgColor = isAdmin ? AppColors.adminBadgeBg : AppColors.staffBadgeBg;

    // Define items data
    final List<_DrawerItemData> allItems = [
      _DrawerItemData(
        tab: DashboardTab.dashboard,
        label: AppStrings.navDashboard,
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      _DrawerItemData(
        tab: DashboardTab.patients,
        label: AppStrings.navPatients,
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
      _DrawerItemData(
        tab: DashboardTab.inventory,
        label: AppStrings.navInventory,
        icon: Icons.medication_liquid_rounded,
        selectedIcon: Icons.medication_rounded,
      ),
      _DrawerItemData(
        tab: DashboardTab.billing,
        label: AppStrings.navBilling,
        icon: Icons.payments_outlined,
        selectedIcon: Icons.payments_rounded,
      ),
      _DrawerItemData(
        tab: DashboardTab.purchases,
        label: AppStrings.navPurchases,
        icon: Icons.local_shipping_outlined,
        selectedIcon: Icons.local_shipping_rounded,
      ),
      // Admin only modules
      _DrawerItemData(
        tab: DashboardTab.reports,
        label: AppStrings.navReports,
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart_rounded,
        adminOnly: true,
      ),
      _DrawerItemData(
        tab: DashboardTab.userManagement,
        label: AppStrings.navUserManagement,
        icon: Icons.people_alt_outlined,
        selectedIcon: Icons.people_alt_rounded,
        adminOnly: true,
      ),
      _DrawerItemData(
        tab: DashboardTab.settings,
        label: AppStrings.navSettings,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        adminOnly: true,
      ),
      _DrawerItemData(
        tab: DashboardTab.profile,
        label: AppStrings.navMyProfile,
        icon: Icons.account_circle_outlined,
        selectedIcon: Icons.account_circle_rounded,
      ),
    ];

    // Filter drawer items based on User Role.
    // Staff MUST NOT see: Reports, User Management, Settings.
    final List<_DrawerItemData> visibleItems = allItems.where((item) {
      if (item.adminOnly) {
        return isAdmin; // Only show to Admins
      }
      return true;
    }).toList();

    return Container(
      width: AppDimensions.drawerWidthExpanded,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: AppColors.border,
            width: isPermanent ? AppDimensions.borderThickness : 0.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceM,
              vertical: AppDimensions.spaceXL,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: AppDimensions.borderThickness),
              ),
            ),
            child: Row(
              children: [
                const ShriHithamLogo(size: AppDimensions.logoSizeMedium),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.onBackground,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: roleBadgeBgColor,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                        ),
                        child: Text(
                          roleString.toUpperCase(),
                          style: TextStyle(
                            color: roleBadgeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Drawer Navigation Items List
          Expanded(
            child: ListView.builder(
              itemCount: visibleItems.length,
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spaceM,
                horizontal: AppDimensions.spaceS,
              ),
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                final isSelected = navProvider.currentTab == item.tab;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceXS),
                  child: ListTile(
                    selected: isSelected,
                    onTap: () {
                      navProvider.setTab(item.tab);
                      if (!isPermanent) {
                        Navigator.pop(context); // Close slide-out drawer on mobile
                      }
                    },
                    leading: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant.withOpacity(0.8),
                    ),
                    title: Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : AppColors.onBackground,
                          ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    selectedTileColor: AppColors.primaryContainer.withOpacity(0.4),
                  ),
                );
              },
            ),
          ),

          // Footer (Logout Button)
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceS,
              vertical: AppDimensions.spaceM,
            ),
            child: ListTile(
              onTap: () async {
                if (!isPermanent) {
                  Navigator.pop(context); // Close slide drawer
                }
                
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Sign Out'),
                    content: const Text('Are you sure you want to sign out from Shri Hitham?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                }
              },
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
              ),
              title: const Text(
                AppStrings.navLogout,
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItemData {
  final DashboardTab tab;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool adminOnly;

  _DrawerItemData({
    required this.tab,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.adminOnly = false,
  });
}
