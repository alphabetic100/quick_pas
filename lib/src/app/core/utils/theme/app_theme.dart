import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldBgLight,
    fontFamily: GoogleFonts.bebasNeue().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.scaffoldBgDark,
    scaffoldBackgroundColor: AppColors.scaffoldBgDark,
    fontFamily: GoogleFonts.bebasNeue().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
      surfaceTintColor: AppColors.secondaryColor,
    ),
  );
}
