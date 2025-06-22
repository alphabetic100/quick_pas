import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';

class LoadingWidget {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),

            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CupertinoActivityIndicator(
                  radius: 15,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 16),
                const CustomText(
                  text: 'Loading',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
}
