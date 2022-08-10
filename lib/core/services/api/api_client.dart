// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:reach_me/core/helper/logger.dart';

const GOOGLE_API_KEY = 'AIzaSyAV2_9BKcCkpdd4IjZOoQ9mybLAn3i9tUE';

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

  Future<dynamic> uploadImage({
    required String url,
    required File file,
  }) async {
    try {
      final image = await file.readAsBytes();
      final cntlength = await file.length();
      final mime = lookupMimeType(file.path);

      final response = await _dio.put(
        url,
        data: Stream.fromIterable(image.map((e) => [e])),
        options: Options(
          contentType: mime,
          headers: {
            'Content-Length': cntlength.toString(),
            'Connection': 'keep-alive',
            'Accept': '*/*',
          },
        ),
      );
      return response.data;
    } on FormatException {
      throw const FormatException("Bad response format 👎");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSignedURL(File file) async {
    String fileName = file.path.split('/').last;

    try {
      final response = await _dio.get(
        'https://api.myreach.me/utility/get-signed-url/$fileName',
      );
      Console.log('responseee', response);
      return response.data;
    } on FormatException {
      throw const FormatException("Bad response format 👎");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> reverseGeocode(
      {required String lat, required String lng}) async {
    try {
      String latlng = '$lat,$lng';
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latlng&key=$GOOGLE_API_KEY',
      );

      final location = response.data['results'][0]['address_components'][2]
              ['long_name'] +
          ',' +
          ' ' +
          response.data['results'][0]['address_components'][4]['long_name'];
      return location as String;
    } on FormatException {
      throw const FormatException("Bad response format 👎");
    } catch (e) {
      rethrow;
    }
  }
}
