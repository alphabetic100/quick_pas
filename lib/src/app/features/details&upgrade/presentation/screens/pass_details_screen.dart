import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PassDetailsScreen extends StatelessWidget {
  const PassDetailsScreen({super.key});
  static const String routeName = "/home/details";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }
}
