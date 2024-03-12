import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_provider.g.dart';

@riverpod
Future<List<ThreadHeadlineModel>> fetchThreadsHeadlinesAsync(
    FetchThreadsHeadlinesAsyncRef ref) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.thThreadHeadlinesGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch titles");
  }
  return response.data!.headlines;
}

@riverpod
Future<List<ThreadMetaData>> fetchThreadsMdMetaDataAsync(
    FetchThreadsMdMetaDataAsyncRef ref) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.mdMetadataGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch titles");
  }
  return response.data!.metadata;
}
