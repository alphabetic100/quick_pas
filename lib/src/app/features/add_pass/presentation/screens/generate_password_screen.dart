import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/add_pass/providers/generate_pass_provider.dart';

class GeneratePasswordScreen extends ConsumerWidget {
  const GeneratePasswordScreen({super.key});
  static const String routeName = "/generate-password";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generator = ref.watch(generateProvider);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "GENERATE NEW",
                fontSize: 55,
                fontFamily: FontFamily.bebasNeue,
                color: AppColors.secondaryColor,
              ),

              VerticalSpace(height: 40),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                ),
                child: Center(
                  child: CustomText(
                    text:
                        generator.generatedPassword.isNotEmpty
                            ? generator.generatedPassword
                            : "generated_pass",
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),

              SizedBox(height: 20),
              CustomText(
                text: "PASSWORD LENGTH",
                color: AppColors.secondaryColor,
                fontFamily: FontFamily.bebasNeue,
              ),
              CustomTextFormField(
                controller: TextEditingController(),
                hintText: "Chose your length",
                readonly: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.secondaryColor
                              : Colors.white,
                      value: generator.passwordLength.toString(),
                      icon: Icon(Icons.keyboard_arrow_down),
                      items:
                          [4, 6, 8, 10, 12, 14, 16, 20]
                              .map(
                                (value) => DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: CustomText(
                                    text: value.toString(),
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(generateProvider.notifier)
                              .updatePasswordLength(
                                passLength: int.parse(value),
                              );
                        }
                      },
                    ),
                  ),
                ),
              ),
              VerticalSpace(height: 16),

              CustomText(
                text: "INCLUDE SYMBOLS",
                color: AppColors.secondaryColor,
                fontFamily: FontFamily.bebasNeue,
              ),
              CustomTextFormField(
                controller: TextEditingController(),
                hintText: "YES / NO",
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.secondaryColor
                              : Colors.white,
                      value: generator.isSymble ? "Yes" : "No",
                      icon: Icon(Icons.keyboard_arrow_down),
                      items:
                          ["Yes", "No"]
                              .map(
                                (value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: CustomText(
                                    text: value,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(generateProvider.notifier)
                              .updateIsSymble(isSymble: value == "Yes");
                        }
                      },
                    ),
                  ),
                ),
              ),
              VerticalSpace(height: 40),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        ref.read(generateProvider.notifier).genaratePassword();
                      },
                      title: "RANDOMIZE",
                      isPrimary: false,
                      titleColor: AppColors.primaryColor,
                    ),
                  ),

                  HorizontalSpace(width: 16),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: generator.generatedPassword),
                        );
                      },
                      title: "COPY",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
