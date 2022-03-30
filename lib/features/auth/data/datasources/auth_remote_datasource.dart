import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/features/auth/data/models/user.dart';

// abstract class IAuthRemoteDataSource {
//   Future<User> createAccount({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     String? phoneNumber,
//   });
// }

class AuthRemoteDataSource {
  AuthRemoteDataSource({GraphQLApiClient? client})
      : _client = client ?? GraphQLApiClient();
  final GraphQLApiClient _client;

  //@override
  Future<User> createAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    String? phoneNumber,
  }) async {
    const String q = r'''
    mutation createAccount(
    $email: String!
    $firstName: String!
    $lastName: String!
    $password: String!
    $phone: String
    ) {
    createAccount(
      data: {
        email: $email
        firstName: $firstName
        lastName: $lastName
        password: $password
        phone: $phone
    }
    ) {
    id
    email
    firstName
    lastName
    phone
    token
    updated_at
    created_at
    isActive
    lastLogin
  }
}''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'phone': '080335',
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('create account resut', result.data);
      return User.fromJson(result.data!['createAccount']);
    } catch (e) {
      rethrow;
    }
  }
}
