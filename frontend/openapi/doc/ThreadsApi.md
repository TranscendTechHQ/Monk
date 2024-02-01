# openapi.api.ThreadsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createBlockBlocksPost**](ThreadsApi.md#createblockblockspost) | **POST** /blocks | Create Block
[**createThreadThreadsPost**](ThreadsApi.md#createthreadthreadspost) | **POST** /threads | Create Thread
[**getAllThreadsThreadsGet**](ThreadsApi.md#getallthreadsthreadsget) | **GET** /threads | Get All Threads
[**getBlocksByDateBlocksGet**](ThreadsApi.md#getblocksbydateblocksget) | **GET** /blocks | Get Blocks By Date
[**getThreadThreadsTitleGet**](ThreadsApi.md#getthreadthreadstitleget) | **GET** /threads/{title} | Get Thread
[**updateThreadThreadsTitlePut**](ThreadsApi.md#updatethreadthreadstitleput) | **PUT** /threads/{title} | Update Thread


# **createBlockBlocksPost**
> BlockModel createBlockBlocksPost(updateBlockModel)

Create Block

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final UpdateBlockModel updateBlockModel = ; // UpdateBlockModel | 

try {
    final response = api.createBlockBlocksPost(updateBlockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->createBlockBlocksPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateBlockModel** | [**UpdateBlockModel**](UpdateBlockModel.md)|  | 

### Return type

[**BlockModel**](BlockModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createThreadThreadsPost**
> ThreadModel createThreadThreadsPost(createThreadModel)

Create Thread

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final CreateThreadModel createThreadModel = ; // CreateThreadModel | 

try {
    final response = api.createThreadThreadsPost(createThreadModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->createThreadThreadsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createThreadModel** | [**CreateThreadModel**](CreateThreadModel.md)|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllThreadsThreadsGet**
> List<ThreadsModel> getAllThreadsThreadsGet()

Get All Threads

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.getAllThreadsThreadsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->getAllThreadsThreadsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;ThreadsModel&gt;**](ThreadsModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBlocksByDateBlocksGet**
> BlockCollection getBlocksByDateBlocksGet(modelDate)

Get Blocks By Date

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final ModelDate modelDate = ; // ModelDate | 

try {
    final response = api.getBlocksByDateBlocksGet(modelDate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->getBlocksByDateBlocksGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **modelDate** | [**ModelDate**](ModelDate.md)|  | 

### Return type

[**BlockCollection**](BlockCollection.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getThreadThreadsTitleGet**
> ThreadModel getThreadThreadsTitleGet(title)

Get Thread

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String title = title_example; // String | 

try {
    final response = api.getThreadThreadsTitleGet(title);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->getThreadThreadsTitleGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **title** | **String**|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateThreadThreadsTitlePut**
> ThreadModel updateThreadThreadsTitlePut(title, updateThreadModel)

Update Thread

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String title = title_example; // String | 
final UpdateThreadModel updateThreadModel = ; // UpdateThreadModel | 

try {
    final response = api.updateThreadThreadsTitlePut(title, updateThreadModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateThreadThreadsTitlePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **title** | **String**|  | 
 **updateThreadModel** | [**UpdateThreadModel**](UpdateThreadModel.md)|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

