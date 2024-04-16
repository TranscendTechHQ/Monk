// this is a @riverpod generated notifer that maintains state for a thread.
// a thread is a collection of blocks that are related to each other.
// thread encapsulated BlockCollection datamodel

// a riverpod provider that stores the content of a single day's journal entry
// this entry can be accessed from anywhere in the app and also be sent to the
// backend.
//  - the backend will store the journal entry in the database
// ...

import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
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
  return response.data!.info!;
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

Future<ThreadModel> fetchThreadFromId({required String id}) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();

  final response = await threadApi.getThreadIdThreadsIdGet(id: id);

  if (response.statusCode != 200) {
    throw Exception("Failed to get thread");
  }
  return response.data!;
}

Future<ThreadModel> createOrGetThread(
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
  Future<ThreadModel?> build({
    required String title,
    required String type,
    ThreadType threadType = ThreadType.thread,
    String? threadChildId,
  }) async {
    state = const AsyncValue.loading();
    ThreadModel? thread;
    if (threadType == ThreadType.thread) {
      thread = await createOrGetThread(title: title, type: type);
    } else {
      thread = await fetchThreadFromIdAsync(threadChildId!);
    }

    state = AsyncValue.data(thread);
    return state.value;
  }

  Future<void> createBlock(String text, {String? customTitle}) async {
    String? threadTitle = state.value?.title ?? customTitle;
    if (threadTitle.isNullOrEmpty) {
      logger.e("Thread title is null");
      throw Exception("Thread title is null");
    }
    logger.d("creating new Thread title $threadTitle");
    final blockApi = NetworkManager.instance.openApi.getThreadsApi();

    final newThreadState = await blockApi.createBlocksPost(
        threadTitle: threadTitle!,
        updateBlockModel: UpdateBlockModel(content: text));

    if (newThreadState.statusCode != 201) {
      throw Exception("Failed to create block");
    }

    state = AsyncValue.data(newThreadState.data!);
    // if (state.value != null) {
    //   return state.value!;
    // }
    // return state.value;
  }

  Future<ThreadModel> getThread(String title) async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();

    final response = await threadApi.getThreadThreadsTitleGet(title: title);

    if (response.statusCode != 200) {
      throw Exception("Failed to get thread");
    }
    state = AsyncValue.data(response.data!);
    return state.value!;
  }

  Future<ThreadModel?> fetchThreadFromIdAsync(String id) async {
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

      block = BlockModel.fromJson(map);
      final newContent = thread.content?.map((e) {
        if (e.id == blockId) {
          return block!;
        }
        return e;
      }).toList();
      final updatedThreadModel = ThreadModel(
          title: thread.title,
          type: thread.type,
          content: newContent!,
          creator: thread.creator,
          id: thread.id,
          createdDate: thread.createdDate);

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
    // Mocking the update block
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

      final updatedBlock = BlockModel.fromJson(map);
      final newContent = thread.content?.map((e) {
        if (e.id == blockId) {
          return updatedBlock;
        }
        return e;
      }).toList();
      final updatedThreadModel = ThreadModel(
          title: thread.title,
          type: thread.type,
          content: newContent!,
          creator: thread.creator,
          id: thread.id,
          createdDate: thread.createdDate);

      state = AsyncValue.data(updatedThreadModel);
    } else {
      logger.e("Can't find block with id $blockId");
    }
  }

  Future<void> updateThreadTitle(String title) async {
    final thread = state.value;
    if (thread == null) {
      logger.e("There is no thread to update title");
      return;
    }

    final updatedThreadModel = ThreadModel(
      title: title,
      type: thread.type,
      content: thread.content,
      creator: thread.creator,
      id: thread.id,
      createdDate: thread.createdDate,
    );

    state = AsyncValue.data(updatedThreadModel);
  }
}
