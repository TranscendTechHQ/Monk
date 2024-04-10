import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    // Healthcheck
    //
    //Future<Object> healthcheckHealthcheckGet() async
    test('test healthcheckHealthcheckGet', () async {
      // TODO
    });

    // Slack User Token
    //
    //Future<Object> slackUserTokenSlackUserTokenPost(String authcode) async
    test('test slackUserTokenSlackUserTokenPost', () async {
      // TODO
    });

  });
}
