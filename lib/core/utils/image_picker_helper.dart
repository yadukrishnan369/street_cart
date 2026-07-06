import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_cart/core/error/exceptions.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // compresses the image
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } on PlatformException catch (e) {
      throw ImagePickerException('Gallery access denied: ${e.message}');
    } catch (e) {
      throw ImagePickerException('An unexpected error occurred: $e');
    }
  }

  static Future<List<File>> pickMultiImage({int limit = 10}) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70,
        limit: limit,
      );
      return pickedFiles.map((x) => File(x.path)).toList();
    } on PlatformException catch (e) {
      throw ImagePickerException('Gallery access denied: ${e.message}');
    } catch (e) {
      throw ImagePickerException('An unexpected error occurred: $e');
    }
  }
}
