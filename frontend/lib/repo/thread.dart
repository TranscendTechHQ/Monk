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
class Thread extends _$Thread {
  @override
  Future<List<String>> build() async {
    state = const AsyncValue.loading();
    await initialize();
    return state.value!;
  }

  FutureOr<void> initialize() async {
    DateTime today = DateTime.now();
    BlockCollection blocksCollection = await blocks_date(today);
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

  void addString(String input) async {
    state = AsyncValue.data([input, ...state.valueOrNull!]);
  }

  Future<BlockCollection> blocks_date(DateTime date) async {
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
}
