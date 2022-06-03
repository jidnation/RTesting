import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/home/data/datasources/home_remote_datasource.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';

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
      Console.log('taggerd', e.response);
      return Left(e.response!.data['message']);
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

  Future<Either<String, dynamic>> reachUser({
    required String userId,
  }) async {
    try {
      final reach = await _homeRemoteDataSource.reachUser(
        userId: userId,
      );
      return Right(reach);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, dynamic>> starUser({
    required String userId,
  }) async {
    try {
      final star = await _homeRemoteDataSource.starUser(
        userId: userId,
      );
      return Right(star);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> getReachRelationship({
    required String userId,
  }) async {
    try {
      final isReaching = await _homeRemoteDataSource.getReachRelationship(
        userId: userId,
      );
      return Right(isReaching);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deleteReachRelationship({
    required String userId,
  }) async {
    try {
      final isReachingDel = await _homeRemoteDataSource.deleteReachRelationship(
        userId: userId,
      );
      return Right(isReachingDel);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> getStarRelationship({
    required String userId,
  }) async {
    try {
      final isStarring = await _homeRemoteDataSource.getStarRelationship(
        userId: userId,
      );
      return Right(isStarring);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deleteStarRelationship({
    required String userId,
  }) async {
    try {
      final isStarringDel = await _homeRemoteDataSource.deleteStarRelationship(
        userId: userId,
      );
      return Right(isStarringDel);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<VirtualReach>>> getReachers() async {
    try {
      final getReachers = await _homeRemoteDataSource.getReachers();
      return Right(getReachers);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<VirtualReach>>> getReachings() async {
    try {
      final getReachings = await _homeRemoteDataSource.getReachings();
      return Right(getReachings);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<VirtualStar>>> getStarred() async {
    try {
      final getStarred = await _homeRemoteDataSource.getStarred();
      return Right(getStarred);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }
}
