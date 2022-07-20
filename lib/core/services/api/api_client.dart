import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ApiClient {
  final Dio _dio;
  ApiClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<dynamic> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return response.data;
    } on FormatException {
      throw const FormatException("Bad response format 👎");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } on FormatException {
      throw const FormatException("Bad response format 👎");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> uploadImage(XFile file) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap(
      {"file": await MultipartFile.fromFile(file.path, filename: fileName)},
    );
    try {
      final response = await _dio.post(
        'http://185.3.95.146:4600/upload',
        data: formData,
      );
      return response.data;
    } on FormatException {
      throw const FormatException("Bad response format 👎");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSignedURL(XFile file) async {
    String fileName = file.path.split('/').last;
    // String fileExtension = fileName.split('.').last;

    try {
      final response = await _dio.get(
        'http://185.3.95.146:4600/utility/get-signed-url/$fileName',
      );
      return response.data;
    } on FormatException {
      throw const FormatException("Bad response format 👎");
    } catch (e) {
      rethrow;
    }
  }
}
