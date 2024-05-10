# openapi.api.StorageApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createUploadFilesPost**](StorageApi.md#createuploadfilespost) | **POST** /uploadFiles/ | Create


# **createUploadFilesPost**
> Object createUploadFilesPost(files, responseModel, responseDescription)

Create

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getStorageApi();
final List<MultipartFile> files = /path/to/file.txt; // List<MultipartFile> | 
final Object responseModel = ; // Object | 
final Object responseDescription = ; // Object | 

try {
    final response = api.createUploadFilesPost(files, responseModel, responseDescription);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StorageApi->createUploadFilesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **files** | [**List&lt;MultipartFile&gt;**](MultipartFile.md)|  | 
 **responseModel** | [**Object**](.md)|  | [optional] 
 **responseDescription** | [**Object**](.md)|  | [optional] 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

