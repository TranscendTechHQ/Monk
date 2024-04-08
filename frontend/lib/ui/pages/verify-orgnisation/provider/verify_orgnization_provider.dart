import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verify_orgnization_provider.g.dart';

@riverpod
class VerifyOrganization extends _$VerifyOrganization {
  @override
  Future<bool> build({required String teamId}) async {
    return await Future.delayed(const Duration(seconds: 2), () {
      return true;
    });
  }
}
