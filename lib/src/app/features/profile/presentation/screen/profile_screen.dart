import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/authentication/presentation/screens/login_screen.dart';
import 'package:quick_pass/src/app/features/profile/presentation/components/custom_profile_card.dart';
import 'package:quick_pass/src/app/features/profile/presentation/components/user_profile_shimmer.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/autofill_setting_screen.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/change_password_screen.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/update_profile_screen.dart';
import 'package:quick_pass/src/app/features/profile/providers/get_profile_provider.dart';
import 'package:quick_pass/src/app/features/profile/providers/theme_provider.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const String routeName = "/profile";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(getProfile);
    final isDark = ref.watch(themeProvider);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

            child: CustomText(
              text: "PROFILE",
              fontFamily: FontFamily.bebasNeue,
              fontSize: 50,
              color:
                  isDark.isDarkmode
                      ? Colors.white
                      : AppColors.secondaryColor,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: profileData.when(
              data: (data) {
                if (data != null) {
                  return Center(
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
                              image:
                                  data.profileImage.isNotEmpty
                                      ? NetworkImage(data.profileImage)
                                      : AssetImage(IconPath.userIcon),
                              scale: data.profileImage.isNotEmpty ? 2 : 2,
                              fit:
                                  data.profileImage.isNotEmpty
                                      ? BoxFit.cover
                                      : null,
                              onError:
                                  (exception, stackTrace) =>
                                      AssetImage(IconPath.userIcon),
                            ),
                          ),
                        ),
                        VerticalSpace(height: 10),
                        CustomText(
                          text: data.fullName,
                          fontFamily: FontFamily.bebasNeue,
                          fontSize: 32,
                          color: isDark.isDarkmode? Colors.white: AppColors.secondaryColor,
                        ),
                        CustomText(text: data.email, fontSize: 14),
                      ],
                    ),
                  );
                } else {
                  return CustomText(
                    text:
                        "Something went wrong, please check your internet and try again",
                    textAlign: TextAlign.center,
                  );
                }
              },
              error:
                  (error, stackTrace) => Center(
                    child: CustomText(
                      text:
                          "Something went wrong, please check your internet and try again",
                      textAlign: TextAlign.center,
                    ),
                  ),
              loading: () => UserProfileShimmer(),
            ),
          ),
          VerticalSpace(height: 20),
          CustomProfileCard(
            iconaPath: IconPath.userIcon,
            title: "Update Profile",
            onTap: () {
              context.push(
                UpdateProfileScreen.routeName,
                extra: {
                  "fullName": profileData.value!.fullName,
                  "image": profileData.value!.profileImage,
                },
              );
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
            onTap: () {
              ref.read(themeProvider.notifier).toggleTheme(context: context);
            },
            trailing: SizedBox(
              height: 40,
              child: Transform.scale(
                scaleX: 0.8,
                scaleY: 0.7,
                child: Switch.adaptive(
                  activeColor: AppColors.primaryColor,
                  value: isDark.isDarkmode,
                  onChanged: (onChanged) {
                    ref
                        .read(themeProvider.notifier)
                        .toggleTheme(context: context);
                  },
                ),
              ),
            ),
          ),
          VerticalSpace(height: 20),
          CustomProfileCard(
            iconaPath: IconPath.logout,
            title: "Logout",
            onTap: () {
              SecureStorageService.instance.clearToken();
              context.go(LoginScreen.routeName);
            },
          ),
          Spacer(),
          CustomText(text: "v 1.0.0", fontSize: 12),
        ],
      ),
    );
  }
}
