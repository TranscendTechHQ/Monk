import 'package:frontend/helper/network.dart';

import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
Future<UserMap> fetchUsersInfo(FetchUsersInfoRef ref) async {
  final userApi = NetworkManager.instance.openApi.getThreadsApi();
  final response = await userApi.allUsersUserGet();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch titles");
  }
  return response.data!;
}
