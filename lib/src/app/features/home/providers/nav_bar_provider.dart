import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBarProvider {
  static final currentPage = StateProvider<int>((ref) => 0);

  static void changeIndex({required WidgetRef ref, required int index}) {
    ref.read(currentPage.notifier).state = index;
  }
}
