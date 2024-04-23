import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'news_provider.freezed.dart';

part 'news_provider.g.dart';

@riverpod
Future<List<ThreadHeadlineModel>> fetchThreadsHeadlinesAsync(
    FetchThreadsHeadlinesAsyncRef ref) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.thThreadHeadlinesGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch titles");
  }
  return response.data!.headlines;
}

@riverpod
Future<List<ThreadMetaData>> fetchThreadsMdMetaDataAsync(
    FetchThreadsMdMetaDataAsyncRef ref) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.mdMetadataGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch titles");
  }
  return response.data!.metadata;
}

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

  Future<void> filter({
    bool? bookmark = false,
    bool? read = false,
    bool? unfollow = false,
    bool? upvote = false,
  }) async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final response = await threadApi.filterNewsfeedGet(
      bookmark: bookmark,
      read: read,
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
    bool? read,
    bool? unfollow,
    bool? upvote,
  }) async {
    state = NewsCardState(
      threadMetaData: state.threadMetaData,
      estate: upvote == true
          ? ENewsCardState.upVoting
          : bookmark == true
              ? ENewsCardState.bookmarking
              : read == true
                  ? ENewsCardState.markingAsRead
                  : ENewsCardState.dismissing,
    );

    final res = await MonkException.handle<bool?>(() async {
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final response = await threadApi.createTfThreadFlagPost(
        createUserThreadFlagModel: CreateUserThreadFlagModel(
          threadId: threadId,
          bookmark: bookmark,
          read: read,
          unfollow: unfollow,
          upvote: upvote,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch titles");
      }
      return true;
    });
    state = NewsCardState(
      threadMetaData: state.threadMetaData,
      estate: res == true
          ? upvote == true
              ? ENewsCardState.upVoted
              : bookmark == true
                  ? ENewsCardState.bookmarked
                  : read == true
                      ? ENewsCardState.markedAsRead
                      : ENewsCardState.dismissed
          : ENewsCardState.initial,
    );

    return res ?? false;
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
