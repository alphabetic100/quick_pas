import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/add_pass/presentation/screens/generate_password_screen.dart';

class AddPassScreen extends StatelessWidget {
  const AddPassScreen({super.key});

  static const String routeName = "/add/pass";
  @override
  Widget build(BuildContext context) {
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
                  controller: TextEditingController(),
                  hintText: "Website/App Name",
                ),
                SizedBox(height: 16),

                CustomText(
                  text: "url",
                  fontFamily: FontFamily.bebasNeue,
                  color: AppColors.secondaryColor,
                ),
                CustomTextFormField(
                  controller: TextEditingController(),
                  hintText: "Website/App Link",
                ),
                SizedBox(height: 16),

                CustomText(
                  text: "EMAIL / USERNAME",
                  fontFamily: FontFamily.bebasNeue,
                  color: AppColors.secondaryColor,
                ),
                CustomTextFormField(
                  controller: TextEditingController(),
                  hintText: "Email / Username",
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "PASSWORD",
                  fontFamily: FontFamily.bebasNeue,
                  color: AppColors.secondaryColor,
                ),
                CustomTextFormField(
                  controller: TextEditingController(),
                  hintText: "Password",
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

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(onTap: () {}, title: "ADD PASSWORD"),
        ),
      ),
    );
  }
}
