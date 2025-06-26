import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/validators/text_field_validator.dart';
import 'package:quick_pass/src/app/features/add_pass/controller/add_password_controller.dart';
import 'package:quick_pass/src/app/features/add_pass/presentation/screens/generate_password_screen.dart';

class AddPassScreen extends ConsumerWidget {
  AddPassScreen({super.key});

  static const String routeName = "/add/pass";
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(addPassControlers);
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
              key: formstate,
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
                    controller: controllers.name,
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
                    controller: controllers.url,
                    hintText: "Website/App Link",
                  ),
                  SizedBox(height: 16),

                  CustomText(
                    text: "EMAIL / USERNAME",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.email,
                    hintText: "Email / Username",
                  ),
                  SizedBox(height: 16),
                  CustomText(
                    text: "PASSWORD",
                    fontFamily: FontFamily.bebasNeue,
                    color: AppColors.secondaryColor,
                  ),
                  CustomTextFormField(
                    controller: controllers.password,
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
              if (formstate.currentState!.validate()) {
                ref.watch(addPassControlers).addPaasord(context: context);
              }
            },
            title: "ADD PASSWORD",
          ),
        ),
      ),
    );
  }
}
