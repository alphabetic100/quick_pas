import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/quick_pass_app.dart';

void main() {
  runApp(ProviderScope(child: QuickPassApp()));
}
