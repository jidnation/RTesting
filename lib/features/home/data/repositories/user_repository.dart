import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/features/auth/data/models/user.dart';
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
  UserRepository({HomeRemoteDataSource? homeRemoteDataSource})
      : _homeRemoteDataSource = homeRemoteDataSource ?? HomeRemoteDataSource();

  final HomeRemoteDataSource _homeRemoteDataSource;

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
}
