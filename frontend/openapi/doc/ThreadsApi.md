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
[**deleteThreadThreadsIdDelete**](ThreadsApi.md#deletethreadthreadsiddelete) | **DELETE** /threads/{id} | Delete Thread
[**filterNewsfeedGet**](ThreadsApi.md#filternewsfeedget) | **GET** /newsfeed | Filter
[**getThreadIdThreadsIdGet**](ThreadsApi.md#getthreadidthreadsidget) | **GET** /threads/{id} | Get Thread Id
[**getUserFilterPreferencesUserNewsFilterGet**](ThreadsApi.md#getuserfilterpreferencesusernewsfilterget) | **GET** /user/news-filter | Get User Filter Preferences
[**searchThreadsSearchThreadsGet**](ThreadsApi.md#searchthreadssearchthreadsget) | **GET** /searchThreads | Search Threads
[**searchTitlesSearchTitlesGet**](ThreadsApi.md#searchtitlessearchtitlesget) | **GET** /searchTitles | Search Titles
[**tiThreadsInfoGet**](ThreadsApi.md#tithreadsinfoget) | **GET** /threadsInfo | Ti
[**ttThreadTypesGet**](ThreadsApi.md#ttthreadtypesget) | **GET** /threadTypes | Tt
[**updateBlockAssignedUserBlocksIdAssignPut**](ThreadsApi.md#updateblockassigneduserblocksidassignput) | **PUT** /blocks/{id}/assign | Update Block Assigned User
[**updateBlockDueDateBlocksIdDueDatePut**](ThreadsApi.md#updateblockduedateblocksidduedateput) | **PUT** /blocks/{id}/dueDate | Update Block Due Date
[**updateBlockPositionBlocksIdPositionPut**](ThreadsApi.md#updateblockpositionblocksidpositionput) | **PUT** /blocks/{id}/position | Update Block Position
[**updateBlockTaskStatusBlocksIdTaskStatusPut**](ThreadsApi.md#updateblocktaskstatusblocksidtaskstatusput) | **PUT** /blocks/{id}/taskStatus | Update Block Task Status
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
> FullThreadInfo childThreadBlocksChildPost(createChildThreadModel)

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

[**FullThreadInfo**](FullThreadInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createBlocksPost**
> BlockWithCreator createBlocksPost(threadTopic, createBlockModel)

Create

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String threadTopic = threadTopic_example; // String | 
final CreateBlockModel createBlockModel = ; // CreateBlockModel | 

try {
    final response = api.createBlocksPost(threadTopic, createBlockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->createBlocksPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **threadTopic** | **String**|  | 
 **createBlockModel** | [**CreateBlockModel**](CreateBlockModel.md)|  | 

### Return type

[**BlockWithCreator**](BlockWithCreator.md)

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
> FullThreadInfo createThThreadsPost(createThreadModel)

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

[**FullThreadInfo**](FullThreadInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteThreadThreadsIdDelete**
> bool deleteThreadThreadsIdDelete(id)

Delete Thread

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 

try {
    final response = api.deleteThreadThreadsIdDelete(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->deleteThreadThreadsIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filterNewsfeedGet**
> ThreadsMetaData filterNewsfeedGet(bookmark, unread, unfollow, upvote, mention, searchQuery, updateFilter, updateSemanticFilter)

Filter

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final bool bookmark = true; // bool | 
final bool unread = true; // bool | 
final bool unfollow = true; // bool | 
final bool upvote = true; // bool | 
final bool mention = true; // bool | 
final String searchQuery = searchQuery_example; // String | 
final bool updateFilter = true; // bool | 
final bool updateSemanticFilter = true; // bool | 

try {
    final response = api.filterNewsfeedGet(bookmark, unread, unfollow, upvote, mention, searchQuery, updateFilter, updateSemanticFilter);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->filterNewsfeedGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookmark** | **bool**|  | [optional] [default to false]
 **unread** | **bool**|  | [optional] [default to false]
 **unfollow** | **bool**|  | [optional] [default to false]
 **upvote** | **bool**|  | [optional] [default to false]
 **mention** | **bool**|  | [optional] [default to false]
 **searchQuery** | **String**|  | [optional] 
 **updateFilter** | **bool**|  | [optional] [default to false]
 **updateSemanticFilter** | **bool**|  | [optional] [default to false]

### Return type

[**ThreadsMetaData**](ThreadsMetaData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getThreadIdThreadsIdGet**
> FullThreadInfo getThreadIdThreadsIdGet(id)

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

[**FullThreadInfo**](FullThreadInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserFilterPreferencesUserNewsFilterGet**
> UserFilterPreferenceModel getUserFilterPreferencesUserNewsFilterGet()

Get User Filter Preferences

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();

try {
    final response = api.getUserFilterPreferencesUserNewsFilterGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->getUserFilterPreferencesUserNewsFilterGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserFilterPreferenceModel**](UserFilterPreferenceModel.md)

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

# **updateBlockAssignedUserBlocksIdAssignPut**
> BlockWithCreator updateBlockAssignedUserBlocksIdAssignPut(id, body)

Update Block Assigned User

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final String body = body_example; // String | 

try {
    final response = api.updateBlockAssignedUserBlocksIdAssignPut(id, body);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateBlockAssignedUserBlocksIdAssignPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | **String**|  | 

### Return type

[**BlockWithCreator**](BlockWithCreator.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBlockDueDateBlocksIdDueDatePut**
> BlockWithCreator updateBlockDueDateBlocksIdDueDatePut(id, body)

Update Block Due Date

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final String body = body_example; // String | 

try {
    final response = api.updateBlockDueDateBlocksIdDueDatePut(id, body);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateBlockDueDateBlocksIdDueDatePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | **String**|  | 

### Return type

[**BlockWithCreator**](BlockWithCreator.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBlockPositionBlocksIdPositionPut**
> UpdateBlockPositionModel updateBlockPositionBlocksIdPositionPut(id, updateBlockPositionModel)

Update Block Position

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final UpdateBlockPositionModel updateBlockPositionModel = ; // UpdateBlockPositionModel | 

try {
    final response = api.updateBlockPositionBlocksIdPositionPut(id, updateBlockPositionModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateBlockPositionBlocksIdPositionPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateBlockPositionModel** | [**UpdateBlockPositionModel**](UpdateBlockPositionModel.md)|  | 

### Return type

[**UpdateBlockPositionModel**](UpdateBlockPositionModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBlockTaskStatusBlocksIdTaskStatusPut**
> BlockWithCreator updateBlockTaskStatusBlocksIdTaskStatusPut(id, body)

Update Block Task Status

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final String body = body_example; // String | 

try {
    final response = api.updateBlockTaskStatusBlocksIdTaskStatusPut(id, body);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateBlockTaskStatusBlocksIdTaskStatusPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | **String**|  | 

### Return type

[**BlockWithCreator**](BlockWithCreator.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBlocksIdPut**
> BlockModel updateBlocksIdPut(id, threadTopic, updateBlockModel)

Update

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getThreadsApi();
final String id = id_example; // String | 
final String threadTopic = threadTopic_example; // String | 
final UpdateBlockModel updateBlockModel = ; // UpdateBlockModel | 

try {
    final response = api.updateBlocksIdPut(id, threadTopic, updateBlockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ThreadsApi->updateBlocksIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **threadTopic** | **String**|  | 
 **updateBlockModel** | [**UpdateBlockModel**](UpdateBlockModel.md)|  | 

### Return type

[**BlockModel**](BlockModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateThThreadsIdPut**
> FullThreadInfo updateThThreadsIdPut(id, updateThreadTitleModel)

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

[**FullThreadInfo**](FullThreadInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

