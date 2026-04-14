import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:street_cart/core/constants/api_constants.dart';

class CloudinaryService {
  Future<String?> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.cloudinaryUploadUrl),
      );

      // add file to request
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // add upload preset
      request.fields['upload_preset'] = ApiConstants.cloudinaryUploadPreset;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['secure_url'] as String;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
