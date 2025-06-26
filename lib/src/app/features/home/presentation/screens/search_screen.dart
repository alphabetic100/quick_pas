import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/features/details&upgrade/presentation/screens/pass_details_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card_shimmer.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});
  static const String routeName = "/search-pass";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(allPasswordPrivider);
    return CommonBgScreen(
      child: Column(
        children: [
          CustomTextFormField(
            prefixIconPath: IconPath.searchIcon,
            controller: TextEditingController(),
            hintText: "Search Websites...",
          ),
          SizedBox(height: 18),

          searchState.when(
            data:
                (data) =>
                    data != null
                        ? ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return PasswordCard(
                              title: data[index].name,
                              password: data[index].password,
                              onTap:
                                  () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => PassDetailsScreen(
                                            passwordData: data[index],
                                          ),
                                    ),
                                  ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20);
                          },
                          itemCount: data.length,
                        )
                        : Center(
                          child: CustomText(
                            text:
                                "Something went wrong, please check your internet and try again",
                            textAlign: TextAlign.center,
                          ),
                        ),
            error:
                (error, stackTrace) =>
                    Center(child: CustomText(text: error.toString())),
            loading:
                () => ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return PasswordCardShimmer();
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  itemCount: 4,
                ),
          ),
        ],
      ),
    );
  }
}
