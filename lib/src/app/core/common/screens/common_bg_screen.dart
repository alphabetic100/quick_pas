import 'package:flutter/material.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';

class CommonBgScreen extends StatelessWidget {
  const CommonBgScreen({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(IconPath.passIcon, height: 40),
              VerticalSpace(height: 20),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
