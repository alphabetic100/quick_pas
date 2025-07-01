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
import 'package:quick_pass/src/app/features/authentication/controller/register_controller.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/login_screen.dart';
import 'package:quick_pass/src/app/features/authentication/providers/register_user_provider.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});
  static const String routeName = "/signup";
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(registerControllerProvider);
    final registerState = ref.watch(registerProvider);
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
                    color:
                        ThemePreferance.instance.isDarkMode
                            ? Colors.white
                            : AppColors.secondaryColor,
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
                    controller: controllers.fullName,
                    hintText: "john doe",
                    validator:
                        (value) => TextFieldValidator.validateField(
                          value: value,
                          fieldName: "User name",
                        ),
                  ),

                  VerticalSpace(height: 16),
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
                    obscureText: registerState.passVisibility,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        ref.read(registerProvider.notifier).toggleVisibility();
                      },
                      child: Icon(
                        registerState.passVisibility
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: TextFieldValidator.validatePassword,
                  ),

                  VerticalSpace(height: 26),
                  CustomButton(
                    onTap: () {
                      if (formState.currentState!.validate()) {
                        ref
                            .read(registerProvider.notifier)
                            .registerUser(
                              context: context,
                              fullName: controllers.fullName.text.trim(),
                              email: controllers.email.text.trim(),
                              password: controllers.password.text.trim(),
                            );
                      }
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
