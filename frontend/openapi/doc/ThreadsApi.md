# openapi.api.ThreadsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**allUsersUserGet**](ThreadsApi.md#allusersuserget) | **GET** /user | All Users
[**childThreadBlocksChildPost**](ThreadsApi.md#childthreadblockschildpost) | **POST** /blocks/child | Child Thread
[**createBlocksPost**](ThreadsApi.md#createblockspost) | **POST** /blocks | Create
[**createTfThreadFlagPost**](ThreadsApi.md#createtfthreadflagpost) | **POST** /thread/flag | Create Tf
[**createThThreadsPost**](ThreadsApi.md#createththreadspost) | **POST** /threads | Create Th
[**filterNewsfeedGet**](ThreadsApi.md#filternewsfeedget) | **GET** /newsfeed | Filter
[**getThreadIdThreadsIdGet**](ThreadsApi.md#getthreadidthreadsidget) | **GET** /threads/{id} | Get Thread Id
[**getThreadThreadsTitleGet**](ThreadsApi.md#getthreadthreadstitleget) | **GET** /threads/{title} | Get Thread
[**searchThreadsSearchThreadsGet**](ThreadsApi.md#searchthreadssearchthreadsget) | **GET** /searchThreads | Search Threads
[**searchTitlesSearchTitlesGet**](ThreadsApi.md#searchtitlessearchtitlesget) | **GET** /searchTitles | Search Titles
[**tiThreadsInfoGet**](ThreadsApi.md#tithreadsinfoget) | **GET** /threadsInfo | Ti
[**ttThreadTypesGet**](ThreadsApi.md#ttthreadtypesget) | **GET** /threadTypes | Tt
[**updateBlocksIdPut**](ThreadsApi.md#updateblocksidput) | **PUT** /blocks/{id} | Update
[**updateThThreadsIdPut**](ThreadsApi.md#updateththreadsidput) | **PUT** /threads/{id} | Update Th


# **allUsersUserGet**
> UserMap allUsersUserGet()

All Users

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.allUsersUserGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->allUsersUserGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserMap**](UserMap.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **childThreadBlocksChildPost**
> ThreadModel childThreadBlocksChildPost(createChildThreadModel)

Child Thread

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final CreateChildThreadModel createChildThreadModel = ; // CreateChildThreadModel | 

try {
    final response = api.childThreadBlocksChildPost(createChildThreadModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->childThreadBlocksChildPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createChildThreadModel** | [**CreateChildThreadModel**](CreateChildThreadModel.md)|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createBlocksPost**
> ThreadModel createBlocksPost(threadTitle, updateBlockModel)

Create

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String threadTitle = threadTitle_example; // String | 
final UpdateBlockModel updateBlockModel = ; // UpdateBlockModel | 

try {
    final response = api.createBlocksPost(threadTitle, updateBlockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->createBlocksPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **threadTitle** | **String**|  | 
 **updateBlockModel** | [**UpdateBlockModel**](UpdateBlockModel.md)|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createTfThreadFlagPost**
> UserThreadFlagModel createTfThreadFlagPost(createUserThreadFlagModel)

Create Tf

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final CreateUserThreadFlagModel createUserThreadFlagModel = ; // CreateUserThreadFlagModel | 

try {
    final response = api.createTfThreadFlagPost(createUserThreadFlagModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->createTfThreadFlagPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createUserThreadFlagModel** | [**CreateUserThreadFlagModel**](CreateUserThreadFlagModel.md)|  | 

### Return type

[**UserThreadFlagModel**](UserThreadFlagModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createThThreadsPost**
> ThreadModel createThThreadsPost(createThreadModel)

Create Th

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final CreateThreadModel createThreadModel = ; // CreateThreadModel | 

try {
    final response = api.createThThreadsPost(createThreadModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->createThThreadsPost: $e\n');
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

# **filterNewsfeedGet**
> ThreadsMetaData filterNewsfeedGet(bookmark, read, unfollow, upvote)

Filter

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final bool bookmark = true; // bool | 
final bool read = true; // bool | 
final bool unfollow = true; // bool | 
final bool upvote = true; // bool | 

try {
    final response = api.filterNewsfeedGet(bookmark, read, unfollow, upvote);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->filterNewsfeedGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookmark** | **bool**|  | [optional] [default to false]
 **read** | **bool**|  | [optional] [default to false]
 **unfollow** | **bool**|  | [optional] [default to false]
 **upvote** | **bool**|  | [optional] [default to false]

### Return type

[**ThreadsMetaData**](ThreadsMetaData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getThreadIdThreadsIdGet**
> ThreadModel getThreadIdThreadsIdGet(id)

Get Thread Id

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 

try {
    final response = api.getThreadIdThreadsIdGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->getThreadIdThreadsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
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

# **searchThreadsSearchThreadsGet**
> ThreadsModel searchThreadsSearchThreadsGet(query)

Search Threads

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String query = query_example; // String | 

try {
    final response = api.searchThreadsSearchThreadsGet(query);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->searchThreadsSearchThreadsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 

### Return type

[**ThreadsModel**](ThreadsModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchTitlesSearchTitlesGet**
> List<String> searchTitlesSearchTitlesGet(query)

Search Titles

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String query = query_example; // String | 

try {
    final response = api.searchTitlesSearchTitlesGet(query);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->searchTitlesSearchTitlesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tiThreadsInfoGet**
> ThreadsInfo tiThreadsInfoGet()

Ti

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.tiThreadsInfoGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->tiThreadsInfoGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ThreadsInfo**](ThreadsInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ttThreadTypesGet**
> List<String> ttThreadTypesGet()

Tt

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.ttThreadTypesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->ttThreadTypesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBlocksIdPut**
> ThreadModel updateBlocksIdPut(id, threadTitle, updateBlockModel)

Update

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final String threadTitle = threadTitle_example; // String | 
final UpdateBlockModel updateBlockModel = ; // UpdateBlockModel | 

try {
    final response = api.updateBlocksIdPut(id, threadTitle, updateBlockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateBlocksIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **threadTitle** | **String**|  | 
 **updateBlockModel** | [**UpdateBlockModel**](UpdateBlockModel.md)|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateThThreadsIdPut**
> ThreadModel updateThThreadsIdPut(id, updateThreadTitleModel)

Update Th

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final UpdateThreadTitleModel updateThreadTitleModel = ; // UpdateThreadTitleModel | 

try {
    final response = api.updateThThreadsIdPut(id, updateThreadTitleModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateThThreadsIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateThreadTitleModel** | [**UpdateThreadTitleModel**](UpdateThreadTitleModel.md)|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

