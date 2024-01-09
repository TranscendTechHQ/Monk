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
> JsonObject createTaskTaskPost(taskModel)

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

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteTaskTaskIdDelete**
> JsonObject deleteTaskTaskIdDelete(id)

Delete Task

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();
final JsonObject id = ; // JsonObject | 

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
 **id** | [**JsonObject**](.md)|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTasksTaskGet**
> BuiltList<TaskModel> listTasksTaskGet()

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

[**BuiltList&lt;TaskModel&gt;**](TaskModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **showTaskTaskIdGet**
> JsonObject showTaskTaskIdGet(id)

Show Task

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();
final JsonObject id = ; // JsonObject | 

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
 **id** | [**JsonObject**](.md)|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTaskTaskIdPut**
> JsonObject updateTaskTaskIdPut(id, updateTaskModel)

Update Task

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTasksApi();
final JsonObject id = ; // JsonObject | 
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
 **id** | [**JsonObject**](.md)|  | 
 **updateTaskModel** | [**UpdateTaskModel**](UpdateTaskModel.md)|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

