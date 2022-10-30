import 'package:flutter/foundation.dart';

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
