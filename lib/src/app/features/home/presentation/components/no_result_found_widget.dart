import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/image_path.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class NoResultFoundWidget extends StatelessWidget {
  const NoResultFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ThemePreferance.instance.isDarkMode
              ? ImagePath.darkEmptySearch
              : ImagePath.emptySearch,
        ),
        SizedBox(height: 30),
        CustomText(
          text: "NO Results",
          fontFamily: FontFamily.bebasNeue,
          fontSize: 24,
        ),
        CustomText(
          text: "We couldn’t find anything. Try searching for something else.",
          fontSize: 14,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.normal,
          color: Color(0xFFBABABA),
        ),
      ],
    );
  }
}
