import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class ModulePlaceholderView extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<String> futureSubModules;
  final bool isRestricted;

  const ModulePlaceholderView({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.futureSubModules,
    this.isRestricted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration/Icon
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                decoration: BoxDecoration(
                  color: isRestricted 
                      ? AppColors.errorContainer.withOpacity(0.4)
                      : AppColors.primaryContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64.0,
                  color: isRestricted ? AppColors.error : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceL),

              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: isRestricted ? AppColors.error : AppColors.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceS),

              // Description
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.0,
                        color: AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXL),

              // Future Roadmap / Scaling Structure
              if (futureSubModules.isNotEmpty) ...[
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spaceM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isRestricted ? Icons.lock_outline_rounded : Icons.rocket_launch_outlined,
                                size: 18.0,
                                color: isRestricted ? AppColors.error : AppColors.primary,
                              ),
                              const SizedBox(width: AppDimensions.spaceS),
                              Text(
                                isRestricted ? 'Access Status' : 'Scalable Architecture Roadmap',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isRestricted ? AppColors.error : AppColors.primary,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spaceM),
                          const Divider(),
                          const SizedBox(height: AppDimensions.spaceS),
                          ...futureSubModules.map(
                            (module) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXS),
                              child: Row(
                                children: [
                                  Icon(
                                    isRestricted ? Icons.close_rounded : Icons.check_circle_outline_rounded,
                                    size: 16.0,
                                    color: isRestricted ? AppColors.error.withOpacity(0.6) : AppColors.primary.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: AppDimensions.spaceM),
                                  Expanded(
                                    child: Text(
                                      module,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: AppColors.onSurface.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
