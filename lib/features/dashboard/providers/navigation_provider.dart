import 'package:flutter/material.dart';

enum DashboardTab {
  dashboard,
  patients,
  inventory,
  billing,
  purchases,
  reports,
  userManagement,
  settings,
  profile,
}

class NavigationProvider extends ChangeNotifier {
  DashboardTab _currentTab = DashboardTab.dashboard;

  DashboardTab get currentTab => _currentTab;

  void setTab(DashboardTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  // Helper to get matching title string
  String get tabTitle {
    switch (_currentTab) {
      case DashboardTab.dashboard:
        return 'Dashboard Overview';
      case DashboardTab.patients:
        return 'Patients Registry';
      case DashboardTab.inventory:
        return 'Medicine Inventory';
      case DashboardTab.billing:
        return 'Billing & Invoicing';
      case DashboardTab.purchases:
        return 'Purchase Orders';
      case DashboardTab.reports:
        return 'Analytical Reports';
      case DashboardTab.userManagement:
        return 'User Management';
      case DashboardTab.settings:
        return 'System Settings';
      case DashboardTab.profile:
        return 'My Profile';
    }
  }
}
