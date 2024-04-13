import 'package:frontend/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verify_orgnization_provider.g.dart';

@riverpod
class VerifyOrganization extends _$VerifyOrganization {
  @override
  Future<bool> build({required String email}) async {
    logger.d('Verifying email: $email affiliation with the client workspace.');
    return await Future.delayed(const Duration(seconds: 1), () {
      return whiteListedEmails.contains(email);
    });
  }
}

final whiteListedEmails = [
  'suhas@zignite.io',
  'sonu.sharma045@gmail.com',
  'yksoni@gmail.com',
  'yksoni@transcendtech.io'
];
