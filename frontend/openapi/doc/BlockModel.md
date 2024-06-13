# openapi.model.BlockModel

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**assignedTo** | [**UserModel**](UserModel.md) |  | [optional] 
**assignedToId** | **String** |  | [optional] 
**childThreadId** | **String** |  | [optional] [default to '']
**content** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | [optional] 
**creatorId** | **String** |  | [optional] [default to 'unknown id']
**dueDate** | [**DateTime**](DateTime.md) |  | [optional] 
**image** | **String** |  | [optional] 
**lastModified** | [**DateTime**](DateTime.md) |  | [optional] 
**linkMeta** | [**LinkMetaModel**](LinkMetaModel.md) |  | [optional] 
**mainThreadId** | **String** |  | [optional] [default to '']
**position** | **int** |  | [optional] [default to 0]
**taskStatus** | **String** |  | [optional] [default to 'todo']
**tenantId** | **String** |  | [optional] [default to '']

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


