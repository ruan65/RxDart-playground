import 'package:flutter/foundation.dart';

import '../models/thing.dart';

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {
  const SearchResultLoading();
}

@immutable
class SearchResultEmpty implements SearchResult {
  const SearchResultEmpty();
}

@immutable
class SearchResultHasError implements SearchResult {
  final Object error;
  const SearchResultHasError(this.error);
}

@immutable
class SearchResultWithResults implements SearchResult {
  final List<Thing> results;
  const SearchResultWithResults(this.results);
}
