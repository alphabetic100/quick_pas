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

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "/";

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for both icon and text
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween(begin: 0.9, end: 1.1).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Fade and slide animation for text
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween(begin: 30.0, end: 0.0).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
    
    // Start the fade animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
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
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Image.asset(IconPath.passIcon, height: 40),
                );
              },
            ),
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text.rich(
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
                        ],
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
