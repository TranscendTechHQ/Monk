import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/network.dart';
import 'package:openapi/openapi.dart';
part 'titles.g.dart';

@riverpod
Future<List<String>> fetchTitles(FetchTitlesRef ref) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.threadTitlesTitlesGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch titles");
  }
  return response.data!.titles;
}
