import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/login_screen.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          ThemePreferance.instance.isDarkMode
              ? AppColors.scaffoldBgDark
              : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Logout!",
              fontFamily: FontFamily.bebasNeue,
              fontSize: 30,
            ),

            SizedBox(height: 10),

            CustomText(
              text: "Are you sure! \nyou want to logout?",
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      context.pop();
                    },
                    title: "Cancel",
                    color:
                        ThemePreferance.instance.isDarkMode
                            ? AppColors.secondaryColor
                            : null,
                  ),
                ),
                SizedBox(width: 12),

                Expanded(
                  child: CustomButton(
                    onTap: () {
                      SecureStorageService.instance.clearToken();
                      context.go(LoginScreen.routeName);
                    },
                    title: "Logout",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
