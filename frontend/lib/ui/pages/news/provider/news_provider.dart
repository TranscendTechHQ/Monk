import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/helper/shared_preference.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/main.dart';
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
    const oneSec = Duration(seconds: 10);
    Timer.periodic(
        oneSec, (Timer t) async => await getFilteredFeed(isRefresh: false));

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
    bool? mention = false,
    String? searchQuery,
    bool isFilterEnabled = false,
    bool isRefresh = true,
  }) async {
    if (isRefresh) {
      state = const AsyncLoading();
    }
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final response = await threadApi.filterNewsfeedGet(
      bookmark: bookmark,
      unread: unRead,
      unfollow: unfollow,
      upvote: upvote,
      mention: mention,
      searchQuery: searchQuery,
      isFilterEnabled: isFilterEnabled,
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch titles");
    }
    state = AsyncData(response.data!.metadata);
  }

  Future<void> displayMentionedThreads() async {
    final allThreads = state.value?.getAbsoluteOrNull;
    if (allThreads.isNotNullEmpty) {
      final mentionedThreads = allThreads!
          .where((element) => element.mention == true)
          .toList(growable: false);
      state = AsyncData(mentionedThreads);
    }
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

  Future<bool> deleteThreadAsync(BuildContext context, threadId) async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final res = await AsyncRequest.handle<bool?>(() async {
      loader.showLoader(context, message: "Deleting thread");
      final response =
          await threadApi.deleteThreadThreadsIdDelete(id: threadId);
      if (response.statusCode != 200) {
        final res = response.data as Map<String, dynamic>?;
        throw Exception(res?['message'] ?? "Failed to delete thread");
      }
      return true;
    });
    loader.hideLoader();

    return res.fold((l) {
      final res = l.response?.data;
      if (res != null && res is Map<String, dynamic>) {
        showMessage(context, res['message'] ?? "Failed to delete thread");
      } else {
        showMessage(context, "Failed to delete thread");
      }
      return false;
    }, (r) {
      showMessage(context, "Thread deleted successfully");
      remove(threadId);
      return true;
    });
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
      estate: upvote != null
          ? ENewsCardState.upVoting
          : bookmark != null
              ? ENewsCardState.bookmarking
              : unRead != null
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
    if (upvote != null) {
      if (map.containsKey('upvote')) {
        map.update('upvote', (value) => upvote);
      } else {
        map.putIfAbsent('upvote', () => upvote);
      }
    } else if (bookmark != null) {
      if (map.containsKey('bookmark')) {
        map.update('bookmark', (value) => bookmark);
      } else {
        map.putIfAbsent('bookmark', () => bookmark);
      }
    }

    res.fold((l) => null, (isSuccess) {
      state = NewsCardState(
        threadMetaData: ThreadMetaData.fromJson(map),
        estate: upvote != null
            ? ENewsCardState.upVoted
            : bookmark != null
                ? ENewsCardState.bookmarked
                : unRead != null
                    ? ENewsCardState.markedAsRead
                    : ENewsCardState.dismissed,
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
