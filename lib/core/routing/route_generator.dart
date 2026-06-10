import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/splash_view.dart';
import '../../features/dashboard/views/dashboard_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.login:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginView(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          settings: settings,
        );
      case AppRoutes.dashboard:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DashboardView(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}
