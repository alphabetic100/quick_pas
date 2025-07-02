import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/add_pass/presentation/screens/ad_pass_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/screens/home_screen_body.dart';
import 'package:quick_pass/src/app/features/home/providers/nav_bar_provider.dart';
import 'package:quick_pass/src/app/features/profile/presentation/screen/profile_screen.dart';
import 'package:quick_pass/src/app/features/profile/providers/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const String routeName = "/home";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(NavBarProvider.currentPage);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      body: currentPage == 0 ? HomeScreenBody() : ProfileScreen(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        elevation: 10,
        splashColor: AppColors.primaryColor.withValues(alpha: 0.3),
        shape: const CircleBorder(),
        onPressed: () {
          context.push(AddPassScreen.routeName);
        },
        child: const Icon(Icons.add, size: 32),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color:
            isDarkMode.isDarkmode
                ? Color(0xFFFFFFFF).withValues(alpha: 0.2)
                : const Color(0xFFF1F1F1),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BottomItem(
                  isDarkMode: isDarkMode,
                  iconPath: IconPath.homeIcon,
                  selected: currentPage == 0,
                  onTap: () => NavBarProvider.changeIndex(ref: ref, index: 0),
                ),
                _BottomItem(
                  isDarkMode: isDarkMode,
                  iconPath: IconPath.userIcon,
                  selected: currentPage == 1,
                  onTap: () => NavBarProvider.changeIndex(ref: ref, index: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final String iconPath;
  final bool selected;
  final VoidCallback onTap;
  final ThemeState isDarkMode;

  const _BottomItem({
    required this.iconPath,
    required this.selected,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 30,
            color:
                selected
                    ? isDarkMode.isDarkmode
                        ? Colors.white
                        : AppColors.secondaryColor
                    : isDarkMode.isDarkmode
                    ? AppColors.textSecondary
                    : null,
          ),
          if (selected) ...[
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 30,
              decoration: BoxDecoration(
                color:
                    isDarkMode.isDarkmode
                        ? Colors.white
                        : AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ] else
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 30,
              decoration: BoxDecoration(
                // color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
