import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'thread_detail_provider.freezed.dart';
part 'thread_detail_provider.g.dart';

// @riverpod
// Future<Map<String, String>> fetchThreadDetailAsync(fetchThreadDetailAsyncRef ref) async {
//   final threadApi = NetworkManager.instance.openApi.getThreadsApi();
//   final response = await threadApi.tiThreadsInfoGet();
//   if (response.statusCode != 200) {
//     throw Exception("Failed to fetch titles");
//   }
//   return response.data!.info!;
// }

@riverpod
class ThreadDetail extends _$ThreadDetail {
  @override
  Future<ThreadDetailState> build(
      {required String threadId, BlockModel? block}) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    return ThreadDetailState.result(block: block, replies: [
      block!,
      block,
      block,
      block,
      block,
      block,
      block,
      block,
      block,
      block
    ]);
  }
}

@freezed
class ThreadDetailState with _$ThreadDetailState {
  const factory ThreadDetailState({
    required BlockModel? block,
    required List<BlockModel> replies,
  }) = _ThreadDetailState;
  factory ThreadDetailState.initial({BlockModel? block}) =>
      ThreadDetailState(block: block, replies: []);
  factory ThreadDetailState.result(
          {BlockModel? block, required List<BlockModel> replies}) =>
      ThreadDetailState(block: block, replies: replies);
}
