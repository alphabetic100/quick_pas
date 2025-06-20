import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/login_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/screens/home_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  static const String routeName = "/signup";
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formState,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(IconPath.passIcon, height: 40),
                  VerticalSpace(height: 20),
                  CustomText(
                    text: "REGISTER",
                    fontFamily: FontFamily.bebasNeue,

                    fontSize: 55,
                    color: AppColors.secondaryColor,
                  ),
                  CustomText(
                    text: "Let’s get you setup with a new account!",
                    fontSize: 12,
                  ),

                  VerticalSpace(height: 40),
                  CustomText(
                    text: "NAME",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: TextEditingController(),
                    hintText: "john doe",
                  ),

                  VerticalSpace(height: 16),
                  CustomText(
                    text: "EMAIL",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: TextEditingController(),
                    hintText: "example@gmail.com",
                  ),

                  VerticalSpace(height: 16),
                  CustomText(
                    text: "PASSWORD",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: TextEditingController(),
                    hintText: "Password",
                  ),

                  VerticalSpace(height: 26),
                  CustomButton(
                    onTap: () {
                      context.go(HomeScreen.routeName);
                    },
                    title: "REGISTER",
                  ),
                  VerticalSpace(height: 30),
                  Center(
                    child: CustomText(
                      text: "Already have an account?",
                      fontSize: 12,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap:
                          () => context.pushReplacement(LoginScreen.routeName),
                      child: CustomText(
                        text: "login",
                        fontSize: 18,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.bebasNeue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
