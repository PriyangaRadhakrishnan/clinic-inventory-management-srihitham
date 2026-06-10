class AppStrings {
  // App General
  static const String appName = 'Shri Hitham';
  static const String appSlogan = 'Clinic & Inventory Management System';
  static const String logoPlaceholderText = 'SH';

  // Authentication
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Please sign in to access your clinic dashboard';
  static const String emailLabel = 'Email Address';
  static const String passwordLabel = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String loginButton = 'Sign In';
  static const String loggingIn = 'Signing in...';
  static const String logoutButton = 'Sign Out';
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String mockLoginToggle = 'Enable Mock Authentication (For testing without Firestore/Firebase Setup)';
  static const String selectMockRole = 'Select Mock Role to Log In:';

  // Roles
  static const String roleAdmin = 'Admin';
  static const String roleStaff = 'Staff';
  static const String roleUnknown = 'Unassigned';

  // Navigation Drawer Items
  static const String navDashboard = 'Dashboard';
  static const String navPatients = 'Patients';
  static const String navInventory = 'Inventory';
  static const String navBilling = 'Billing';
  static const String navPurchases = 'Purchases';
  static const String navReports = 'Reports';
  static const String navUserManagement = 'User Management';
  static const String navSettings = 'Settings';
  static const String navMyProfile = 'My Profile';
  static const String navLogout = 'Logout';

  // Placeholders & Dashboards
  static const String dashboardTitle = 'Dashboard Overview';
  static const String welcomeBackUser = 'Welcome back, ';
  static const String mockTag = 'MOCK MODE';
  static const String roleAccessRestricted = 'Access Restricted';
  static const String roleAccessRestrictedDesc = 'This module is only accessible to Admin users.';
}
