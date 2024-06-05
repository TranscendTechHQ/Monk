import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'news_feed_filter_provider.freezed.dart';
part 'news_feed_filter_provider.g.dart';

@riverpod
class NewsFeedFilter extends _$NewsFeedFilter {
  @override
  NewsFeedFilterState build() {
    return NewsFeedFilterState.initial();
  }

  void updateFilter({
    bool? bookmarked,
    bool? unRead,
    bool? upvoted,
    bool? mentioned,
    bool? dismissed,
    String? semanticQuery,
  }) {
    state = state.copyWith(
      bookmarked: bookmarked ?? state.bookmarked,
      unRead: unRead ?? state.unRead,
      upvoted: upvoted ?? state.upvoted,
      mentioned: mentioned ?? state.mentioned,
      dismissed: dismissed ?? state.dismissed,
      semanticQuery: semanticQuery ?? state.semanticQuery,
    );
  }
}

@freezed
class NewsFeedFilterState with _$NewsFeedFilterState {
  const factory NewsFeedFilterState({
    @Default(false) bool unRead,
    @Default(false) bool bookmarked,
    @Default(false) bool upvoted,
    @Default(false) bool mentioned,
    @Default(false) bool dismissed,
    String? semanticQuery,
  }) = _NewsFeedFilterState;
  factory NewsFeedFilterState.initial() => const NewsFeedFilterState();
}
