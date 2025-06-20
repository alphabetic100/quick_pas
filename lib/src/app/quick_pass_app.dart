import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/utils/theme/app_theme.dart';
import 'package:quick_pass/src/routes/router.dart';

class QuickPassApp extends StatelessWidget {
  const QuickPassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Quick Pass",
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoute.routes,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
