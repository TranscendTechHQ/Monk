import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    final session = await getSession();
    return AuthState.result(session: session);
  }

  Future<SessionInfo?> getSession() async {
    final res = await AsyncRequest.handle<SessionInfo>(() async {
      final api = NetworkManager.instance.openApi.getSessionApi();

      final response = await api.secureApiSessioninfoGet();
      return response.data;
    });
    return res.fold((l) => null, (r) => r);
  }
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    SessionInfo? session,
    @Default(EState.initial) EState state,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState();
  factory AuthState.result({required SessionInfo? session}) =>
      AuthState(session: session);
}

enum EState {
  initial,
  loading,
  loaded,
  error,
}
