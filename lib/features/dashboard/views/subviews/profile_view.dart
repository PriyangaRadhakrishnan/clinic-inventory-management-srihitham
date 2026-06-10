import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final name = user?.name ?? 'Unknown User';
    final email = user?.email ?? 'No email associated';
    final isAdmin = user?.isAdmin == true;

    final badgeColor = isAdmin ? AppColors.adminBadge : AppColors.staffBadge;
    final badgeBgColor = isAdmin ? AppColors.adminBadgeBg : AppColors.staffBadgeBg;
    final roleDisplay = isAdmin ? AppStrings.roleAdmin : (user?.isStaff == true ? AppStrings.roleStaff : AppStrings.roleUnknown);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Profile Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceXL),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      
                      // Name
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      
                      // Email
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: AppDimensions.spaceM),

                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                        ),
                        child: Text(
                          roleDisplay.toUpperCase(),
                          style: TextStyle(
                            color: badgeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),

              // Detail Info Items
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceM),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        context,
                        icon: Icons.badge_outlined,
                        label: 'User ID',
                        value: user?.uid ?? 'N/A',
                      ),
                      const Divider(),
                      _buildInfoTile(
                        context,
                        icon: Icons.shield_outlined,
                        label: 'Permissions Tier',
                        value: isAdmin ? 'Full Admin Access' : 'Clinical Operations Access',
                      ),
                      const Divider(),
                      _buildInfoTile(
                        context,
                        icon: Icons.login_outlined,
                        label: 'Authentication Mode',
                        value: authProvider.useMock ? 'Mock Simulation Mode' : 'Firebase Authentication',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
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
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out of Account'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22.0),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: AppColors.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
