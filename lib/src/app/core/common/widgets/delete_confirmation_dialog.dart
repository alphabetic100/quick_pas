import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_button.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.itemName,
    required this.onConfirm,
    this.confirmButtonText = 'Delete',
    this.cancelButtonText = 'Cancel',
  });

  final String title;
  final String content;
  final String itemName;
  final VoidCallback onConfirm;
  final String confirmButtonText;
  final String cancelButtonText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          ThemePreferance.instance.isDarkMode
              ? Color(0xFF282828)
              : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Delete Password!",
              fontFamily: FontFamily.bebasNeue,
              fontSize: 30,
              color: ThemePreferance.instance.isDarkMode? Colors.white: AppColors.secondaryColor,
            ),

            SizedBox(height: 10),

            CustomText(
              text: "Are you sure! \nyou want to delete this password?",
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12),
            
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemePreferance.instance.isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                text: itemName,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: cancelButtonText,
                    color:
                         ThemePreferance.instance.isDarkMode
                          ? Colors.white.withValues(alpha: 0.2)
                          : null,
                  ),
                ),
                SizedBox(width: 12),

                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    title: confirmButtonText,
                    color: Colors.red,
                    titleColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Static method to show the delete confirmation dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required String itemName,
    required VoidCallback onConfirm,
    String confirmButtonText = 'Delete',
    String cancelButtonText = 'Cancel',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: title,
          content: content,
          itemName: itemName,
          onConfirm: onConfirm,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
        );
      },
    );
  }
}
