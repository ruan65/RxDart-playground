import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_rxdart_examples/bloc/search_result.dart';
import 'package:rxdart/rxdart.dart';

import 'api.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  const SearchBloc._({required this.search, required this.results});

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();
    final Stream<SearchResult?> results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchTerm) {
      if (searchTerm.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(seconds: 1))
            .map((results) => results.isEmpty
                ? const SearchResultEmpty()
                : SearchResultWithResults(results))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
      }
    });
    return SearchBloc._(search: textChanges.sink, results: results);
  }

  void dispose() {
    search.close();
  }
}
