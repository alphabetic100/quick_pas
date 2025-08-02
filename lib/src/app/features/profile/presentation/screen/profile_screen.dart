import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/profile/presentation/components/custom_profile_card.dart';
import 'package:quick_pass/src/app/features/profile/presentation/components/logout_dialog.dart';
import 'package:quick_pass/src/app/features/profile/presentation/components/user_profile_shimmer.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/autofill_setting_screen.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/change_password_screen.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/update_profile_screen.dart';
import 'package:quick_pass/src/app/features/profile/providers/offline_profile_provider.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/features/profile/providers/theme_provider.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const String routeName = "/profile";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(offlineProfileProvider);
    final isDark = ref.watch(themeProvider);
    final isConnected = ref.watch(isConnectedProvider);
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
            child: _buildProfileContent(profileState, isDark, isConnected, context, ref),
          ),
          VerticalSpace(height: 20),
          CustomProfileCard(
            iconaPath: IconPath.userIcon,
            title: "Update Profile",
            onTap: () {
              if (profileState.userData != null) {
                context.push(
                  UpdateProfileScreen.routeName,
                  extra: {
                    "fullName": profileState.userData!.fullName,
                    "image": profileState.userData!.profileImage,
                  },
                );
              }
            },
          ),
          CustomProfileCard(
            iconaPath: IconPath.lockIcon,
            title: "Change Master Password",
            onTap: isConnected ? () {
              context.push(ChangePasswordScreen.routeName);
            } : () {},
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
              showDialog(
                context: context,
                builder: (context) {
                  return LogoutDialog();
                },
              );
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomText(text: "v 1.0.0", fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(ProfileState profileState, ThemeState isDark, bool isConnected, BuildContext context, WidgetRef ref) {
    if (profileState.isLoading) {
      return UserProfileShimmer();
    }

    if (profileState.userData != null) {
      final data = profileState.userData!;
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
                  image: data.profileImage.isNotEmpty
                      ? NetworkImage(data.profileImage)
                      : AssetImage(IconPath.userIcon),
                  scale: data.profileImage.isNotEmpty ? 2 : 2,
                  fit: data.profileImage.isNotEmpty ? BoxFit.cover : null,
                  onError: (exception, stackTrace) => AssetImage(IconPath.userIcon),
                ),
              ),
            ),
            VerticalSpace(height: 10),
            CustomText(
              text: data.fullName,
              fontFamily: FontFamily.bebasNeue,
              fontSize: 32,
              color: isDark.isDarkmode ? Colors.white : AppColors.secondaryColor,
            ),
            CustomText(text: data.email, fontSize: 14),
            if (!isConnected) ...
            [
              VerticalSpace(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Offline Data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: isConnected 
                  ? "Unable to load profile data"
                  : "No offline profile data available",
              textAlign: TextAlign.center,
            ),
            if (isConnected) ...
            [
              VerticalSpace(height: 8),
              ElevatedButton(
                onPressed: () {
                  ref.read(offlineProfileProvider.notifier).refreshProfile();
                },
                child: Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }
  }
}
