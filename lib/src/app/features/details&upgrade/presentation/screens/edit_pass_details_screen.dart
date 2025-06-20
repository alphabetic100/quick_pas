import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPassDetailsScreen extends StatelessWidget {
  const EditPassDetailsScreen({super.key});
  static const String routeName = "/details/edit";
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
