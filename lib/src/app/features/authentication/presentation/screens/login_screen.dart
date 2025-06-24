import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/core/utils/validators/text_field_validator.dart';
import 'package:quick_pass/src/app/features/authentication/controller/login_controller.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/forget_password_screen.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/signup_screen.dart';
import 'package:quick_pass/src/app/features/authentication/providers/login_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  static const String routeName = "/login";
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(loginControllerProvider);
    final state = ref.watch(loginProvider);
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
                    text: "LOGIN",
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
                    text: "EMAIL",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.email,
                    hintText: "example@gmail.com",
                    validator: TextFieldValidator.validateEmail,
                  ),

                  VerticalSpace(height: 16),
                  CustomText(
                    text: "PASSWORD",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.password,
                    hintText: "Password",
                    validator: TextFieldValidator.validatePassword,
                    obscureText: state.passVisibility,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        ref.read(loginProvider.notifier).toggleVisibility();
                      },
                      child: Icon(
                        state.passVisibility
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  VerticalSpace(height: 16),
                  GestureDetector(
                    onTap: () => context.push(ForgetPasswordScreen.routeName),
                    child: CustomText(
                      text: "Forgot Password",
                      color: AppColors.primaryColor,
                    ),
                  ),

                  VerticalSpace(height: 26),
                  CustomButton(
                    onTap: () {
                      if (formState.currentState!.validate()) {
                        ref
                            .read(loginProvider.notifier)
                            .login(
                              context: context,
                              email: controllers.email.text.trim(),
                              password: controllers.password.text.trim(),
                            );
                      }
                    },
                    title: "LOGIN",
                  ),
                  VerticalSpace(height: 30),
                  Center(
                    child: CustomText(
                      text: "Don’t have an account yet?",
                      fontSize: 12,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap:
                          () => context.pushReplacement(SignupScreen.routeName),
                      child: CustomText(
                        text: "REGISTER",
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
