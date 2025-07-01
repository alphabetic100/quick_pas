import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class PasswordStoredCard extends StatelessWidget {
  const PasswordStoredCard({
    super.key,
    required this.value,
    required this.title,
  });
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color:
            ThemePreferance.instance.isDarkMode
                ? Colors.white.withValues(alpha: 0.2)
                : Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: value,
            fontSize: MediaQuery.of(context).size.width * 0.15,
            fontFamily: FontFamily.bebasNeue,
            color: AppColors.primaryColor,
          ),
          CustomText(
            text: title,
            color:
                ThemePreferance.instance.isDarkMode
                    ? Colors.white
                    : AppColors.secondaryColor,
          ),
        ],
      ),
    );
  }
}
