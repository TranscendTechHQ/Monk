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
  ThreadModel build(
      {String title = "", String type = "", String creator = ""}) {
    return ThreadModel(title: title, type: type, creator: creator);
  }

  Future<ThreadModel> createBlock(String text) async {
    String threadTitle = state.title;
    final blockApi = NetworkManager.instance.openApi.getThreadsApi();

    final newThreadState = await blockApi.createBlocksPost(
        threadTitle: threadTitle,
        updateBlockModel: UpdateBlockModel(content: text));

    if (newThreadState.statusCode != 201) {
      throw Exception("Failed to create block");
    }

    state = newThreadState.data!;
    return state;
  }

  Future<ThreadModel> createOrGetThread(String title, String type) async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();

    final response = await threadApi.createThreadThreadsPost(
        createThreadModel: CreateThreadModel(title: title, type: type));

    if (response.statusCode != 201) {
      throw Exception("Failed to create thread");
    }
    state = response.data!;
    return state;
  }

  Future<ThreadModel> getThread(String title) async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();

    final response = await threadApi.getThreadThreadsTitleGet(title: title);

    if (response.statusCode != 200) {
      throw Exception("Failed to get thread");
    }
    state = response.data!;
    return state;
  }

  List<String> getBlocks() {
    final blocks =
        state.content?.map((e) => e.content).toList().reversed.toList();
    return blocks ?? [];
  }
}
