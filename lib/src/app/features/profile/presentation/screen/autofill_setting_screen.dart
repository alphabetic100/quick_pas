import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class AutofillSettingScreen extends StatelessWidget {
  const AutofillSettingScreen({super.key});
  static const String routeName = "/profile/autofill";
  @override
  Widget build(BuildContext context) {
    return CommonBgScreen(
      child: Center(
        child: CustomText(
          text: "COMMING SOON",
          fontFamily: FontFamily.bebasNeue,
          fontSize: 52,
          color:
              ThemePreferance.instance.isDarkMode
                  ? Colors.white
                  : AppColors.secondaryColor,
        ),
      ),
    );
  }
}
