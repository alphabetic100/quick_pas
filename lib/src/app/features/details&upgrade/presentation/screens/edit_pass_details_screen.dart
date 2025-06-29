import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/validators/text_field_validator.dart';
import 'package:quick_pass/src/app/features/add_pass/presentation/screens/generate_password_screen.dart';
import 'package:quick_pass/src/app/features/details&upgrade/controller/update_pass_controller.dart';

class EditPassDetailsScreen extends ConsumerWidget {
  EditPassDetailsScreen({super.key});
  static const String routeName = "/details/edit";
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(updateControllers);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "ADD NEW",
                    fontFamily: FontFamily.bebasNeue,
                    fontSize: 55,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 40),
                  CustomText(
                    text: "Name",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.nameTEController,
                    hintText: "Website/App Name",
                    validator:
                        (value) => TextFieldValidator.validateField(
                          value: value,
                          fieldName: "name",
                        ),
                  ),
                  SizedBox(height: 16),

                  CustomText(
                    text: "url",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.urlTEController,
                    hintText: "Website/App Link",
                  ),
                  SizedBox(height: 16),

                  CustomText(
                    text: "EMAIL / USERNAME",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.emailTEController,
                    hintText: "Email / Username",
                  ),
                  SizedBox(height: 16),
                  CustomText(
                    text: "PASSWORD",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.passwordTEController,
                    hintText: "Password",
                    validator:
                        (value) => TextFieldValidator.validateField(
                          value: value,
                          fieldName: "password",
                        ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: CustomButton(
                        onTap: () {
                          context.push(GeneratePasswordScreen.routeName);
                        },
                        title: "GENERATE NEW",
                        isPrimary: false,
                        titleColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            onTap: () {
              if (formState.currentState!.validate()) {
                ref.watch(updateControllers).updatePassword(context: context);
              }
            },
            title: "UPDATE PASSWORD",
          ),
        ),
      ),
    );
  }
}
