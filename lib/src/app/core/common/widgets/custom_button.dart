import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.width,
    required this.onTap,
    required this.title,
    this.color,
    this.radious,
    this.padding,
    this.isPrimary = true,
    this.titleColor = Colors.white,
    this.isChild = false,
    this.child,
    this.bordercolor,
  });

  final double? height;
  final double? width;
  final VoidCallback onTap;
  final String title;
  final Color? color;
  final double? radious;
  final double? padding;
  final bool isPrimary;
  final Color titleColor;
  final bool isChild;
  final Color? bordercolor;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: bordercolor ?? AppColors.primaryColor),
          ),
          overlayColor: WidgetStatePropertyAll(
            AppColors.primaryColor.withValues(alpha: 0.3),
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.all(padding ?? 8)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radious ?? 16),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(
            color ?? (isPrimary ? AppColors.primaryColor : Colors.white),
          ),
        ),
        onPressed: onTap,
        child:
            isChild
                ? child
                : CustomText(
                  text: title,
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textOverflow: TextOverflow.ellipsis,
                  fontFamily: FontFamily.bebasNeue,
                ),
      ),
    );
  }
}
