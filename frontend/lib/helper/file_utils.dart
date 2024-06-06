import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:frontend/core/option.dart';

class FileUtility {
  static Future<Option<File>> pickImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final PlatformFile file = result.files.first;
      return Some(File(file.path!));
    }
    return const None();
  }
}
