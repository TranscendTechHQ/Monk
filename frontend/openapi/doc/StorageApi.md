# openapi.api.StorageApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**uploadFilesUploadFilesPost**](StorageApi.md#uploadfilesuploadfilespost) | **POST** /uploadFiles/ | Upload Files


# **uploadFilesUploadFilesPost**
> FilesResponseModel uploadFilesUploadFilesPost(files)

Upload Files

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getStorageApi();
final List<MultipartFile> files = /path/to/file.txt; // List<MultipartFile> | 

try {
    final response = api.uploadFilesUploadFilesPost(files);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StorageApi->uploadFilesUploadFilesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **files** | [**List&lt;MultipartFile&gt;**](MultipartFile.md)|  | 

### Return type

[**FilesResponseModel**](FilesResponseModel.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

