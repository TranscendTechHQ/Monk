# openapi.api.SlackApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chChannelListGet**](SlackApi.md#chchannellistget) | **GET** /channel_list | Ch
[**publicChannelsPublicChannelsGet**](SlackApi.md#publicchannelspublicchannelsget) | **GET** /public_channels | Public Channels
[**subscribeChannelSubscribeChannelPost**](SlackApi.md#subscribechannelsubscribechannelpost) | **POST** /subscribe_channel | Subscribe Channel


# **chChannelListGet**
> CompositeChannelList chChannelListGet()

Ch

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSlackApi();

try {
    final response = api.chChannelListGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SlackApi->chChannelListGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CompositeChannelList**](CompositeChannelList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicChannelsPublicChannelsGet**
> PublicChannelList publicChannelsPublicChannelsGet()

Public Channels

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSlackApi();

try {
    final response = api.publicChannelsPublicChannelsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SlackApi->publicChannelsPublicChannelsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PublicChannelList**](PublicChannelList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscribeChannelSubscribeChannelPost**
> SubscribedChannelList subscribeChannelSubscribeChannelPost(subscribeChannelRequest)

Subscribe Channel

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSlackApi();
final SubscribeChannelRequest subscribeChannelRequest = ; // SubscribeChannelRequest | 

try {
    final response = api.subscribeChannelSubscribeChannelPost(subscribeChannelRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SlackApi->subscribeChannelSubscribeChannelPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscribeChannelRequest** | [**SubscribeChannelRequest**](SubscribeChannelRequest.md)|  | 

### Return type

[**SubscribedChannelList**](SubscribedChannelList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

