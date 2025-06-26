import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';

class PasswordCardShimmer extends StatelessWidget {
  const PasswordCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.textSecondary.withValues(alpha: 0.2),
      highlightColor: AppColors.textSecondary.withValues(alpha: 0.4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textSecondary),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            // Icon/Image Placeholder
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.secondaryColor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const HorizontalSpace(width: 16),

            // Title Placeholder
            Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const Spacer(),

            // Copy Icon Placeholder
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
