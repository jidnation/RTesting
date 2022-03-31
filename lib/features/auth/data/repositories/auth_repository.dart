import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:reach_me/features/auth/data/models/user.dart';

// abstract class IAuthRepository {
//   Future<Either<String, User>> createAccount({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     String? phoneNumber,
//   });

//   // Future<Either<String, User>> signInWithEmailAndPassword({
//   //   required String email,
//   //   required String password,
//   // });

//   // Future<Either<String, User>> activateAccount({
//   //   required String email,
//   //   required int pin,
//   // });

//   // Future<Either<String, bool>> initiatePasswordReset({
//   //   required String email,
//   // });

//   // Future<Either<String, bool>> resetPasswordWithToken({
//   //   required String password,
//   //   required String token,
//   // });

//   // Future<Either<String, String>> verifyResetPin({
//   //   required String email,
//   //   required int pin,
//   // });

//   // Future<Either<String, User>> signInWithGoogle();
// }

class AuthRepository {
  AuthRepository({AuthRemoteDataSource? authRemoteDataSource})
      : _authRemoteDataSource = authRemoteDataSource ?? AuthRemoteDataSource();

  final AuthRemoteDataSource _authRemoteDataSource;

  // @override
  Future<Either<String, User>> createAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final user = await _authRemoteDataSource.createAccount(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        phoneNumber: phoneNumber,
      );
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, User>> verifyAccount(
      {required String? email, required int pin}) async {
    try {
      final user =
          await _authRemoteDataSource.verifyAccount(email: email, pin: pin);
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, User>> login(
      {required String? email, required String password}) async {
    try {
      final user =
          await _authRemoteDataSource.login(email: email, password: password);
      return Right(user);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  // @override
  // Future<Either<String, User>> signInWithEmailAndPassword({
  //   required String email,
  //   required String password,
  // }) async {}

  // @override
  // Future<Either<String, User>> activateAccount({
  //   required String email,
  //   required int pin,
  // }) async {

  // }

  // @override
  // Future<Either<String, User>> signInWithGoogle() async {

  // }

  // @override
  // Future<Either<String, bool>> initiatePasswordReset({
  //   required String email,
  // }) async {

  // }

  // @override
  // Future<Either<String, bool>> resetPasswordWithToken({
  //   required String password,
  //   required String token,
  // }) async {

  // }

  // @override
  // Future<Either<String, String>> verifyResetPin({
  //   required String email,
  //   required int pin,
  // }) async {

  // }

}
