import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/common/screens/common_bg_screen.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_text_form_field.dart';
import 'package:quick_pass/src/app/core/constants/assets/icon_path.dart';
import 'package:quick_pass/src/app/features/details&upgrade/presentation/screens/pass_details_screen.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/no_result_found_widget.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card.dart';
import 'package:quick_pass/src/app/features/home/presentation/components/password_card_shimmer.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';
import 'package:quick_pass/src/app/features/home/providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = "/search-pass";

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider.notifier).clearSearch();
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final passwordState = ref.watch(allPasswordProvider);
    final searchState = ref.watch(searchProvider);

    return CommonBgScreen(
      child: Column(
        children: [
          CustomTextFormField(
            prefixIconPath: IconPath.searchIcon,
            controller: search,
            hintText: "Search Websites...",
            onChanged: (value) {
              ref.read(searchProvider.notifier).updateQuery(value);
            },
          ),
          SizedBox(height: 18),

          passwordState.isLoading
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
              : passwordState.error != null
              ? Center(child: CustomText(text: passwordState.error!))
              : searchState.results.isNotEmpty
              ? Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return PasswordCard(
                      title: searchState.results[index].name,
                      password: searchState.results[index].password,
                      onTap:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => PassDetailsScreen(
                                    passwordData: searchState.results[index],
                                  ),
                            ),
                          ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  itemCount: searchState.results.length,
                ),
              )
              : Expanded(child: NoResultFoundWidget()),
        ],
      ),
    );
  }
}
