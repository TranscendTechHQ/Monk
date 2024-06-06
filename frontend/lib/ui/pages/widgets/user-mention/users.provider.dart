import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'users.provider.g.dart';

@riverpod
class Users extends _$Users {
  @override
  Future<List<UserModel>> build() async {
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final res = await AsyncRequest.handle<List<UserModel>?>(() async {
      final result = await threadApi.allUsersUserGet();
      return result.data!.users.values.toList();
    });

    return res.fold((l) {
      return [];
    }, (r) => r!);
  }
}

@riverpod
class FilteredUser extends _$FilteredUser {
  @override
  Future<List<UserModel>> build() {
    return Future.value([]);
  }

  void updateValue(List<UserModel> users) {
    state = AsyncData(users);
    print('${users.length} user updated');
  }
}
