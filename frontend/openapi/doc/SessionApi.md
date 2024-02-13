# openapi.api.SessionApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**secureApiSessioninfoGet**](SessionApi.md#secureapisessioninfoget) | **GET** /sessioninfo | Secure Api


# **secureApiSessioninfoGet**
> SessionInfo secureApiSessioninfoGet()

Secure Api

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSessionApi();

try {
    final response = api.secureApiSessioninfoGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SessionApi->secureApiSessioninfoGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SessionInfo**](SessionInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

