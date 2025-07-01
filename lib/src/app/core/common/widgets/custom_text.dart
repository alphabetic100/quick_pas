import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/features/profile/providers/theme_provider.dart';

class CustomText extends ConsumerWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextAlign? textAlign;
  final String? fontFamily;
  final double? height;
  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    this.textOverflow,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.decoration,
    this.decorationColor,
    this.textAlign,
    this.fontFamily,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        height: height,
        decoration: decoration,
        fontFamily: fontFamily ?? GoogleFonts.poppins().fontFamily,
        decorationColor: decorationColor ?? AppColors.textSecondary,
        fontSize: fontSize ?? 16,
        color:
            color ??
            (isDark.isDarkmode ? Colors.white : AppColors.textSecondary),
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
