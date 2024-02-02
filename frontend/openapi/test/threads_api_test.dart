import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ThreadsApi
void main() {
  final instance = Openapi().getThreadsApi();

  group(ThreadsApi, () {
    // Create
    //
    //Future<ThreadModel> createBlocksPost(String threadTitle, UpdateBlockModel updateBlockModel) async
    test('test createBlocksPost', () async {
      // TODO
    });

    // Create Thread
    //
    //Future<ThreadModel> createThreadThreadsPost(CreateThreadModel createThreadModel) async
    test('test createThreadThreadsPost', () async {
      // TODO
    });

    // Get All Threads
    //
    //Future<List<ThreadsModel>> getAllThreadsThreadsGet() async
    test('test getAllThreadsThreadsGet', () async {
      // TODO
    });

    // Get Blocks By Date
    //
    //Future<BlockCollection> getBlocksByDateBlocksGet(ModelDate modelDate) async
    test('test getBlocksByDateBlocksGet', () async {
      // TODO
    });

    // Get Journal By Date
    //
    //Future<BlockCollection> getJournalByDateJournalGet(ModelDate modelDate) async
    test('test getJournalByDateJournalGet', () async {
      // TODO
    });

    // Get Thread
    //
    //Future<ThreadModel> getThreadThreadsTitleGet(String title) async
    test('test getThreadThreadsTitleGet', () async {
      // TODO
    });

    // Update Thread
    //
    //Future<ThreadModel> updateThreadThreadsTitlePut(String title, UpdateThreadModel updateThreadModel) async
    test('test updateThreadThreadsTitlePut', () async {
      // TODO
    });

  });
}
