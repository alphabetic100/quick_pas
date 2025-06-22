import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/home/presentation/screens/home_screen.dart';
import 'package:quick_pass/src/app/features/onboardings/presentation/view/onbording_screen.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "/";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000), () {
      if (SecureStorageService.instance.hasToken) {
        context.go(HomeScreen.routeName);
      } else {
        context.go(OnbordingScreen.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(IconPath.passIcon, height: 40),
          SizedBox(height: 10, width: MediaQuery.of(context).size.width),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "QUICK",
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 40),
                ),
                TextSpan(
                  text: " PASS",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
