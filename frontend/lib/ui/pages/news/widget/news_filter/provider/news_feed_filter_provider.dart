import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/helper/shared_preference.dart';
import 'package:frontend/helper/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'news_feed_filter_provider.freezed.dart';
part 'news_feed_filter_provider.g.dart';

@riverpod
class NewsFeedFilter extends _$NewsFeedFilter {
  @override
  Future<NewsFeedFilterState> build() async {
    // await SharedPreferenceHelper().clearFilterPreference();
    final filterData = await SharedPreferenceHelper().getFilterPreference();
    final semanticSearch = await SharedPreferenceHelper().getFilterSemantic();
    if (filterData == null && semanticSearch == null) {
      return NewsFeedFilterState.initial();
    } else {
      print(
          '\n--------------------------------------------------------------------------');
      printPretty(filterData);
      print(
          '\n--------------------------------------------------------------------------');
      return NewsFeedFilterState(
        unRead: filterData?["unRead"] ?? false,
        bookmarked: filterData?["bookmarked"] ?? false,
        upvoted: filterData?["upvoted"] ?? false,
        mentioned: filterData?["mentioned"] ?? false,
        dismissed: filterData?["dismissed"] ?? false,
        semanticQuery: semanticSearch,
      );
    }
  }

  Future<void> updateFilter({
    bool? bookmarked,
    bool? unRead,
    bool? upvoted,
    bool? mentioned,
    bool? dismissed,
    String? semanticQuery,
  }) async {
    final stateValue = state.value;
    state = AsyncData(
      NewsFeedFilterState(
        bookmarked: bookmarked ?? stateValue!.bookmarked,
        unRead: unRead ?? stateValue!.unRead,
        upvoted: upvoted ?? stateValue!.upvoted,
        mentioned: mentioned ?? stateValue!.mentioned,
        dismissed: dismissed ?? stateValue!.dismissed,
        semanticQuery: semanticQuery ?? stateValue!.semanticQuery,
      ),
    );
  }

  Future<void> updateSemanticQuery({
    bool? bookmarked,
    bool? unRead,
    bool? upvoted,
    bool? mentioned,
    bool? dismissed,
    String? semanticQuery,
  }) async {
    if (semanticQuery != null ||
        bookmarked != null ||
        unRead != null ||
        upvoted != null ||
        mentioned != null ||
        dismissed != null) {
      final isFilterSaved = await SharedPreferenceHelper().setFilterPreference({
        "bookmarked": bookmarked ?? false,
        "unRead": unRead ?? false,
        "upvoted": upvoted ?? false,
        "mentioned": mentioned ?? false,
        "dismissed": dismissed ?? false,
      });
      if (isFilterSaved) {
        print('Filter Saved');
      } else {
        print('Filters not saved');
      }
      final stateValue = state.value;
      state = AsyncData(
        NewsFeedFilterState(
          bookmarked: bookmarked ?? stateValue!.bookmarked,
          unRead: unRead ?? stateValue!.unRead,
          upvoted: upvoted ?? stateValue!.upvoted,
          mentioned: mentioned ?? stateValue!.mentioned,
          dismissed: dismissed ?? stateValue!.dismissed,
          semanticQuery: semanticQuery,
        ),
      );

      final isSaved =
          await SharedPreferenceHelper().setFilterSemantic(semanticQuery ?? "");
      if (isSaved) {
        print('Query Saved');
      } else {
        print('Query not saved');
      }
    } else {
      // await SharedPreferenceHelper().clearFilterSemanticPreference();
    }
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
