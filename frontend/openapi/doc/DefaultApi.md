# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getLinkMetaLinkmetaGet**](DefaultApi.md#getlinkmetalinkmetaget) | **GET** /linkmeta | Get Link Meta
[**healthcheckHealthcheckGet**](DefaultApi.md#healthcheckhealthcheckget) | **GET** /healthcheck | Healthcheck
[**slackUserTokenSlackUserTokenPost**](DefaultApi.md#slackusertokenslackusertokenpost) | **POST** /slack_user_token | Slack User Token


# **getLinkMetaLinkmetaGet**
> Object getLinkMetaLinkmetaGet(url)

Get Link Meta

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String url = url_example; // String | 

try {
    final response = api.getLinkMetaLinkmetaGet(url);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->getLinkMetaLinkmetaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**|  | 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthcheckHealthcheckGet**
> Object healthcheckHealthcheckGet()

Healthcheck

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    final response = api.healthcheckHealthcheckGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->healthcheckHealthcheckGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **slackUserTokenSlackUserTokenPost**
> Object slackUserTokenSlackUserTokenPost(authcode)

Slack User Token

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String authcode = authcode_example; // String | 

try {
    final response = api.slackUserTokenSlackUserTokenPost(authcode);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->slackUserTokenSlackUserTokenPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authcode** | **String**|  | 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

