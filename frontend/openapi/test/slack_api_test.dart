import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SlackApi
void main() {
  final instance = Openapi().getSlackApi();

  group(SlackApi, () {
    // Ch
    //
    //Future<CompositeChannelList> chChannelListGet() async
    test('test chChannelListGet', () async {
      // TODO
    });

    // Subscribe Channel
    //
    //Future<SubscribedChannelList> subscribeChannelSubscribeChannelPost(SubscribeChannelRequest subscribeChannelRequest) async
    test('test subscribeChannelSubscribeChannelPost', () async {
      // TODO
    });

  });
}
