import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/profile/providers/theme_provider.dart';

class CustomProfileCard extends ConsumerWidget {
  const CustomProfileCard({
    super.key,
    required this.iconaPath,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  final String iconaPath;
  final String title;
  final Function() onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Image.asset(
        iconaPath,
        height: 30,
        color: AppColors.primaryColor,
      ),
      title: CustomText(
        text: title,
        color: isDark.isDarkmode ? Colors.white : AppColors.secondaryColor,
      ),
      trailing: trailing,
    );
  }
}
