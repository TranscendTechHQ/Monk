import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return AuthState.initial();
  }

  Future<void> getSession() async {
    state = const AuthState(state: EState.loading);
    final api = NetworkManager.instance.openApi.getSessionApi();

    final response = await api.secureApiSessioninfoGet();
    if (response.statusCode == 200) {
      final sessionInfo = response.data!;
      state =
          AuthState.result(session: sessionInfo).copyWith(state: EState.loaded);
    }
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
