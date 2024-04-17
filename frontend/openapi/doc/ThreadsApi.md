# openapi.api.ThreadsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**atAllThreadsGet**](ThreadsApi.md#atallthreadsget) | **GET** /allThreads | At
[**childThreadBlocksChildPost**](ThreadsApi.md#childthreadblockschildpost) | **POST** /blocks/child | Child Thread
[**createBlocksPost**](ThreadsApi.md#createblockspost) | **POST** /blocks | Create
[**createThThreadsPost**](ThreadsApi.md#createththreadspost) | **POST** /threads | Create Th
[**dateJournalGet**](ThreadsApi.md#datejournalget) | **GET** /journal | Date
[**getBlocksByDateBlocksDateGet**](ThreadsApi.md#getblocksbydateblocksdateget) | **GET** /blocksDate | Get Blocks By Date
[**getThreadIdThreadsIdGet**](ThreadsApi.md#getthreadidthreadsidget) | **GET** /threads/{id} | Get Thread Id
[**getThreadThreadsTitleGet**](ThreadsApi.md#getthreadthreadstitleget) | **GET** /threads/{title} | Get Thread
[**mdMetadataGet**](ThreadsApi.md#mdmetadataget) | **GET** /metadata | Md
[**searchThreadsSearchThreadsGet**](ThreadsApi.md#searchthreadssearchthreadsget) | **GET** /searchThreads | Search Threads
[**searchTitlesSearchTitlesGet**](ThreadsApi.md#searchtitlessearchtitlesget) | **GET** /searchTitles | Search Titles
[**thThreadHeadlinesGet**](ThreadsApi.md#ththreadheadlinesget) | **GET** /threadHeadlines | Th
[**tiThreadsInfoGet**](ThreadsApi.md#tithreadsinfoget) | **GET** /threadsInfo | Ti
[**ttThreadTypesGet**](ThreadsApi.md#ttthreadtypesget) | **GET** /threadTypes | Tt
[**updateBlocksPut**](ThreadsApi.md#updateblocksput) | **PUT** /blocks | Update
[**updateThThreadsIdPut**](ThreadsApi.md#updateththreadsidput) | **PUT** /threads/{id} | Update Th


# **atAllThreadsGet**
> List<ThreadsModel> atAllThreadsGet()

At

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.atAllThreadsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->atAllThreadsGet: $e\n');
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

# **dateJournalGet**
> BlockCollection dateJournalGet(modelDate)

Date

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final ModelDate modelDate = ; // ModelDate | 

try {
    final response = api.dateJournalGet(modelDate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->dateJournalGet: $e\n');
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

# **getBlocksByDateBlocksDateGet**
> BlockCollection getBlocksByDateBlocksDateGet(modelDate)

Get Blocks By Date

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final ModelDate modelDate = ; // ModelDate | 

try {
    final response = api.getBlocksByDateBlocksDateGet(modelDate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->getBlocksByDateBlocksDateGet: $e\n');
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

# **mdMetadataGet**
> ThreadsMetaData mdMetadataGet()

Md

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.mdMetadataGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->mdMetadataGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ThreadsMetaData**](ThreadsMetaData.md)

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

# **thThreadHeadlinesGet**
> ThreadHeadlinesModel thThreadHeadlinesGet()

Th

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.thThreadHeadlinesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->thThreadHeadlinesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ThreadHeadlinesModel**](ThreadHeadlinesModel.md)

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

# **updateBlocksPut**
> ThreadModel updateBlocksPut(threadTitle, updateBlockModel)

Update

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String threadTitle = threadTitle_example; // String | 
final UpdateBlockModel updateBlockModel = ; // UpdateBlockModel | 

try {
    final response = api.updateBlocksPut(threadTitle, updateBlockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateBlocksPut: $e\n');
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

# **updateThThreadsIdPut**
> ThreadModel updateThThreadsIdPut(id, createThreadModel)

Update Th

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final CreateThreadModel createThreadModel = ; // CreateThreadModel | 

try {
    final response = api.updateThThreadsIdPut(id, createThreadModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateThThreadsIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **createThreadModel** | [**CreateThreadModel**](CreateThreadModel.md)|  | 

### Return type

[**ThreadModel**](ThreadModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

