import 'dart:developer';
import 'dart:io';

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
import 'package:quick_pass/src/app/features/profile/providers/update_profile_provider.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class UpdateProfileScreen extends ConsumerWidget {
  UpdateProfileScreen(this.fullName, this.profileImage, {super.key}) {
    name.text = fullName;
  }
  static const String routeName = "/profile/update";
  final name = TextEditingController();
  final String fullName;
  final String profileImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String profilePath = ref.watch(UpdateProfileProvider.profilePicture);
    log("Profile image is: $profileImage");

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios,
            color: ThemePreferance.instance.isDarkMode ? Colors.white : null,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "edit profile",
                  fontFamily: FontFamily.bebasNeue,
                  fontSize: 55,
                  color:
                      ThemePreferance.instance.isDarkMode
                          ? Colors.white
                          : AppColors.secondaryColor,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image:
                                profilePath.isNotEmpty
                                    ? FileImage(File(profilePath))
                                    : profileImage.isNotEmpty
                                    ? NetworkImage(profileImage)
                                    : AssetImage(IconPath.userIcon),
                            fit:
                                profilePath.isNotEmpty ||
                                        profileImage.isNotEmpty
                                    ? BoxFit.cover
                                    : null,
                          ),
                        ),
                      ),
                      VerticalSpace(height: 10),
                      GestureDetector(
                        onTap: () => UpdateProfileProvider.pickImage(ref: ref),
                        child: CustomText(
                          text: "Change Picture",
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                CustomText(
                  text: "name",
                  fontFamily: FontFamily.bebasNeue,
                  color: AppColors.secondaryColor,
                ),
                CustomTextFormField(controller: name, hintText: "Jhon Doe"),
                VerticalSpace(height: MediaQuery.of(context).size.height * 0.2),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () {
                    context.pop();
                  },
                  title: "Back",
                  isPrimary: false,
                  titleColor: AppColors.primaryColor,
                  color:
                      ThemePreferance.instance.isDarkMode
                          ? Colors.white.withValues(alpha: 0.2)
                          : null,
                ),
              ),
              HorizontalSpace(width: 16),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    UpdateProfileProvider().updateProfile(
                      context: context,
                      ref: ref,
                      name: name.text.trim(),
                      priviousImage: profileImage,
                    );
                  },
                  title: "save",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
