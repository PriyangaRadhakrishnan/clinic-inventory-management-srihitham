import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/shri_hitham_logo.dart';
import '../providers/auth_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  void _handleMockLogin(String role) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInAsMockUser(role);
    if (mounted && authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppDimensions.tabletBreakPoint;

    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      message: AppStrings.loggingIn,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: isDesktop ? 6.0 : 0.0,
                    shadowColor: Colors.black.withOpacity(0.05),
                    color: isDesktop ? Colors.white : Colors.transparent,
                    shape: isDesktop
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                            side: const BorderSide(color: AppColors.border, width: 1),
                          )
                        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? AppDimensions.spaceXL : AppDimensions.spaceM),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header branding
                            const Center(
                              child: ShriHithamLogo(size: AppDimensions.logoSizeMedium),
                            ),
                            const SizedBox(height: AppDimensions.spaceL),
                            Text(
                              AppStrings.loginTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 24.0,
                                    color: AppColors.primary,
                                  ),
                            ),
                            const SizedBox(height: AppDimensions.spaceXS),
                            Text(
                              AppStrings.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppDimensions.spaceXL),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: AppStrings.emailLabel,
                                prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.emailRequired;
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return AppStrings.invalidEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppDimensions.spaceM),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: AppStrings.passwordLabel,
                                prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.primary),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.passwordRequired;
                                }
                                if (value.length < 6) {
                                  return AppStrings.passwordTooShort;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppDimensions.spaceS),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Non-blocking presentation placeholder
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password reset link will be sent to your email')),
                                  );
                                },
                                child: const Text(AppStrings.forgotPassword),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceM),

                            // Error Message Display
                            if (authProvider.errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(AppDimensions.spaceM),
                                decoration: BoxDecoration(
                                  color: AppColors.errorContainer,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                                ),
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(color: AppColors.onErrorContainer, fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.spaceM),
                            ],

                            // Submit Button
                            FilledButton(
                              onPressed: authProvider.isLoading ? null : _handleLogin,
                              child: const Text(AppStrings.loginButton),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spaceXL),

                  // Mock Authentication Control Box (Super useful developer feature)
                  Card(
                    color: AppColors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      side: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spaceM),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.developer_mode, color: AppColors.primary, size: 20),
                              const SizedBox(width: AppDimensions.spaceS),
                              Expanded(
                                child: Text(
                                  'Mock Mode',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              Switch(
                                value: authProvider.useMock,
                                activeColor: AppColors.primary,
                                onChanged: (value) => authProvider.setUseMock(value),
                              ),
                            ],
                          ),
                          if (authProvider.useMock) ...[
                            const SizedBox(height: AppDimensions.spaceS),
                            const Text(
                              'Select a user profile below to simulate instant login. Firebase Auth will be bypassed.',
                              style: TextStyle(fontSize: 12.0, color: AppColors.onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _handleMockLogin('admin'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
                                    ),
                                    child: const Text('Admin Access'),
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spaceS),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _handleMockLogin('staff'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
                                    ),
                                    child: const Text('Staff Access'),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            const SizedBox(height: AppDimensions.spaceXS),
                            const Text(
                              'Currently using Firebase Auth. Toggle above to test without credentials.',
                              style: TextStyle(fontSize: 11.0, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
