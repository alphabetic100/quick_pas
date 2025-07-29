import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';

import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/home/presentation/screens/home_screen.dart';
import 'package:quick_pass/src/app/features/onboardings/presentation/view/onbording_screen.dart';
import 'package:quick_pass/src/app/features/splash/provider/splash_provider.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});
  static const String routeName = "/";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!splashState.isLoading) {
        if (splashState.isAuthenticated) {
          if (splashState.hasToken) {
            context.go(HomeScreen.routeName);
          } else {
            context.go(OnbordingScreen.routeName);
          }
        } else {
          _showAuthenticationDialog(context);
        }
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(IconPath.passIcon, height: 40),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "QUICK",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 40,
                    ),
                  ),
                  TextSpan(
                    text: " PASS",
                    style: TextStyle(
                      color:
                          ThemePreferance.instance.isDarkMode
                              ? Colors.white
                              : AppColors.secondaryColor,
                      fontSize: 40,
                    ),
                  ),

                  if (splashState.isLoading) ...[],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAuthenticationDialog(BuildContext context) {
    showDialog(
      context: context,
    //  barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(text:  'Security Notice',  fontSize: 34,
            fontFamily: FontFamily.bebasNeue,
            color: AppColors.primaryColor,),
          content: CustomText(text:  'To use the application, you need to enable security features like biometrics on your device.', 
          fontSize: 14,
          color: AppColors.secondaryColor,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }
}
