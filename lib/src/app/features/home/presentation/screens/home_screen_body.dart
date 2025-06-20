import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/core/utils/sizes/screen_spacer.dart';
import 'package:quick_pass/src/app/features/details&upgrade/presentation/screens/pass_details_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_stored_card.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
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
                      value: "5",
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
              prefixIconPath: IconPath.searchIcon,
              controller: TextEditingController(),
              hintText: "Search Websites...",
            ),
            VerticalSpace(height: 20),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return PasswordCard(
                  title: "google",
                  onTap: () => context.push(PassDetailsScreen.routeName),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
              itemCount: 5,
            ),
          ],
        ),
      ),
    );
  }
}
