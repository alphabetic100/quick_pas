import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/password_analyzer.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/details&upgrade/presentation/screens/pass_details_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card_shimmer.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class CompromisedPasswordsScreen extends ConsumerWidget {
  const CompromisedPasswordsScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(allPasswordProvider);
    final compromisedPasswords = homeState.passwords
        .where((password) => PasswordAnalyzer.isPasswordCompromised(password.password))
        .toList();
    
    return CommonBgScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          CustomText(
            text: "COMPROMISED PASSWORDS",
            fontFamily: FontFamily.bebasNeue,
            fontSize: 55,
            color:ThemePreferance.instance.isDarkMode? Colors.white: AppColors.secondaryColor,
          ),
          VerticalSpace(height: 20),
          // Info Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
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
                  text: "What makes a password compromised?",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ThemePreferance.instance.isDarkMode
                      ? Colors.white
                      : AppColors.secondaryColor,
                ),
                VerticalSpace(height: 8),
                _buildInfoItem("🔒 Too short (less than 8 characters)"),
                _buildInfoItem("📝 Common passwords (123456, password, etc.)"),
                _buildInfoItem("⚡ Weak complexity (missing uppercase, numbers, or symbols)"),
              ],
            ),
          ),
          VerticalSpace(height: 20),
          // Compromised Password List
          Expanded(
            child: homeState.isLoading
                ? ListView.separated(
                    itemBuilder: (context, index) => PasswordCardShimmer(),
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemCount: 3,
                  )
                : homeState.error != null
                    ? Center(
                        child: CustomText(
                          text: homeState.error!,
                          color: Colors.red,
                        ),
                      )
                    : compromisedPasswords.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shield,
                                  size: 80,
                                  color: Colors.green,
                                ),
                                VerticalSpace(height: 20),
                                CustomText(
                                  text: "Great! No compromised passwords",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                                VerticalSpace(height: 8),
                                CustomText(
                                  text: "Your passwords meet all security standards",
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              final password = compromisedPasswords[index];
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
                            separatorBuilder: (context, index) => SizedBox(height: 15),
                            itemCount: compromisedPasswords.length,
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: CustomText(
        text: text,
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
    );
  }
}
