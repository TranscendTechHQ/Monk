// this is a @riverpod generated notifer that maintains state for a thread.
// a thread is a collection of blocks that are related to each other.
// thread encapsulated BlockCollection datamodel

// a riverpod provider that stores the content of a single day's journal entry
// this entry can be accessed from anywhere in the app and also be sent to the
// backend.
//  - the backend will store the journal entry in the database
// ...

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'thread.g.dart';

@riverpod
Future<Map<String, String>> fetchThreadsInfo(FetchThreadsInfoRef ref) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.tiThreadsInfoGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch titles");
  }
  return response.data!.info;
}

@riverpod
Future<List<String>> fetchThreadTypes(FetchThreadTypesRef ref) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.ttThreadTypesGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch thread types");
  }
  return response.data!;
}

Future<FullThreadInfo> fetchThreadFromId({required String id}) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();

  final response = await threadApi.getThreadIdThreadsIdGet(id: id);

  if (response.statusCode != 200) {
    throw Exception("Failed to get thread");
  }
  return response.data!;
}

Future<FullThreadInfo> createOrGetThread(
    {required String title, required String type}) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();

  final response = await threadApi.createThThreadsPost(
      createThreadModel: CreateThreadModel(title: title, type: type));

  if (response.statusCode != 201) {
    throw Exception("Failed to create thread");
  }
  return response.data!;
}

@riverpod
class CurrentThread extends _$CurrentThread {
  @override
  Future<FullThreadInfo?> build({
    required String title,
    required String type,
    ThreadType threadType = ThreadType.thread,
    String? threadChildId,
  }) async {
    state = const AsyncValue.loading();
    FullThreadInfo? thread;
    if (threadType == ThreadType.thread) {
      thread = await createOrGetThread(title: title, type: type);
    } else {
      thread = await fetchThreadFromIdAsync(threadChildId!);
    }

    state = AsyncValue.data(thread);
    return state.value;
  }

  Future<bool> createBlock(String text, {String? customTitle}) async {
    MonkException.handle(() async {
      String? threadTitle = state.value?.title ?? customTitle;
      if (threadTitle.isNullOrEmpty) {
        logger.e("Thread title is null");
        throw Exception("Thread title is null");
      }
      logger.d("creating new Thread title $threadTitle");
      final blockApi = NetworkManager.instance.openApi.getThreadsApi();
      final parentThreadId = state.value!.id;
      if (parentThreadId != null) {
        logger.d("creating new block with parent thread id $parentThreadId");
      }

      final newThreadState = await blockApi.createBlocksPost(
        threadTitle: threadTitle!,
        createBlockModel: CreateBlockModel(
          content: text,
          parentThreadId: parentThreadId,
        ),
      );

      if (newThreadState.statusCode != 201) {
        throw Exception("Failed to create block");
      }
      if (newThreadState.data is BlockWithCreator) {
        final list = state.value?.content.getOrEmpty ?? [];
        list.add(newThreadState.data!);

        final updatedThreadModel = FullThreadInfo(
          title: state.value!.title,
          type: state.value!.type,
          content: list,
          creator: state.value!.creator,
          id: state.value!.id,
          createdDate: state.value!.createdDate,
        );
        state = AsyncValue.data(updatedThreadModel);
      } else {
        return false;
      }
    });
    return true;
  }

  Future<FullThreadInfo?> fetchThreadFromIdAsync(String id) async {
    return MonkException.handle(() async {
      logger.d("Fetching child thread. id: $id");
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final response = await threadApi.getThreadIdThreadsIdGet(id: id);
      if (response.statusCode == 404) {
        throw Exception("Thread not found");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to get thread");
      }
      logger.d("Child thread. fetched success fully: $id");
      if (response.data != null) {
        // return response.data.content;
      }
      return response.data;
    });
  }

  void addChildThreadIdToBlock(String childThreadId, String blockId) {
    final thread = state.value;
    if (thread == null) {
      logger.e("There is no thread to add child thread id to");
      return;
    }

    var block = thread.content?.firstWhere((element) => element.id == blockId);

    if (block != null) {
      final map = block.toJson()
        ..putIfAbsent("child_id", () => childThreadId)
        ..update("child_id", (value) => childThreadId);

      block = BlockWithCreator.fromJson(map);
      final newContent = thread.content?.map((e) {
        if (e.id == blockId) {
          return block!;
        }
        return e;
      }).toList();
      final updatedThreadModel = FullThreadInfo(
        title: thread.title,
        type: thread.type,
        content: newContent!,
        creator: thread.creator,
        id: thread.id,
        createdDate: thread.createdDate,
      );

      state = AsyncValue.data(updatedThreadModel);
    } else {
      logger.e("Can't find block with id $blockId");
    }
  }

  List<String> getBlocks() {
    final blocks =
        state.value?.content?.map((e) => e.content).toList().reversed.toList();
    return blocks ?? [];
  }

  Future<void> updateBlock(String blockId, String content) async {
    MonkException.handle(() async {
      final thread = state.value;
      if (thread == null) {
        logger.e("There is no thread to update block");
        return;
      }

      final block =
          thread.content?.firstWhere((element) => element.id == blockId);

      if (block != null) {
        final map = block.toJson()
          ..putIfAbsent("content", () => content)
          ..update("content", (value) => content);

        final updatedBlock = BlockWithCreator.fromJson(map);
        final newContent = thread.content?.map((e) {
          if (e.id == blockId) {
            return updatedBlock;
          }
          return e;
        }).toList();
        final updatedThreadModel = FullThreadInfo(
          title: thread.title,
          type: thread.type,
          content: newContent!,
          creator: thread.creator,
          id: thread.id,
          createdDate: thread.createdDate,
        );
        logger.i('updating block with id $blockId');
        final threadApi = NetworkManager.instance.openApi.getThreadsApi();
        await threadApi.updateBlocksIdPut(
          id: blockId,
          threadTitle: thread.title,
          updateBlockModel: UpdateBlockModel(
            content: content,
          ),
        );
        state = AsyncValue.data(updatedThreadModel);
      } else {
        logger.e("Can't find block with id $blockId");
      }
    });
  }

  Future<void> updateThreadTitle(String title) async {
    MonkException.handle(() async {
      final thread = state.value;
      if (thread == null) {
        logger.e("There is no thread to update title");
        return;
      }

      final updatedThreadModel = FullThreadInfo(
        title: title,
        type: thread.type,
        content: thread.content,
        creator: thread.creator,
        id: thread.id,
        createdDate: thread.createdDate,
      );
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final res = await threadApi.updateThThreadsIdPut(
        id: thread.id,
        updateThreadTitleModel: UpdateThreadTitleModel(title: title),
      );
      if (res.statusCode != 200) {
        throw Exception("Failed to update thread title");
      } else {
        state = AsyncValue.data(updatedThreadModel);
      }
    });
  }

  void reorderBlocks(int oldIndex, int newIndex) {
    final thread = state.value;
    if (thread == null) {
      logger.e("There is no thread to reorder blocks");
      return;
    }

    final blocks = thread.content.getAbsoluteOrNull;
    if (blocks == null) {
      logger.e("There are no blocks to reorder");
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final block = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, block);

    final updatedThreadModel = FullThreadInfo(
      title: thread.title,
      type: thread.type,
      content: blocks,
      creator: thread.creator,
      id: thread.id,
      createdDate: thread.createdDate,
    );

    state = AsyncValue.data(updatedThreadModel);
  }

  Future<FullThreadInfo?> createChildThread(
      CreateChildThreadModel createChildThreadModel) async {
    return MonkException.handle(() async {
      logger.d("Creating child thread");
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final response = await threadApi.childThreadBlocksChildPost(
        createChildThreadModel: createChildThreadModel,
      );
      if (response.statusCode == 201 || response.data != null) {
        //print(response.data);
        if (response.data != null) {
          logger.d("Child thread is created");

          List<BlockWithCreator> list = state.value?.content.getOrEmpty ?? [];
          final index = list.indexWhere(
              (element) => element.id == createChildThreadModel.parentBlockId);
          if (index != -1) {
            final oldModel = list[index];
            // list[index].childId = response.data!.id;
            final map = oldModel.toJson();
            // ..putIfAbsent("childThreadId", () => response.data!.id);
            if (map.containsKey("child_thread_id")) {
              map.update("child_thread_id", (value) => response.data!.id);
              debugPrint("childThreadId updated");
            } else {
              map.putIfAbsent("child_thread_id", () => response.data!.id);
              debugPrint("childThreadId Inserted, ${map['child_thread_id']}");
            }

            printPretty(map);

            final updatedThreadModel = BlockWithCreator.fromJson(map);
            list[index] = updatedThreadModel;
            final threadInfo = state.value!.toJson();
            if (threadInfo.containsKey("content")) {
              threadInfo["content"] = list.map((e) => e.toJson()).toList();
            } else {
              threadInfo.putIfAbsent("content", () => list);
            }

            final updatedThreadModel2 = FullThreadInfo.fromJson(threadInfo);

            state = AsyncValue.data(updatedThreadModel2);
            logger.d("Updated in state");
          } else {
            logger.e("Parent block not found");
          }

          return response.data;
        }
        throw Exception("Thread already created, please refresh the page.");
      }

      logger.e("Failed to create child thread",
          error: response.data ?? response.statusCode);
      return null;
    });
  }
}
