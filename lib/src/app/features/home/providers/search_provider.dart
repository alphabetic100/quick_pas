import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';

class SearchState {
  final String query;
  final List<PasswordModel> results;


  SearchState({ required this.query, required this.results });

  SearchState copyWith({ String? query, List<PasswordModel>? results }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier(this.ref)
      : super(SearchState(query: '', results: [], )) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen(allPasswordProvider, (previous, next) {
      _search(state.query);
    });
    _search('');
  }

  void updateQuery(String newQuery) {
    state = state.copyWith(query: newQuery);
    _search(newQuery);
  }

  void clearSearch() {
    state = state.copyWith(query: '');
    _search('');
  }

  void _search(String query) {
    final allPasswords = ref.read(allPasswordProvider).passwords;

    if (query.isEmpty) {
      state = state.copyWith(results: allPasswords);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final List<PasswordModel> nameMatches = [];
    final List<PasswordModel> urlMatches = [];
    final List<PasswordModel> otherMatches = [];

    for (final password in allPasswords) {
      if (password.name.toLowerCase().contains(lowerQuery)) {
        nameMatches.add(password);
      } else if (password.url.toLowerCase().contains(lowerQuery)) {
        urlMatches.add(password);
      } else if (password.email.toLowerCase().contains(lowerQuery)) {
        otherMatches.add(password);
      }
    }
      
    state = state.copyWith(results: [...nameMatches, ...urlMatches, ...otherMatches]);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});

