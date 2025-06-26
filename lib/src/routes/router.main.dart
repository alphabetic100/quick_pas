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

      GoRoute(
        path: HomeScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, HomeScreen()),
      ),

      GoRoute(
        path: ProfileScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, ProfileScreen()),
      ),

      GoRoute(
        path: AddPassScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, AddPassScreen()),
      ),

      GoRoute(
        path: UpdateProfileScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, UpdateProfileScreen()),
      ),

      GoRoute(
        path: ChangePasswordScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, ChangePasswordScreen()),
      ),

      GoRoute(
        path: AutofillSettingScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, AutofillSettingScreen()),
      ),

      GoRoute(
        path: GeneratePasswordScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, GeneratePasswordScreen()),
      ),

      // GoRoute(
      //   path: PassDetailsScreen.routeName,
      //   pageBuilder:
      //       (context, state) =>
      //           CustomPageTransitions.build(state, PassDetailsScreen(
      //             passwordData: data[index],
      //           )),
      // ),
      GoRoute(
        path: EditPassDetailsScreen.routeName,
        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, EditPassDetailsScreen()),
      ),

      GoRoute(
        path: SearchScreen.routeName,

        pageBuilder:
            (context, state) =>
                CustomPageTransitions.build(state, SearchScreen()),
      ),
    ],
  );
}
