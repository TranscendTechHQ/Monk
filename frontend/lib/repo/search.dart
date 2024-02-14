import 'package:frontend/network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search.g.dart';

@riverpod
Future<List<String>> queryMatchingThreads(
    QueryMatchingThreadsRef ref, String query) async {
  final threadApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await threadApi.searchTitlesSearchTitlesGet(query: query);
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch matching threads");
  }
  final results = response.data!;
  print(results);

  return results;
}

@riverpod
class QueryResults extends _$QueryResults {
  @override
  List<String> build() => [];
  void setResults(List<String> results) {
    state = results;
  }

  List<String> get() => state;
}
