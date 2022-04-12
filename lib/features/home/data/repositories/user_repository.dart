import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/home/data/datasources/home_remote_datasource.dart';

// abstract class IUserRepository {
//   Future<Either<String, User>> createAccount({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     String? phoneNumber,
//   });
// }

class UserRepository {
  UserRepository(
      {HomeRemoteDataSource? homeRemoteDataSource, ApiClient? apiClient})
      : _homeRemoteDataSource = homeRemoteDataSource ?? HomeRemoteDataSource(),
        _apiClient = apiClient ?? ApiClient();

  final HomeRemoteDataSource _homeRemoteDataSource;
  final ApiClient _apiClient;

  // @override
  Future<Either<String, User>> getUserProfile({
    required String email,
  }) async {
    try {
      final user = await _homeRemoteDataSource.getUserProfile(email: email);
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, User>> setUsername({
    required String username,
  }) async {
    try {
      final user = await _homeRemoteDataSource.setUsername(username: username);
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, User>> setDOB({
    required String dateOfBirth,
  }) async {
    try {
      final user = await _homeRemoteDataSource.setDOB(dob: dateOfBirth);
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, User>> updateUserProfile({
    String? dateOfBirth,
    String? bio,
    String? gender,
    String? location,
    bool? showContact,
    bool? showLocation,
    String? phone,
    String? username,
  }) async {
    try {
      final user = await _homeRemoteDataSource.updateUserProfile(
        bio: bio,
        gender: gender,
        dateOfBirth: dateOfBirth,
        location: location,
        showContact: showContact,
        showLocation: showLocation,
      );
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, String>> uploadPhoto({XFile? file}) async {
    try {
      final user = await _apiClient.uploadImage(file!);
      Console.log('upload photo', user);
      final String imgUrl = user['data'];
      return Right(imgUrl);
    } on DioError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, User>> setImage({
    required String imageUrl,
    required String type,
  }) async {
    try {
      final user = await _homeRemoteDataSource.setImage(
        imageUrl: imageUrl,
        type: type,
      );
      Console.log('upload photo', user);
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<User>>> getAllUsersByName({
    required String query,
    required int limit,
    required int pageNumber,
  }) async {
    try {
      final user = await _homeRemoteDataSource.getAllUsersByName(
        query: query,
        limit: limit,
        pageNumber: pageNumber,
      );
      Console.log('get alll users by name', user);
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }
}
