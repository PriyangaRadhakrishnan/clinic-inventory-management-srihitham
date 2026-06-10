import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ShriHithamLogo extends StatelessWidget {
  final double size;
  final bool isLight;

  const ShriHithamLogo({
    super.key,
    this.size = 80.0,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    // Medical shield + cross/health icon matching the olive green theme
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: (isLight ? Colors.black : AppColors.primary).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: isLight ? Border.all(color: AppColors.border, width: 1) : null,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.healing_rounded, // Olive leaf/healing cross vibe
              size: size * 0.55,
              color: isLight ? AppColors.primary : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
