import 'package:frontend/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocks.g.dart';

@riverpod
class Block extends _$Block {
  @override
  String build() {
    return "";
  }

  // change state
  void setState(String newState) async {
    state = newState;
    await createBlock(state);
  }

  Future<void> createBlock(String text) async {
    final blockApi = NetworkManager.instance.openApi.getBlocksApi();

    await blockApi.createBlockBlockBlocksPost(
        blockModel: BlockModel(content: text));
  }

  void clearState() {
    state = "";
  }
}
