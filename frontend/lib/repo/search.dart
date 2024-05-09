import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search.g.dart';

@riverpod
Future<List<String>> queryMatchingThreads(
    QueryMatchingThreadsRef ref, String query) async {
  final res = await AsyncRequest.handle<List<String>>(() async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final response = await threadApi.searchTitlesSearchTitlesGet(query: query);
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch matching threads");
    }
    final results = response.data!;
    return results;
  });

  return res.fold(
    (l) {
      logger.e(l.message);
      return [];
    },
    (r) => r,
  );
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
