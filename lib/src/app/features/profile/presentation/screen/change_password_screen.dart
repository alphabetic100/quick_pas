import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/validators/text_field_validator.dart';
import 'package:quick_pass/src/app/features/profile/controller/change_pass_controller.dart';

class ChangePasswordScreen extends ConsumerWidget {
  ChangePasswordScreen({super.key});
  static const String routeName = "/profile/change-master-pass";
  final GlobalKey<FormState> _formState = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(changePassController);
    return CommonBgScreen(
      child: SingleChildScrollView(
        child: Form(
          key: _formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "CHANGE \nPASSWORD",
                fontFamily: FontFamily.bebasNeue,
                color: AppColors.secondaryColor,
                fontSize: 55,
              ),
              SizedBox(height: 30),
              CustomText(
                text: "Current Password",
                fontFamily: FontFamily.bebasNeue,
                color: AppColors.secondaryColor,
              ),
              CustomTextFormField(
                controller: controllers.currentPassword,
                hintText: "*******",
              ),
              SizedBox(height: 16),
              CustomText(
                text: "New Password",
                fontFamily: FontFamily.bebasNeue,
                color: AppColors.secondaryColor,
              ),
              CustomTextFormField(
                controller: controllers.newPassword,
                hintText: "*******",
                validator: TextFieldValidator.validatePassword,
              ),
              SizedBox(height: 16),
              CustomText(
                text: "Confirm Password",
                fontFamily: FontFamily.bebasNeue,
                color: AppColors.secondaryColor,
              ),
              CustomTextFormField(
                controller: controllers.confirmPassword,
                hintText: "*******",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your confirm password";
                  } else if (!controllers.validateConfirmPassword()) {
                    return "Confirm password didn't match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              CustomButton(
                onTap: () {
                  if (_formState.currentState!.validate()) {
                    ref
                        .read(changePassController)
                        .changePassword(context: context);
                  }
                },
                title: "CHANGE PASSWORD",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
