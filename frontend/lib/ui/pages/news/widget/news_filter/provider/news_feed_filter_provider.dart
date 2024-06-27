import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_feed_filter_provider.freezed.dart';
part 'news_feed_filter_provider.g.dart';

@riverpod
class NewsFeedFilter extends _$NewsFeedFilter {
  @override
  Future<NewsFeedFilterState> build() async {
    // await SharedPreferenceHelper().clearFilterPreference();
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final res = await AsyncRequest.handle<UserFilterPreferenceModel>(() async {
      final response =
          await threadApi.getUserFilterPreferencesUserNewsFilterGet();
      if (response.statusCode != 200) {
        throw Exception("Failed to fetch titles");
      }

      return response.data!;
    });

    return res.fold((l) {
      return const NewsFeedFilterState();
    }, (r) {
      return NewsFeedFilterState(
        bookmarked: r.bookmark ?? false,
        // unRead: r.unread ?? false,
        upvoted: r.upvote ?? false,
        mentioned: r.mention ?? false,
        dismissed: r.unfollow ?? false,
        semanticQuery: r.searchQuery,
      );
    });
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
    String? semanticQuery,
  }) async {
    if (semanticQuery != null) {
      final stateValue = state.value;
      state = AsyncData(
        NewsFeedFilterState(
          bookmarked: stateValue!.bookmarked,
          unRead: stateValue.unRead,
          upvoted: stateValue.upvoted,
          mentioned: stateValue.mentioned,
          dismissed: stateValue.dismissed,
          semanticQuery: semanticQuery,
        ),
      );
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

bool onlyMentionedFilterApplied(NewsFeedFilterState? state) {
  final isOk = state != null &&
      state.mentioned &&
      state.semanticQuery.isNullOrEmpty &&
      state.unRead == false &&
      state.bookmarked == false &&
      state.upvoted == false &&
      state.dismissed == false;
  return isOk;
}

bool onlyUnReadFilterApplied(NewsFeedFilterState? state) {
  final isOk = state != null &&
      state.mentioned == false &&
      state.semanticQuery.isNullOrEmpty &&
      state.unRead == true &&
      state.bookmarked == false &&
      state.upvoted == false &&
      state.dismissed == false;
  return isOk;
}

bool isSemanticSearchFilterApplied(NewsFeedFilterState? state) {
  final isOk = state != null && state.semanticQuery.isNotNullEmpty;

  return isOk;
}

bool anyFilterApplied(NewsFeedFilterState? state) {
  final isOk = state != null &&
      (state.mentioned ||
          // state.semanticQuery.isNotNullEmpty ||
          // state.unRead ||
          state.bookmarked ||
          state.upvoted ||
          state.dismissed);
  return isOk;
}
