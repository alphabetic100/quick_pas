import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  static const String routeName = "/forgot-pass";
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(IconPath.passIcon, height: 40),
                  VerticalSpace(height: 20),
                  CustomText(
                    text: "FORGOT \nPASSWORD",
                    fontFamily: FontFamily.bebasNeue,

                    fontSize: 55,
                    color: AppColors.secondaryColor,
                  ),
                  VerticalSpace(height: 40),
                  CustomText(
                    text: "EMAIL",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: TextEditingController(),
                    hintText: "example@gmail.com",
                  ),

                  VerticalSpace(height: 40),
                  CustomButton(onTap: () {}, title: "SUBMIT"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
