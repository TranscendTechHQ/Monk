# openapi.api.TasksApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createTaskTaskPost**](TasksApi.md#createtasktaskpost) | **POST** /task/ | Create Task
[**deleteTaskTaskIdDelete**](TasksApi.md#deletetasktaskiddelete) | **DELETE** /task/{id} | Delete Task
[**listTasksTaskGet**](TasksApi.md#listtaskstaskget) | **GET** /task/ | List Tasks
[**showTaskTaskIdGet**](TasksApi.md#showtasktaskidget) | **GET** /task/{id} | Show Task
[**updateTaskTaskIdPut**](TasksApi.md#updatetasktaskidput) | **PUT** /task/{id} | Update Task


# **createTaskTaskPost**
> TaskModel createTaskTaskPost(taskModel)

Create Task

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();
final TaskModel taskModel = ; // TaskModel | 

try {
    final response = api.createTaskTaskPost(taskModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->createTaskTaskPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **taskModel** | [**TaskModel**](TaskModel.md)|  | 

### Return type

[**TaskModel**](TaskModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteTaskTaskIdDelete**
> Object deleteTaskTaskIdDelete(id)

Delete Task

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();
final String id = id_example; // String | 

try {
    final response = api.deleteTaskTaskIdDelete(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->deleteTaskTaskIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTasksTaskGet**
> List<TaskModel> listTasksTaskGet()

List Tasks

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();

try {
    final response = api.listTasksTaskGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->listTasksTaskGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;TaskModel&gt;**](TaskModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **showTaskTaskIdGet**
> TaskModel showTaskTaskIdGet(id)

Show Task

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();
final String id = id_example; // String | 

try {
    final response = api.showTaskTaskIdGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->showTaskTaskIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**TaskModel**](TaskModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTaskTaskIdPut**
> TaskModel updateTaskTaskIdPut(id, updateTaskModel)

Update Task

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();
final String id = id_example; // String | 
final UpdateTaskModel updateTaskModel = ; // UpdateTaskModel | 

try {
    final response = api.updateTaskTaskIdPut(id, updateTaskModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->updateTaskTaskIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateTaskModel** | [**UpdateTaskModel**](UpdateTaskModel.md)|  | 

### Return type

[**TaskModel**](TaskModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

