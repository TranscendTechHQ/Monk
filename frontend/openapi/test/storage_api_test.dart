import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for StorageApi
void main() {
  final instance = Openapi().getStorageApi();

  group(StorageApi, () {
    // Upload Files
    //
    //Future<FilesResponseModel> uploadFilesUploadFilesPost(List<MultipartFile> files) async
    test('test uploadFilesUploadFilesPost', () async {
      // TODO
    });

  });
}
