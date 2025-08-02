import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/details&upgrade/presentation/screens/pass_details_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card_shimmer.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class StoredPasswordsScreen extends ConsumerWidget {
  const StoredPasswordsScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(allPasswordProvider);
    
    return CommonBgScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          CustomText(
            text: "ALL STORED PASSWORDS",
            fontFamily: FontFamily.bebasNeue,
            fontSize: 55,
            color: ThemePreferance.instance.isDarkMode? Colors.white: AppColors.secondaryColor,
          ),
          VerticalSpace(height: 20),
          // Summary Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemePreferance.instance.isDarkMode
                  ? Colors.white.withValues(alpha: 0.1)
                  : Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Password Summary",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemePreferance.instance.isDarkMode
                      ? Colors.white
                      : AppColors.secondaryColor,
                ),
                VerticalSpace(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: homeState.passwords.length.toString(),
                          fontSize: 28,
                          fontFamily: FontFamily.bebasNeue,
                          color: AppColors.primaryColor,
                        ),
                        CustomText(
                          text: "Total Stored",
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: (homeState.passwords.length - homeState.compromisedPasswordCount).toString(),
                          fontSize: 28,
                          fontFamily: FontFamily.bebasNeue,
                          color: Colors.green,
                        ),
                        CustomText(
                          text: "Secure",
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: homeState.compromisedPasswordCount.toString(),
                          fontSize: 28,
                          fontFamily: FontFamily.bebasNeue,
                          color: Colors.red,
                        ),
                        CustomText(
                          text: "Compromised",
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          VerticalSpace(height: 20),
          // Password List
          Expanded(
            child: homeState.isLoading
                ? ListView.separated(
                    itemBuilder: (context, index) => PasswordCardShimmer(),
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemCount: 4,
                  )
                : homeState.error != null
                    ? Center(
                        child: CustomText(
                          text: homeState.error!,
                          color: Colors.red,
                        ),
                      )
                    : homeState.passwords.isEmpty
                        ? Center(
                            child: CustomText(
                              text: "No passwords stored yet",
                              color: AppColors.textSecondary,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              final password = homeState.passwords[index];
                              return PasswordCard(
                                title: password.name,
                                password: password.password,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PassDetailsScreen(
                                      passwordData: password,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(height: 20),
                            itemCount: homeState.passwords.length,
                          ),
          ),
        ],
      ),
    );
  }
}
