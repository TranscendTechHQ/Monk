import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'news_provider.freezed.dart';

part 'news_provider.g.dart';

@riverpod
class NewsFeed extends _$NewsFeed {
  @override
  Future<List<ThreadMetaData>> build() async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final response = await threadApi.filterNewsfeedGet();
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch titles");
    }
    return response.data!.metadata;
  }

  Future<void> getFilteredFeed({
    bool? bookmark = false,
    bool? unRead = false,
    bool? unfollow = false,
    bool? upvote = false,
  }) async {
    state = const AsyncLoading();
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final response = await threadApi.filterNewsfeedGet(
      bookmark: bookmark,
      unread: unRead,
      unfollow: unfollow,
      upvote: upvote,
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch titles");
    }
    state = AsyncData(response.data!.metadata);
  }

  Future<void> filter({
    bool? bookmark = false,
    bool? unRead = false,
    bool? unfollow = false,
    bool? upvote = false,
  }) async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final response = await threadApi.filterNewsfeedGet(
      bookmark: bookmark,
      unread: unRead,
      unfollow: unfollow,
      upvote: upvote,
    );
    state = AsyncLoading();
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch titles");
    }
    state = AsyncData(response.data!.metadata);
  }

  void remove(String threadId) {
    final list = state.value?.getAbsoluteOrNull;

    if (list.isNotNullEmpty) {
      list!.removeWhere((element) => element.id == threadId);
      state = AsyncData(list);
    }
  }

  void markAsRead(String threadId) {
    final list = state.value?.getAbsoluteOrNull;

    if (list.isNotNullEmpty) {
      final thread =
          list!.firstWhereOrNull((element) => element.id == threadId);
      if (thread != null) {
        // thread.unread = false;
        final index = list.indexOf(thread);
        final map = thread.toJson();
        map['unread'] = false;
        final updatedThread = ThreadMetaData.fromJson(map);

        list[index] = updatedThread;
        state = AsyncData(list);
      }
    }
  }
}

@riverpod
class NewsCardPod extends _$NewsCardPod {
  @override
  NewsCardState build(ThreadMetaData threadMetaData) {
    return NewsCardState.initial(threadMetaData);
  }

  Future<bool> createTfThreadFlagPost(
    String threadId, {
    bool? bookmark,
    bool? unRead,
    bool? unfollow,
    bool? upvote,
  }) async {
    state = NewsCardState(
      threadMetaData: state.threadMetaData,
      estate: upvote == true
          ? ENewsCardState.upVoting
          : bookmark == true
              ? ENewsCardState.bookmarking
              : unRead == true
                  ? ENewsCardState.markingAsRead
                  : ENewsCardState.dismissing,
    );

    var res = await AsyncRequest.handle<bool?>(() async {
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final response = await threadApi.createTfThreadFlagPost(
        createUserThreadFlagModel: CreateUserThreadFlagModel(
          threadId: threadId,
          bookmark: bookmark,
          unread: unRead,
          unfollow: unfollow,
          upvote: upvote,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch titles");
      }
      return true;
    });
    final map = state.threadMetaData.toJson();
    if (upvote == true) {
      if (map.containsKey('upvote')) {
        map.update('upvote', (value) => true);
      } else {
        map.putIfAbsent('upvote', () => true);
      }
    } else if (bookmark == true) {
      if (map.containsKey('bookmark')) {
        map.update('bookmark', (value) => true);
      } else {
        map.putIfAbsent('bookmark', () => true);
      }
    }

    res.fold((l) => null, (isSuccess) {
      state = NewsCardState(
        threadMetaData: ThreadMetaData.fromJson(map),
        estate: isSuccess == true
            ? upvote == true
                ? ENewsCardState.upVoted
                : bookmark == true
                    ? ENewsCardState.bookmarked
                    : unRead == true
                        ? ENewsCardState.markedAsRead
                        : ENewsCardState.dismissed
            : ENewsCardState.initial,
      );
    });

    return res.fold((l) => false, (r) => true);
  }
}

@freezed
class NewsCardState with _$NewsCardState {
  const factory NewsCardState(
      {required ThreadMetaData threadMetaData,
      required ENewsCardState estate}) = _NewsCardState;
  factory NewsCardState.initial(ThreadMetaData threadMetaData) => NewsCardState(
      estate: ENewsCardState.initial, threadMetaData: threadMetaData);
}

enum ENewsCardState {
  initial,
  upVoting,
  upVoted,
  bookmarking,
  bookmarked,
  dismissing,
  dismissed,
  markingAsRead,
  markedAsRead,
}
