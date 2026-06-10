import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/route_generator.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/dashboard/providers/navigation_provider.dart';

void main() async {
  // Ensure widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with safety.
  // If the user has not configued Firebase credentials yet,
  // we catch the error to prevent crash on startup and fall back to Mock Mode.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint(' Firebase initialization failed or credentials not found.');
    debugPrint('Error details: $e');
    debugPrint('The application will fall back to Mock Mode for local operations.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Shri Hitham',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
