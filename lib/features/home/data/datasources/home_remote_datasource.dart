import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/graphql/schemas/user_schema.dart';

// abstract class IHomeRemoteDataSource {
//   Future<User> createAccount({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     String? phoneNumber,
//   });
// }

class HomeRemoteDataSource {
  HomeRemoteDataSource({GraphQLApiClient? client})
      : _client = client ?? GraphQLApiClient();
  final GraphQLApiClient _client;

  Future<User> getUserProfile({required String? email}) async {
    String q = r'''
        query getUserByIdOrEmail($prop: String!) {
          getUserByIdOrEmail(prop: $prop) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'prop': email,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get user profile', result);
      Console.log('get user profile', result.data);
      return User.fromJson(result.data!['getUserByIdOrEmail']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> setUsername({required String? username}) async {
    String q = r'''
        mutation setUsername($username: String!) {
          setUsername(username: $username) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'username': username,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('set username', result.data);
      return User.fromJson(result.data!['setUsername']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> setDOB({required String? dob}) async {
    String q = r'''
        mutation setDateOfBirth($dateOfBirth: String!) {
          setDateOfBirth(dateOfBirth: $dateOfBirth) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'dateOfBirth': dob,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('set date of birth', result.data);
      return User.fromJson(result.data!['setDateOfBirth']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUserProfile({
    String? dateOfBirth,
    String? bio,
    String? gender,
    String? location,
    bool? showContact,
    bool? showLocation,
    String? username,
    String? phone,
  }) async {
    String q = r'''
        mutation updateUser(
          $bio: String
          $dateOfBirth: String
          $gender: String
          $location: String
          $showContact: Boolean
          $showLocation: Boolean
          ) {
          updateUser(
            userData: {
              bio: $bio
              dateOfBirth: $dateOfBirth
              gender: $gender
              location: $location
              showContact: $showContact
              showLocation: $showLocation
          }) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      Map<String, dynamic> variables = {};

      if (bio != null) variables.putIfAbsent('bio', () => bio);
      if (dateOfBirth != null) {
        variables.putIfAbsent('dateOfBirth', () => dateOfBirth);
      }
      if (gender != null) variables.putIfAbsent('gender', () => gender);
      if (location != null) variables.putIfAbsent('location', () => location);
      if (showContact != null) {
        variables.putIfAbsent('showContact', () => showContact);
      }
      if (showLocation != null) {
        variables.putIfAbsent('showLocation', () => showLocation);
      }

      final result = await _client.mutate(
        gql(q),
        variables: variables,
      );
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('update user', result.data);
      return User.fromJson(result.data!['updateUser']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> setImage({
    required String? imageUrl,
    required String? type,
  }) async {
    String q = r'''
        mutation setImage(
          $imageUrl: String!
          $typeOfImageUpload: String!
          ) {
          setImage(
            imageUrl: $imageUrl
            typeOfImageUpload: $typeOfImageUpload
            ) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'imageUrl': imageUrl,
        'typeOfImageUpload': type,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('set image', result.data);
      return User.fromJson(result.data!['setImage']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getAllUsersByName({
    required int? limit,
    required int? pageNumber,
    required String? query,
  }) async {
    String q = r'''
          query getAllUsers($limit: Int!, $name: String!, $pageNumber: Int!) {
            getAllUsers(limit: $limit, name: $name, pageNumber: $pageNumber) {
          ''' +
        UserSchema.schema +
        '''
            }
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'limit': limit,
        'pageNumber': pageNumber,
        'name': query,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get All Users ', result.data);
      final res = result.data['getAllUsers'] as List;
      final data = res.map((e) => User.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
