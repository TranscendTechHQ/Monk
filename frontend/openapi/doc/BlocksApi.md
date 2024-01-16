# openapi.api.BlocksApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createBlockBlockBlocksPost**](BlocksApi.md#createblockblockblockspost) | **POST** /block/blocks | Create Block
[**deleteBlockBlockBlocksBlockIdDelete**](BlocksApi.md#deleteblockblockblocksblockiddelete) | **DELETE** /block/blocks/{block_id} | Delete Block
[**getBlockBlockBlocksBlockIdGet**](BlocksApi.md#getblockblockblocksblockidget) | **GET** /block/blocks/{block_id} | Get Block
[**getBlocksBlockBlocksGet**](BlocksApi.md#getblocksblockblocksget) | **GET** /block/blocks | Get Blocks
[**updateBlockBlockBlocksBlockIdPut**](BlocksApi.md#updateblockblockblocksblockidput) | **PUT** /block/blocks/{block_id} | Update Block


# **createBlockBlockBlocksPost**
> BlockModel createBlockBlockBlocksPost(blockModel)

Create Block

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBlocksApi();
final BlockModel blockModel = ; // BlockModel | 

try {
    final response = api.createBlockBlockBlocksPost(blockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BlocksApi->createBlockBlockBlocksPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockModel** | [**BlockModel**](BlockModel.md)|  | 

### Return type

[**BlockModel**](BlockModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteBlockBlockBlocksBlockIdDelete**
> Object deleteBlockBlockBlocksBlockIdDelete(blockId)

Delete Block

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBlocksApi();
final Object blockId = ; // Object | 

try {
    final response = api.deleteBlockBlockBlocksBlockIdDelete(blockId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BlocksApi->deleteBlockBlockBlocksBlockIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockId** | [**Object**](.md)|  | 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBlockBlockBlocksBlockIdGet**
> BlockModel getBlockBlockBlocksBlockIdGet(blockId)

Get Block

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBlocksApi();
final Object blockId = ; // Object | 

try {
    final response = api.getBlockBlockBlocksBlockIdGet(blockId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BlocksApi->getBlockBlockBlocksBlockIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockId** | [**Object**](.md)|  | 

### Return type

[**BlockModel**](BlockModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBlocksBlockBlocksGet**
> BlockCollection getBlocksBlockBlocksGet(blockId)

Get Blocks

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBlocksApi();
final Object blockId = ; // Object | 

try {
    final response = api.getBlocksBlockBlocksGet(blockId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BlocksApi->getBlocksBlockBlocksGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockId** | [**Object**](.md)|  | 

### Return type

[**BlockCollection**](BlockCollection.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBlockBlockBlocksBlockIdPut**
> BlockModel updateBlockBlockBlocksBlockIdPut(blockId, updateBlockModel)

Update Block

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBlocksApi();
final Object blockId = ; // Object | 
final UpdateBlockModel updateBlockModel = ; // UpdateBlockModel | 

try {
    final response = api.updateBlockBlockBlocksBlockIdPut(blockId, updateBlockModel);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BlocksApi->updateBlockBlockBlocksBlockIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockId** | [**Object**](.md)|  | 
 **updateBlockModel** | [**UpdateBlockModel**](UpdateBlockModel.md)|  | 

### Return type

[**BlockModel**](BlockModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

