import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SessionApi
void main() {
  final instance = Openapi().getSessionApi();

  group(SessionApi, () {
    // Secure Api
    //
    //Future<SessionInfo> secureApiSessioninfoGet() async
    test('test secureApiSessioninfoGet', () async {
      // TODO
    });

  });
}
