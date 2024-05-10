import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for StorageApi
void main() {
  final instance = Openapi().getStorageApi();

  group(StorageApi, () {
    // Create
    //
    //Future<Object> createUploadFilesPost(List<MultipartFile> files, { Object responseModel, Object responseDescription }) async
    test('test createUploadFilesPost', () async {
      // TODO
    });

  });
}
