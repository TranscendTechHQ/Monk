import 'package:dio/dio.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'thread_detail_provider.freezed.dart';
part 'thread_detail_provider.g.dart';

@riverpod
class ThreadDetail extends _$ThreadDetail {
  @override
  Future<ThreadDetailState> build({
    required String childThreadId,
    CreateChildThreadModel? createChildThreadModel,
  }) async {
    if (createChildThreadModel != null) {
      return createChildThread(createChildThreadModel);
    } else {
      return fetchThreadFromIdAsync(childThreadId);
    }
  }

  Future<ThreadDetailState> fetchThreadFromIdAsync(String id) async {
    return MonkException.handle(() async {
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final response = await threadApi.getThreadIdThreadsIdGet(id: id);
      if (response.statusCode == 404) {
        throw Exception("Thread not found");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to get thread");
      }
      return ThreadDetailState.result(thread: response.data!);
    });
  }

  Future<ThreadDetailState> createChildThread(
      CreateChildThreadModel createChildThreadModel) async {
    return MonkException.handle(() async {
      state = const AsyncLoading();
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();
      final response = await threadApi.childThreadBlocksChildPost(
        createChildThreadModel: createChildThreadModel,
      );
      if (response.statusCode == 200) {
        return ThreadDetailState.result(thread: response.data!);
      } else {
        return ThreadDetailState.error("Failed to create child thread");
      }
    });
  }
}

@freezed
class ThreadDetailState with _$ThreadDetailState {
  const factory ThreadDetailState({
    String? error,
    required ThreadModel? thread,
  }) = _ThreadDetailState;
  factory ThreadDetailState.result({required ThreadModel thread}) =>
      ThreadDetailState(thread: thread);

  factory ThreadDetailState.error(String error) =>
      ThreadDetailState(thread: null, error: error);
}
