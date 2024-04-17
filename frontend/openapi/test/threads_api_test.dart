import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ThreadsApi
void main() {
  final instance = Openapi().getThreadsApi();

  group(ThreadsApi, () {
    // At
    //
    //Future<List<ThreadsModel>> atAllThreadsGet() async
    test('test atAllThreadsGet', () async {
      // TODO
    });

    // Child Thread
    //
    //Future<ThreadModel> childThreadBlocksChildPost(CreateChildThreadModel createChildThreadModel) async
    test('test childThreadBlocksChildPost', () async {
      // TODO
    });

    // Create
    //
    //Future<ThreadModel> createBlocksPost(String threadTitle, UpdateBlockModel updateBlockModel) async
    test('test createBlocksPost', () async {
      // TODO
    });

    // Create Th
    //
    //Future<ThreadModel> createThThreadsPost(CreateThreadModel createThreadModel) async
    test('test createThThreadsPost', () async {
      // TODO
    });

    // Date
    //
    //Future<BlockCollection> dateJournalGet(ModelDate modelDate) async
    test('test dateJournalGet', () async {
      // TODO
    });

    // Get Blocks By Date
    //
    //Future<BlockCollection> getBlocksByDateBlocksDateGet(ModelDate modelDate) async
    test('test getBlocksByDateBlocksDateGet', () async {
      // TODO
    });

    // Get Thread Id
    //
    //Future<ThreadModel> getThreadIdThreadsIdGet(String id) async
    test('test getThreadIdThreadsIdGet', () async {
      // TODO
    });

    // Get Thread
    //
    //Future<ThreadModel> getThreadThreadsTitleGet(String title) async
    test('test getThreadThreadsTitleGet', () async {
      // TODO
    });

    // Md
    //
    //Future<ThreadsMetaData> mdMetadataGet() async
    test('test mdMetadataGet', () async {
      // TODO
    });

    // Search Threads
    //
    //Future<ThreadsModel> searchThreadsSearchThreadsGet(String query) async
    test('test searchThreadsSearchThreadsGet', () async {
      // TODO
    });

    // Search Titles
    //
    //Future<List<String>> searchTitlesSearchTitlesGet(String query) async
    test('test searchTitlesSearchTitlesGet', () async {
      // TODO
    });

    // Th
    //
    //Future<ThreadHeadlinesModel> thThreadHeadlinesGet() async
    test('test thThreadHeadlinesGet', () async {
      // TODO
    });

    // Ti
    //
    //Future<ThreadsInfo> tiThreadsInfoGet() async
    test('test tiThreadsInfoGet', () async {
      // TODO
    });

    // Tt
    //
    //Future<List<String>> ttThreadTypesGet() async
    test('test ttThreadTypesGet', () async {
      // TODO
    });

    // Update
    //
    //Future<ThreadModel> updateBlocksPut(String threadTitle, UpdateBlockModel updateBlockModel) async
    test('test updateBlocksPut', () async {
      // TODO
    });

    // Update Th
    //
    //Future<ThreadModel> updateThThreadsIdPut(String id, CreateThreadModel createThreadModel) async
    test('test updateThThreadsIdPut', () async {
      // TODO
    });

  });
}
