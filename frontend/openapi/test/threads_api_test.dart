import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ThreadsApi
void main() {
  final instance = Openapi().getThreadsApi();

  group(ThreadsApi, () {
    // All Users
    //
    //Future<UserMap> allUsersUserGet() async
    test('test allUsersUserGet', () async {
      // TODO
    });

    // Child Thread
    //
    //Future<FullThreadInfo> childThreadBlocksChildPost(CreateChildThreadModel createChildThreadModel) async
    test('test childThreadBlocksChildPost', () async {
      // TODO
    });

    // Create
    //
    //Future<BlockWithCreator> createBlocksPost(String threadTitle, CreateBlockModel createBlockModel) async
    test('test createBlocksPost', () async {
      // TODO
    });

    // Create Tf
    //
    //Future<UserThreadFlagModel> createTfThreadFlagPost(CreateUserThreadFlagModel createUserThreadFlagModel) async
    test('test createTfThreadFlagPost', () async {
      // TODO
    });

    // Create Th
    //
    //Future<FullThreadInfo> createThThreadsPost(CreateThreadModel createThreadModel) async
    test('test createThThreadsPost', () async {
      // TODO
    });

    // Filter
    //
    //Future<ThreadsMetaData> filterNewsfeedGet({ bool bookmark, bool read, bool unfollow, bool upvote }) async
    test('test filterNewsfeedGet', () async {
      // TODO
    });

    // Get Thread Id
    //
    //Future<FullThreadInfo> getThreadIdThreadsIdGet(String id) async
    test('test getThreadIdThreadsIdGet', () async {
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

    // Update Block Position
    //
    //Future<UpdateBlockPositionModel> updateBlockPositionBlocksIdPositionPut(String id, UpdateBlockPositionModel updateBlockPositionModel) async
    test('test updateBlockPositionBlocksIdPositionPut', () async {
      // TODO
    });

    // Update
    //
    //Future<BlockModel> updateBlocksIdPut(String id, String threadTitle, UpdateBlockModel updateBlockModel) async
    test('test updateBlocksIdPut', () async {
      // TODO
    });

    // Update Th
    //
    //Future<FullThreadInfo> updateThThreadsIdPut(String id, UpdateThreadTitleModel updateThreadTitleModel) async
    test('test updateThThreadsIdPut', () async {
      // TODO
    });

  });
}
