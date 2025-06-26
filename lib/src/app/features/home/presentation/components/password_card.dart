import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';

class PasswordCard extends StatelessWidget {
  const PasswordCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.password,
  });
  final String title;
  final String password;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textSecondary),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.secondaryColor,
              ),
              child:
                  getDefualtIconPath(title: title).isNotEmpty
                      ? Image.asset(
                        getDefualtIconPath(title: title),
                        color: Colors.white,
                      )
                      : Center(
                        child: CustomText(
                          text: title[0].toUpperCase(),
                          color: Colors.white,
                          fontFamily: FontFamily.bebasNeue,
                          fontSize: 30,
                        ),
                      ),
            ),
            HorizontalSpace(width: 16),
            CustomText(text: title, color: AppColors.secondaryColor),
            Spacer(),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: password));
              },
              child: Icon(Icons.copy, color: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

String getDefualtIconPath({required String title}) {
  if (title.toLowerCase().contains("facebook")) {
    return IconPath.facebookIcon;
  }

  if (title.toLowerCase().contains("google")) {
    return IconPath.googleIcon;
  }
  if (title.toLowerCase().contains("netflix")) {
    return IconPath.netflixIcon;
  }

  if (title.toLowerCase().contains("amazon")) {
    return IconPath.amazonIcon;
  }

  if (title.toLowerCase().contains("apple")) {
    return IconPath.appleIcon;
  } else {
    return "";
  }
}
