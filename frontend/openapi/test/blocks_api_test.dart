import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for BlocksApi
void main() {
  final instance = Openapi().getBlocksApi();

  group(BlocksApi, () {
    // Create Block
    //
    //Future<BlockModel> createBlockBlockBlocksPost(BlockModel blockModel) async
    test('test createBlockBlockBlocksPost', () async {
      // TODO
    });

    // Delete Block
    //
    //Future<JsonObject> deleteBlockBlockBlocksBlockIdDelete(JsonObject blockId) async
    test('test deleteBlockBlockBlocksBlockIdDelete', () async {
      // TODO
    });

    // Get Block
    //
    //Future<BlockModel> getBlockBlockBlocksBlockIdGet(JsonObject blockId) async
    test('test getBlockBlockBlocksBlockIdGet', () async {
      // TODO
    });

    // Get Blocks
    //
    //Future<BlockCollection> getBlocksBlockBlocksGet(JsonObject blockId) async
    test('test getBlocksBlockBlocksGet', () async {
      // TODO
    });

    // Update Block
    //
    //Future<BlockModel> updateBlockBlockBlocksBlockIdPut(JsonObject blockId, UpdateBlockModel updateBlockModel) async
    test('test updateBlockBlockBlocksBlockIdPut', () async {
      // TODO
    });

  });
}
