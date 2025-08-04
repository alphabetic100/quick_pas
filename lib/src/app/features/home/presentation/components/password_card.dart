import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class PasswordCard extends StatefulWidget {
  const PasswordCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.password,
  });
  final String title;
  final String password;
  final VoidCallback onTap;

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textSecondary),
                borderRadius: BorderRadius.circular(25),
                color: ThemePreferance.instance.isDarkMode? Color(0xFF3f3f3f).withValues(alpha: 0.2):null
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          ThemePreferance.instance.isDarkMode
                              ? Colors.white.withValues(alpha: 0.2)
                              : AppColors.secondaryColor,
                    ),
                    child:
                        getDefualtIconPath(title: widget.title).isNotEmpty
                            ? Image.asset(
                              getDefualtIconPath(title: widget.title),
                              color: Colors.white,
                            )
                            : Center(
                              child: CustomText(
                                text: widget.title[0].toUpperCase(),
                                color: Colors.white,
                                fontFamily: FontFamily.bebasNeue,
                                fontSize: 30,
                              ),
                            ),
                  ),
                  HorizontalSpace(width: 16),
                  CustomText(
                    text: widget.title,
                    color:
                        ThemePreferance.instance.isDarkMode
                            ? Colors.white
                            : AppColors.secondaryColor,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.password));
                      _animationController.forward().then((_) {
                        _animationController.reset();
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.copy,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Animated overlay for the entire card
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(_slideAnimation.value * MediaQuery.of(context).size.width, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            AppColors.primaryColor.withValues(alpha: 0.3),
                            AppColors.primaryColor.withValues(alpha:  0.6),
                            AppColors.primaryColor.withValues(alpha:  0.3),
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.3, 0.5, 0.7, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getDefualtIconPath({required String title}) {
  if (title.toLowerCase().contains("facebook")) {
    return IconPath.facebookIcon;
  }

  if (title.toLowerCase().contains("google")) {
    return IconPath.googleIcon;
  }
  if (title.toLowerCase().contains("netflix")) {
    return IconPath.netflixIcon;
  }

  if (title.toLowerCase().contains("amazon")) {
    return IconPath.amazonIcon;
  }

  if (title.toLowerCase().contains("apple")) {
    return IconPath.appleIcon;
  } else {
    return "";
  }
}
