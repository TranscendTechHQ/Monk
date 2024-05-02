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
import 'package:freezed_annotation/freezed_annotation.dart';
part 'thread.freezed.dart';

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
  final res = await AsyncRequest.handle<FullThreadInfo>(() async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();

    final response = await threadApi.createThThreadsPost(
        createThreadModel: CreateThreadModel(title: title, type: type));

    if (response.statusCode != 201) {
      throw Exception("Failed to create thread");
    }
    return response.data!;
  });

  return res.fold((l) {
    if (l.response?.statusCode == 500) {
      throw Exception("Something went wrong, please try again later.");
    }
    throw Exception(l.message);
  }, (r) => r);
}

@riverpod
class CurrentThread extends _$CurrentThread {
  @override
  Future<CurrentTreadState> build({
    required String title,
    required String type,
    ThreadType threadType = ThreadType.thread,
    String? threadChildId,
    String? mainThreadId,
  }) async {
    state = const AsyncValue.loading();
    FullThreadInfo? thread;
    if (threadType == ThreadType.thread) {
      thread = await createOrGetThread(title: title, type: type);
    } else {
      thread = await fetchThreadFromIdAsync(threadChildId!);
    }
    print("\n ---- Block Order ---- \n");
    print(thread?.content?.map((e) => e.position).toList());
    return CurrentTreadState.result(blocks: thread?.content, thread: thread);
  }

  Future<bool> createBlock(String text, {String? customTitle}) async {
    final thread = state.value?.thread;
    if (thread == null) {
      throw Exception("Thread is null");
    }
    final res = await AsyncRequest.handle<BlockWithCreator>(() async {
      String? threadTitle = thread.title ?? customTitle;
      if (threadTitle.isNullOrEmpty) {
        logger.e("Thread title is null");
        throw Exception("Thread title is null");
      }
      logger.d("creating new Thread title $threadTitle");
      final blockApi = NetworkManager.instance.openApi.getThreadsApi();
      final mainThreadId = thread.id;

      final newThreadState = await blockApi.createBlocksPost(
        threadTitle: threadTitle!,
        createBlockModel: CreateBlockModel(
          content: text,
          mainThreadId: mainThreadId,
        ),
      );
      return newThreadState.data!;
    });

    return res.fold((l) {
      throw Exception(l.message ?? "Failed to create block");
    }, (block) {
      final list = state.value?.blocks.getOrEmpty ?? [];
      list.add(block);

      final updatedThreadModel = FullThreadInfo(
        title: thread.title,
        type: thread.type,
        content: list,
        creator: thread.creator,
        id: thread.id,
        defaultBlock: thread.defaultBlock,
        createdDate: thread.createdDate,
      );
      state = AsyncValue.data(
          CurrentTreadState.result(blocks: list, thread: updatedThreadModel));
      return true;
    });
  }

  Future<FullThreadInfo?> fetchThreadFromIdAsync(String id) async {
    final res = await AsyncRequest.handle<FullThreadInfo>(() async {
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
    return res.fold((l) {
      throw Exception(l.message);
    }, (r) {
      print(r.content?.map((e) => e.position).toList());
      return r;
    });
  }

  void addChildThreadIdToBlock(String childThreadId, String blockId) {
    final thread = state.value?.thread;
    final blocks = state.value?.blocks.getOrEmpty;
    if (thread == null) {
      logger.e("There is no thread to add child thread id to");
      return;
    } else if (blocks.isNullOrEmpty) {
      logger.e("There is no block to add child thread id to");
      return;
    }

    var block = blocks!.firstWhere((element) => element.id == blockId);

    final map = block.toJson()
      ..putIfAbsent("child_thread_id", () => childThreadId)
      ..update("child_thread_id", (value) => childThreadId);

    block = BlockWithCreator.fromJson(map);
    final updatedBlocks = blocks.map((e) {
      if (e.id == blockId) {
        return block;
      }
      return e;
    }).toList();
    final updatedThreadModel = FullThreadInfo(
      title: thread.title,
      type: thread.type,
      content: updatedBlocks,
      creator: thread.creator,
      id: thread.id,
      defaultBlock: thread.defaultBlock,
      createdDate: thread.createdDate,
    );

    state = AsyncValue.data(CurrentTreadState.result(
        blocks: updatedBlocks, thread: updatedThreadModel));
  }

  Future<void> updateBlock(String blockId, String content) async {
    final thread = state.value?.thread;
    final blocks = state.value?.blocks.getOrEmpty;
    if (thread == null) {
      logger.e("There is no thread to add child thread id to");
      return;
    } else if (blocks.isNullOrEmpty) {
      logger.e("There is no block to add child thread id to");
      return;
    }
    var block = blocks?.firstWhere((element) => element.id == blockId);
    if (block == null) {
      logger.e("Block not found");
      throw Exception("Block not found");
    }

    final res = await AsyncRequest.handle<BlockModel>(() async {
      logger.i('updating block with id $blockId');
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final result = await threadApi.updateBlocksIdPut(
        id: blockId,
        threadTitle: thread.title,
        updateBlockModel: UpdateBlockModel(
          content: content,
        ),
      );
      return result.data!;
    });
    return res.fold((l) {
      throw Exception(l.message);
    }, (r) {
      final map = block.toJson()
        ..putIfAbsent("content", () => content)
        ..update("content", (value) => content);

      final updatedBlock = BlockWithCreator.fromJson(map);
      final updatedBlocks = thread.content?.map((e) {
        if (e.id == blockId) {
          return updatedBlock;
        }
        return e;
      }).toList();
      final updatedThreadModel = FullThreadInfo(
        title: thread.title,
        type: thread.type,
        content: updatedBlocks!,
        creator: thread.creator,
        id: thread.id,
        defaultBlock: thread.defaultBlock,
        createdDate: thread.createdDate,
      );
      state = AsyncValue.data(
        CurrentTreadState.result(
            blocks: updatedBlocks, thread: updatedThreadModel),
      );
    });
  }

  Future<void> updateThreadTitle(String title) async {
    final thread = state.value?.thread;
    if (thread == null) {
      logger.e("There is no thread to update title");
      return;
    }
    final res = await AsyncRequest.handle<FullThreadInfo>(() async {
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final result = await threadApi.updateThThreadsIdPut(
        id: thread.id,
        updateThreadTitleModel: UpdateThreadTitleModel(title: title),
      );
      return result.data!;
    });
    return res.fold((l) {
      throw Exception(l.message ?? "Failed to update thread title");
    }, (thread) {
      final updatedThreadModel = FullThreadInfo(
        title: title,
        type: thread.type,
        content: thread.content,
        creator: thread.creator,
        id: thread.id,
        defaultBlock: thread.defaultBlock,
        createdDate: thread.createdDate,
      );
      state = AsyncValue.data(
        CurrentTreadState.result(
            blocks: state.value?.blocks, thread: updatedThreadModel),
      );
    });
  }

  Future<void> reorderBlocks(int oldIndex, int newIndex) async {
    final thread = state.value?.thread;
    final blocks = state.value?.blocks.getOrEmpty;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (thread == null) {
      logger.e("There is no thread to reorder blocks");
      return;
    }

    if (blocks == null || blocks.isEmpty) {
      logger.e("There are no blocks to reorder");
      return;
    }

    BlockWithCreator draggedBlock = blocks[oldIndex];

    blocks.removeAt(oldIndex);
    blocks.insert(newIndex, draggedBlock);

    blocks.asMap().forEach((index, block) {
      blocks[index] = BlockWithCreator.fromJson(block.toJson()
        ..putIfAbsent("position", () => index)
        ..update("position", (value) => index));
    });
    final updatedBlocks = blocks;

    print(updatedBlocks.map((e) => e.position).toList());
    updatedBlocks.sort((a, b) => a.position!.compareTo(b.position!));

    final updatedThreadModel = FullThreadInfo(
      title: thread.title,
      type: thread.type,
      content: updatedBlocks,
      creator: thread.creator,
      id: thread.id,
      defaultBlock: thread.defaultBlock,
      createdDate: thread.createdDate,
    );

    state = AsyncValue.data(
      CurrentTreadState.result(
        blocks: updatedBlocks,
        thread: updatedThreadModel,
      ),
    );

    final res = await AsyncRequest.handle<UpdateBlockPositionModel>(() async {
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final result = await threadApi.updateBlockPositionBlocksIdPositionPut(
          id: state.value!.thread!.id,
          updateBlockPositionModel: UpdateBlockPositionModel(
            blockId: draggedBlock.id,
            newPosition: newIndex,
          ));
      return result.data!;
    });

    res.fold(
      (l) => logger.e("Failed to reorder block", error: l.message),
      (r) {
        logger.f(
            'Reordered block with id ${r.blockId} to position ${r.newPosition}');
      },
    );
  }

  Future<FullThreadInfo?> createChildThread(
      CreateChildThreadModel createChildThreadModel) async {
    final res = await AsyncRequest.handle<FullThreadInfo>(() async {
      logger.d("Creating child thread");
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final response = await threadApi.childThreadBlocksChildPost(
        createChildThreadModel: createChildThreadModel,
      );
      if (response.statusCode == 201 || response.data != null) {
        //print(response.data);
        if (response.data != null) {
          logger.d("Child thread is created");

          List<BlockWithCreator> list = state.value?.blocks.getOrEmpty ?? [];
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
            List<BlockWithCreator> updatedBlocks = [];
            list[index] = updatedThreadModel;
            final threadInfo = state.value!.thread!.toJson();
            if (threadInfo.containsKey("content")) {
              threadInfo["content"] = list.map((e) => e.toJson()).toList();
              updatedBlocks = list;
            } else {
              threadInfo.putIfAbsent("content", () => list);
            }

            final updatedThreadModel2 = FullThreadInfo.fromJson(threadInfo);

            state = AsyncValue.data(
              CurrentTreadState.result(
                  blocks: updatedBlocks, thread: updatedThreadModel2),
            );
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
    return res.fold((l) {
      throw Exception(l.message);
    }, (r) => r);
  }
}

@freezed
class CurrentTreadState with _$CurrentTreadState {
  const factory CurrentTreadState({
    @Default([]) List<BlockWithCreator> blocks,
    FullThreadInfo? thread,
  }) = _CurrentTreadState;
  factory CurrentTreadState.initial() => const CurrentTreadState();
  factory CurrentTreadState.result({
    List<BlockWithCreator>? blocks,
    FullThreadInfo? thread,
  }) =>
      CurrentTreadState(
        blocks: blocks ?? [],
        thread: thread,
      );
}
