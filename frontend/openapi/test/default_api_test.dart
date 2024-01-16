import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    // Secure Api
    //
    //Future<Object> secureApiSessioninfoGet() async
    test('test secureApiSessioninfoGet', () async {
      // TODO
    });

  });
}
