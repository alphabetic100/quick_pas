import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/app_texts/app_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';

class BuildOnbording extends StatelessWidget {
  const BuildOnbording({super.key, required this.currentPage});
  final int currentPage;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Image.asset(IconPath.passIcon, height: 40),
            Spacer(),
            currentPage == 1
                ? ritchTextbuilder(
                  firstText: "Generate",
                  colorText: "\nSecure",
                  lastText: "\nPasswords.",
                )
                : currentPage == 2
                ? ritchTextbuilder(
                  firstText: "ALL YOUR ",
                  colorText: "\nPASSWORDS",
                  lastText: " ARE \nHERE.",
                )
                : ritchTextbuilder(
                  firstText: "DON’T TYPE, ",
                  colorText: "\nAUTOFILL",
                  lastText: " YOUR \nCREDENTIALS.",
                ),

            SizedBox(height: 20),
            currentPage == 1
                ? CustomText(text: AppText.onboarding1, fontSize: 12)
                : currentPage == 2
                ? CustomText(text: AppText.onboarding2, fontSize: 12)
                : CustomText(text: AppText.onboarding3, fontSize: 12),
            Spacer(),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "1",
                    style: TextStyle(
                      color:
                          currentPage == 1
                              ? AppColors.primaryColor
                              : AppColors.textSecondary,
                      fontSize: currentPage == 1 ? 32 : 20,
                    ),
                  ),
                  TextSpan(
                    text: "  2",
                    style: TextStyle(
                      color:
                          currentPage == 2
                              ? AppColors.primaryColor
                              : AppColors.textSecondary,
                      fontSize: currentPage == 2 ? 32 : 20,
                    ),
                  ),
                  TextSpan(
                    text: "  3",
                    style: TextStyle(
                      color:
                          currentPage == 3
                              ? AppColors.primaryColor
                              : AppColors.textSecondary,
                      fontSize: currentPage == 3 ? 32 : 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }

  Widget ritchTextbuilder({
    required String firstText,
    required String colorText,
    required String lastText,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 55),
          ),
          TextSpan(
            text: colorText,
            style: TextStyle(color: AppColors.primaryColor, fontSize: 55),
          ),
          TextSpan(
            text: lastText,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 55),
          ),
        ],
      ),
    );
  }
}
