import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/helpers/app_helper.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/details&upgrade/controller/update_pass_controller.dart';
import 'package:quick_pass/src/app/features/details&upgrade/presentation/screens/edit_pass_details_screen.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class PassDetailsScreen extends ConsumerWidget {
  const PassDetailsScreen({super.key, required this.passwordData});
  static const String routeName = "/home/details";
  final PasswordModel passwordData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = ref.watch(obsecurePrivider);
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

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpace(height: 30),
              CustomText(
                text: "Not Compromised",
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
              VerticalSpace(height: 10),
              CustomText(
                text: passwordData.name,
                fontFamily: FontFamily.bebasNeue,
                fontSize: 40,
                color:
                    ThemePreferance.instance.isDarkMode
                        ? Colors.white
                        : AppColors.secondaryColor,
              ),
              VerticalSpace(height: 30),
              _builtDetailCard(
                icon: Icons.calendar_month,
                value: AppHelper.formatDate(passwordData.createdAt),
              ),
              VerticalSpace(height: 25),
              _builtDetailCard(
                icon: Icons.link,
                value:
                    passwordData.url.isNotEmpty
                        ? passwordData.url
                        : "Not Added",
              ),
              VerticalSpace(height: 25),
              _builtDetailCard(
                icon: Icons.person_outline_rounded,
                value:
                    passwordData.email.isNotEmpty
                        ? passwordData.email
                        : "Not Added",
              ),

              VerticalSpace(height: 25),
              _builtDetailCard(
                ref: ref,
                isPassField: true,
                visibility: visibility,
                icon: Icons.lock_outline,
                value:
                    passwordData.password.isNotEmpty
                        ? passwordData.password
                        : "Not Added",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () {
                    ref
                        .watch(updateControllers)
                        .deletePass(context: context, password: passwordData);
                  },
                  title: "Delete",
                  isPrimary: false,
                  titleColor: AppColors.primaryColor,
                  color:
                      ThemePreferance.instance.isDarkMode
                          ? Colors.white.withValues(alpha: 0.2)
                          : null,
                ),
              ),

              HorizontalSpace(width: 18),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    context.push(EditPassDetailsScreen.routeName);
                    ref
                        .watch(updateControllers)
                        .assignValue(password: passwordData);
                  },
                  title: "Update",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builtDetailCard({
    required IconData icon,
    required String value,
    bool isPassField = false,
    bool visibility = false,
    WidgetRef? ref,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color:
              ThemePreferance.instance.isDarkMode
                  ? Colors.white
                  : AppColors.textSecondary,
        ),
        SizedBox(height: isPassField ? 4 : 10),
        Row(
          children: [
            CustomText(
              text:
                  (isPassField)
                      ? visibility
                          ? value
                          : List.generate(value.length, (_) => "* ").join()
                      : value,
              color:
                  ThemePreferance.instance.isDarkMode
                      ? Colors.white
                      : AppColors.textSecondary,
              fontWeight: FontWeight.normal,
            ),

            Spacer(),
            if (isPassField) ...[
              IconButton(
                onPressed: () {
                  ref?.read(obsecurePrivider.notifier).state = !visibility;
                },
                icon: Icon(
                  visibility
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: passwordData.password));
                },
                icon: Icon(Icons.copy, color: AppColors.primaryColor),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

final obsecurePrivider = StateProvider<bool>((ref) => false);
