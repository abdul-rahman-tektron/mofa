import 'dart:convert';
import 'dart:io';
import 'package:mofa/utils/toast_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mofa/res/app_colors.dart';

enum UploadFileType { image, document }

class FileUploadHelper {
  static final ImagePicker _imagePicker = ImagePicker();
  static const int MAX_FILE_SIZE_BYTES = 5 * 1024 * 1024; // 5 MB

  /// Pick an image using camera or gallery (with optional cropping).
  static Future<File?> pickImage({
    bool fromCamera = false,
    bool cropAfterPick = false,
    BuildContext? context,
  }) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return null;

    final int fileSize = await pickedFile.length();

    if (fileSize > MAX_FILE_SIZE_BYTES) {
      ToastHelper.showError('Image file size exceeds 5MB limit.');
      return null;
    }

    File imageFile = File(pickedFile.path);

    if (cropAfterPick) {
      final croppedFile = await _cropImage(imageFile.path);
      if (croppedFile == null) return null;
      imageFile = File(croppedFile.path);
    }

    return await _saveToPermanentDirectory(imageFile);
  }

  static File fromBase64(String base64Str) {
    final bytes = base64Decode(base64Str);
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.tmp');
    file.writeAsBytesSync(bytes); // just write, don't return
    return file; // now return the file object
  }
  /// Pick a document (PDF, Word, Excel, etc.)
  static Future<File?> pickDocument({List<String>? allowedExtensions}) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );
    if (result != null && result.files.single.path != null) {
      PlatformFile files = result.files.first;
      int fileSizeInBytes = files.size; // Get file size in bytes

      if (fileSizeInBytes > MAX_FILE_SIZE_BYTES) {
        ToastHelper.showError('Document file size exceeds 5MB limit.');
        return null;
      }

      final file = File(result.files.single.path!);
      return await _saveToPermanentDirectory(file);
    }
    return null;
  }

  /// Crop the selected image (used internally)
  static Future<CroppedFile?> _cropImage(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
  }

  /// Save file to app's document directory with a unique name
  static Future<File> _saveToPermanentDirectory(File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(file.path);
    final savedPath = '${appDir.path}/$fileName';

    final savedFile = await file.copy(savedPath);
    return savedFile;
  }
}
