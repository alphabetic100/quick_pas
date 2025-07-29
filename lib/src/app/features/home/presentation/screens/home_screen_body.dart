import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/font_family.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/constants/assets/image_path.dart';
import 'package:quick_pass/src/app/core/utils/colors/app_colors.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/details&upgrade/presentation/screens/pass_details_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card_shimmer.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_stored_card.dart';
import 'package:quick_pass/src/app/features/home/presentation/screens/search_screen.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';

class HomeScreenBody extends ConsumerWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(allPasswordProvider);
    return CommonBgScreen(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,

              child: Row(
                children: [
                  Expanded(
                    child: PasswordStoredCard(
                      value:
                          homeState.isLoading
                              ? "..."
                              : homeState.error != null
                              ? "error"
                              : homeState.passwords.length.toString(),
                      title: "Passwords \nStored",
                    ),
                  ),
                  HorizontalSpace(width: 16),
                  Expanded(
                    child: PasswordStoredCard(
                      value: "0",
                      title: "Passwords \nCompromised",
                    ),
                  ),
                ],
              ),
            ),

            VerticalSpace(height: 18),
            CustomTextFormField(
              onTap: () => context.push(SearchScreen.routeName),
              readonly: true,
              prefixIconPath: IconPath.searchIcon,
              controller: TextEditingController(),
              hintText: "Search Websites...",
            ),
            VerticalSpace(height: 20),
            homeState.isLoading
                ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return PasswordCardShimmer();
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  itemCount: 4,
                )
                : homeState.error != null
                ? Center(child: CustomText(text: homeState.error!))
                : homeState.passwords.isNotEmpty
                ? ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return PasswordCard(
                      title: homeState.passwords[index].name,
                      password: homeState.passwords[index].password,
                      onTap:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => PassDetailsScreen(
                                    passwordData: homeState.passwords[index],
                                  ),
                            ),
                          ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  itemCount: homeState.passwords.length,
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalSpace(height: 10),
                    Image.asset(ImagePath.emptySearch),
                    VerticalSpace(height: 20),
                    CustomText(
                      text: "Empty List",
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily.bebasNeue,
                      fontSize: 30,
                      color: AppColors.secondaryColor,
                    ),
                    CustomText(
                      text: "No saved password found!",
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
