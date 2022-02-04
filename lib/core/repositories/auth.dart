import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/core/services/api/api_result.dart';
import 'package:reach_me/core/services/exceptions/network_exceptions.dart';

class AuthServiceRepository {
  AuthServiceRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();
  final ApiClient _apiClient;

  Future<dynamic> register(Map<String, dynamic> data) async {
    try {
      var responseJson = await _apiClient.post('/register', data: data);
      return ApiResult.success(data: responseJson);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<dynamic> verifyEmail(Map<String, dynamic> data) async {
    try {
      var responseJson = await _apiClient.post('/verifyEmail', data: data);
      return ApiResult.success(data: responseJson);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<dynamic> resendEmailToken(Map<String, dynamic> data) async {
    try {
      var responseJson = await _apiClient.post('/emailToken', data: data);
      return ApiResult.success(data: responseJson);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<dynamic> login(Map<String, dynamic> data) async {
    try {
      var responseJson = await _apiClient.post('/login', data: data);
      return ApiResult.success(data: responseJson);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<dynamic> forgotPassword(Map<String, dynamic> data) async {
    try {
      var responseJson = await _apiClient.post('/forgotPassword', data: data);
      return ApiResult.success(data: responseJson);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
