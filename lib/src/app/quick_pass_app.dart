import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/utils/theme/app_theme.dart';
import 'package:quick_pass/src/app/features/profile/providers/theme_provider.dart';
import 'package:quick_pass/src/routes/router.dart';

class QuickPassApp extends ConsumerWidget {
  const QuickPassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp.router(
      title: "Quick Pass",
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoute.routes,
      themeMode: isDark.isDarkmode ? ThemeMode.dark : ThemeMode.light,
      theme: isDark.isDarkmode ? AppTheme.darkTheme : AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
