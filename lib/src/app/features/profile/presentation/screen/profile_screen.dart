import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/profile/presentation/components/custom_profile_card.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/autofill_setting_screen.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/change_password_screen.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "PROFILE",
              fontFamily: FontFamily.bebasNeue,
              fontSize: 50,
              color: AppColors.secondaryColor,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: AssetImage(IconPath.userIcon),
                          scale: 2,
                        ),
                      ),
                    ),
                    VerticalSpace(height: 10),
                    CustomText(
                      text: "Jhon doe",
                      fontFamily: FontFamily.bebasNeue,
                      fontSize: 32,
                      color: AppColors.secondaryColor,
                    ),
                    CustomText(text: "example@gmail.com", fontSize: 14),
                  ],
                ),
              ),
            ),
            VerticalSpace(height: 20),
            CustomProfileCard(
              iconaPath: IconPath.userIcon,
              title: "Update Profile",
              onTap: () {
                context.push(UpdateProfileScreen.routeName);
              },
            ),
            CustomProfileCard(
              iconaPath: IconPath.lockIcon,
              title: "Change Master Password",
              onTap: () {
                context.push(ChangePasswordScreen.routeName);
              },
            ),
            CustomProfileCard(
              iconaPath: IconPath.editIcon,
              title: "Autofill Settings",
              onTap: () {
                context.push(AutofillSettingScreen.routeName);
              },
            ),
            CustomProfileCard(
              iconaPath: IconPath.darkIcon,
              title: "Switch to Dark Mode",
              onTap: () {},
            ),
            VerticalSpace(height: 20),
            CustomProfileCard(
              iconaPath: IconPath.logout,
              title: "Logout",
              onTap: () {},
            ),
            Spacer(),
            CustomText(text: "v 1.0.0", fontSize: 12),
          ],
        ),
      ),
    );
  }
}
