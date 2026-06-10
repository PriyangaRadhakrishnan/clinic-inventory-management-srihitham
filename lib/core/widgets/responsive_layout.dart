import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget laptop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.laptop,
  });

  // Helper methods to check screen sizes easily anywhere in the app
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppDimensions.mobileBreakPoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppDimensions.mobileBreakPoint && width < AppDimensions.tabletBreakPoint;
  }

  static bool isLaptop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppDimensions.tabletBreakPoint;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppDimensions.tabletBreakPoint) {
          return laptop;
        }
        if (constraints.maxWidth >= AppDimensions.mobileBreakPoint) {
          return tablet ?? laptop; // Fallback to laptop if tablet isn't specified
        }
        return mobile;
      },
    );
  }
}
