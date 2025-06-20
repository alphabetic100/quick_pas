import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingProvider {
  // Current index provider
  static StateProvider currentIndex = StateProvider<int>((ref) => 0);

  // Change current index
  static changeIndex({required WidgetRef ref, required int value}) {
    ref.read(currentIndex.notifier).state = value;
  }
}
