import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/login_screen.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/signup_screen.dart';
import 'package:quick_pass/src/app/features/onboardings/presentation/components/build_onbording.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});
  static const String routeName = "/onboarding";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          BuildOnbording(currentPage: 1),
          BuildOnbording(currentPage: 2),
          BuildOnbording(currentPage: 3),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () {
                    context.push(SignupScreen.routeName);
                  },
                  title: "REGISTER",
                  isPrimary: false,
                  titleColor: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    context.push(LoginScreen.routeName);
                  },
                  title: "LOGIN",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
