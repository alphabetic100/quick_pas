import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final String? prefixIconPath;
  final ValueChanged<String>? onChanged;
  final bool readonly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final int? maxLines;
  final InputBorder? focusedBorder;
  final Color? containerColor;
  final Color? hintTextColor;
  final double? hintTextSize;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Function()? onTap;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.readonly = false,
    this.prefixIconPath,
    this.maxLines = 1,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.containerColor = const Color(0xffF9FAFB),
    this.hintTextColor,
    this.hintTextSize = 15,
    this.suffixText,
    this.suffixTextStyle,
    this.validator,
    this.prefixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.maxFinite,
      //   padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        //color: isDarkMode ? Color(0xff171717) : Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        readOnly: readonly,
        onChanged: onChanged,
        obscureText: obscureText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.poppins(
          fontSize: (16),
          fontWeight: FontWeight.w400,
          color:
              ThemePreferance.instance.isDarkMode
                  ? Colors.white
                  : AppColors.secondaryColor,
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor:
              ThemePreferance.instance.isDarkMode
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white,
          prefixIcon:
              prefixIcon ??
              ((prefixIconPath != null)
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //  SizedBox(width: getWidth(20)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          prefixIconPath!,
                          height: (26),
                          width: (26),
                          color:
                              ThemePreferance.instance.isDarkMode
                                  ? Colors.white
                                  : null,
                        ),
                      ),
                      //  SizedBox(width: getWidth(10)),
                    ],
                  )
                  : null),
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          suffixStyle:
              suffixTextStyle ??
              GoogleFonts.poppins(
                fontSize: (12),
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: (hintTextSize ?? 15),
            fontWeight: FontWeight.w400,
            color:
                hintTextColor ??
                (ThemePreferance.instance.isDarkMode
                    ? Colors.white
                    : AppColors.textSecondary),
          ),
          border:
              border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
          focusedBorder:
              focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
          focusedErrorBorder:
              focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
          enabledBorder:
              enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color.fromARGB(110, 223, 97, 97)),
          ),

          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }
}
