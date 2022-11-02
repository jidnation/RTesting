import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/home/data/datasources/home_remote_datasource.dart';
import 'package:reach_me/features/home/data/models/star_model.dart';
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

  Future<Either<String, bool>> deleteAccount() async {
    try {
      final deleted = await _homeRemoteDataSource.deleteAccount();
      return Right(deleted);
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

  Future<Either<String, bool>> updateLastSeen({
    required String userId,
  }) async {
    try {
      final user = await _homeRemoteDataSource.updateLastSeen(userId: userId);
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

  Future<Either<String, String>> uploadPhoto({
    required String url,
    required File? file,
  }) async {
    try {
      await _apiClient.uploadImage(url: url, file: file!);
      return const Right('Upload successful');
    } on DioError catch (e) {
      Console.log('taggerd', e.response);
      return Left(e.response!.data['message']);
    }
  }

  Future<Either<String, dynamic>> getSignedURl({required File file}) async {
    try {
      final res = await _apiClient.getSignedURL(file);
      final imageUrl = res['data']['link'] as String;
      final signedUrl = res['data']['signedUrl'] as String;
      return Right({
        'imageUrl': imageUrl,
        'signedUrl': signedUrl,
      });
    } on DioError catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  Future<Either<String, String>> reverseGeocode({
    required String lat,
    required String lng,
  }) async {
    try {
      final res = await _apiClient.reverseGeocode(lat: lat, lng: lng);
      Console.log('reverse geocode repo', res);
      return Right(res);
    } on DioError catch (e) {
      Console.log('reverse geocode repo', e.response);
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

  Future<Either<String, StarModel>> starUser({
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
    required String type,
  }) async {
    try {
      final isReaching = await _homeRemoteDataSource.getReachRelationship(
          userId: userId, type: type);
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

  Future<Either<String, List<VirtualReach>>> getReachers({
    required int pageLimit,
    required int pageNumber,
    String? authId,
  }) async {
    try {
      final getReachers = await _homeRemoteDataSource.getReachers(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
        authId: authId,
      );
      return Right(getReachers);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<VirtualReach>>> getReachings({
    required int pageLimit,
    required int pageNumber,
    String? authId,
  }) async {
    try {
      final getReachings = await _homeRemoteDataSource.getReachings(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
        authId: authId,
      );
      return Right(getReachings);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<VirtualStar>>> getStarred({
    required int pageLimit,
    required int pageNumber,
    String? authId,
  }) async {
    try {
      final getStarred = await _homeRemoteDataSource.getStarred(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
        authId: authId,
      );
      return Right(getStarred);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }
}
