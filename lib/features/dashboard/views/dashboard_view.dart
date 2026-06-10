import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../providers/navigation_provider.dart';
import '../widgets/navigation_drawer.dart';
import 'subviews/dashboard_overview.dart';
import 'subviews/patients_view.dart';
import 'subviews/inventory_view.dart';
import 'subviews/billing_view.dart';
import 'subviews/purchases_view.dart';
import 'subviews/reports_view.dart';
import 'subviews/user_management_view.dart';
import 'subviews/settings_view.dart';
import 'subviews/profile_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    // Map selected enum tab to its corresponding view
    Widget getActiveView(DashboardTab tab) {
      switch (tab) {
        case DashboardTab.dashboard:
          return const DashboardOverview();
        case DashboardTab.patients:
          return const PatientsView();
        case DashboardTab.inventory:
          return const InventoryView();
        case DashboardTab.billing:
          return const BillingView();
        case DashboardTab.purchases:
          return const PurchasesView();
        case DashboardTab.reports:
          return const ReportsView();
        case DashboardTab.userManagement:
          return const UserManagementView();
        case DashboardTab.settings:
          return const SettingsView();
        case DashboardTab.profile:
          return const ProfileView();
      }
    }

    return ResponsiveLayout(
      // Mobile Layout
      mobile: Scaffold(
        appBar: AppBar(
          title: Text(navProvider.tabTitle),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(height: 1.0),
          ),
        ),
        drawer: const Drawer(
          child: LeftNavigationDrawer(isPermanent: false),
        ),
        body: SafeArea(
          child: getActiveView(navProvider.currentTab),
        ),
      ),
      
      // Laptop / Desktop & Tablet Layout
      laptop: Scaffold(
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Permanent Navigation Drawer
              const LeftNavigationDrawer(isPermanent: true),
              
              // Main Dashboard Area
              Expanded(
                child: Column(
                  children: [
                    // Top Bar for Desktop
                    Container(
                      height: 64.0,
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: AppColors.border, width: AppDimensions.borderThickness),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            navProvider.tabTitle,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                          // Subtle status indicator (representing sync success)
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: const BoxDecoration(
                                  color: AppColors.staffBadge, // Green dot
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spaceS),
                              Text(
                                'Connected to Cloud DB',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: AppColors.onSurfaceVariant.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Selected Panel content
                    Expanded(
                      child: Container(
                        color: AppColors.background,
                        child: getActiveView(navProvider.currentTab),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
