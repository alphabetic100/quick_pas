import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';

class CustomProfileCard extends StatelessWidget {
  const CustomProfileCard({
    super.key,
    required this.iconaPath,
    required this.title,
    required this.onTap,
  });
  final String iconaPath;
  final String title;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Image.asset(iconaPath, height: 30, color: AppColors.primaryColor),
            HorizontalSpace(width: 10),
            CustomText(text: title, color: AppColors.secondaryColor),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
