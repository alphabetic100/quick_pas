part of "router.dart";

class AppRoute {
  AppRoute._();
  static GoRouter routes = GoRouter(
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, const SplashScreen()),
      ),

      //Authentication screens
      GoRoute(
        path: OnbordingScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, const OnbordingScreen()),
      ),

      GoRoute(
        path: LoginScreen.routeName,
        onExit: (context, state) => true,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, LoginScreen()),
      ),

      GoRoute(
        path: SignupScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, SignupScreen()),
      ),

      GoRoute(
        path: ForgetPasswordScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, ForgetPasswordScreen()),
      ),
    ],
  );
}
