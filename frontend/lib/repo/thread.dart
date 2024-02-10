// this is a @riverpod generated notifer that maintains state for a thread.
// a thread is a collection of blocks that are related to each other.
// thread encapsulated BlockCollection datamodel

// a riverpod provider that stores the content of a single day's journal entry
// this entry can be accessed from anywhere in the app and also be sent to the
// backend.
//  - the backend will store the journal entry in the database
// ...

import 'package:frontend/network.dart';
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

Future<ThreadModel> createOrGetThread(
    {required String title, required String type}) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();

  final response = await threadApi.createThreadsPost(
      createThreadModel: CreateThreadModel(title: title, type: type));

  if (response.statusCode != 201) {
    throw Exception("Failed to create thread");
  }
  return response.data!;
}

/*
Future<BlockCollection> journalBlocksDate(DateTime date) async {
  final blockApi = NetworkManager.instance.openApi.getThreadsApi();

  //final modelDate = ModelDate(date: date.toIso8601String());
  final modelDate = ModelDate(date: date);

  final response =
      await blockApi.getJournalByDateJournalGet(modelDate: modelDate);

  if (response.statusCode == 200) {
    final blocks = response.data!;
    return blocks;
  } else {
    return BlockCollection.fromJson({"blocks": []});
  }
}

  FutureOr<void> initialize() async {
    DateTime today = DateTime.now();
    BlockCollection blocksCollection = await journalBlocksDate(today);
    List<String> stringBlocks = [];

    state = const AsyncValue.data([]);
    blocksCollection.toJson().forEach((key, value) {
      value.forEach((element) {
        stringBlocks.add(element['content']);
      });
    });
    Iterable<String> inReverse = stringBlocks.reversed;
    state = AsyncValue.data(inReverse.toList());
  }
*/

@riverpod
class CurrentThread extends _$CurrentThread {
  @override
  Future<ThreadModel> build(
      {required String title, required String type}) async {
    state = const AsyncValue.loading();
    final response = await createOrGetThread(title: title, type: type);
    state = AsyncValue.data(response);
    return state.value!;
  }

  Future<ThreadModel> createBlock(String text) async {
    String threadTitle = state.value!.title;
    final blockApi = NetworkManager.instance.openApi.getThreadsApi();

    final newThreadState = await blockApi.createBlocksPost(
        threadTitle: threadTitle,
        updateBlockModel: UpdateBlockModel(content: text));

    if (newThreadState.statusCode != 201) {
      throw Exception("Failed to create block");
    }

    state = AsyncValue.data(newThreadState.data!);
    return state.value!;
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

  List<String> getBlocks() {
    final blocks =
        state.value?.content?.map((e) => e.content).toList().reversed.toList();
    return blocks ?? [];
  }
}
