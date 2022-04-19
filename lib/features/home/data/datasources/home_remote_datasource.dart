import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/graphql/schemas/user_schema.dart';
import 'package:reach_me/features/home/data/models/virtual_reach.dart';

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
      final result = await _client.query(gql(q), variables: {
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

  Future<dynamic> reachUser({required String? userId}) async {
    String q = r'''
          mutation reachUser($userIdToReach: String!) {
            reachUser(userIdToReach: $userIdToReach) {
              reacherId
              reachingId
            }
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userIdToReach': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('reach user ', result.data);
      return result.data['reachUser'];
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> starUser({required String? userId}) async {
    String q = r'''
          mutation starUser($userIdToStar: String!) {
            starUser(userIdToStar: $userIdToStar) {
              starredId
              userId
            }
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userIdToStar': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('star user ', result.data);
      return result.data['starUser'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getReachRelationship({required String? userId}) async {
    String q = r'''
          query getReachRelationship($userIdToReach: String!) {
            getReachRelationship(userIdToReach: $userIdToReach)
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'userIdToReach': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get reach relationship ', result.data);
      return result.data['getReachRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteReachRelationship({required String? userId}) async {
    String q = r'''
          mutation deleteReachRelationship($userIdToDelete: String!) {
            deleteReachRelationship(userIdToDelete: $userIdToDelete) 
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userIdToDelete': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('del reach relationship ', result.data);
      return result.data['deleteReachRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getStarRelationship({required String? userId}) async {
    String q = r'''
          query getStarRelationship($userIdToStar: String!) {
            getStarRelationship(userIdToStar: $userIdToStar)
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'userIdToStar': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get star relationship ', result.data);
      return result.data['getStarRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteStarRelationship({required String? userId}) async {
    String q = r'''
          mutation deleteStarRelationship($starIdToDelete: String!) {
            deleteStarRelationship(starIdToDelete: $starIdToDelete) 
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'starIdToDelete': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('del star relationship ', result.data);
      return result.data['deleteStarRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualReach>> getReachers() async {
    String q = r'''
          query getReachers() {
            getReachers() {
              reacher {
                ''' +
        UserSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        UserSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get Reachers', result.data);
      var res = result.data['getReachers'] as List;
      final data = res.map((e) => VirtualReach.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualReach>> getReachings() async {
    String q = r'''
          query getReachings() {
            getReachings() {
              reacher {
                ''' +
        UserSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        UserSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get reachings', result.data);
      var res = result.data['getReachings'] as List;
      final data = res.map((e) => VirtualReach.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualStar>> getStarred() async {
    String q = r'''
          query getStarred() {
            getStarred() {
              reacher {
                ''' +
        UserSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        UserSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get starreds', result.data);
      var res = result.data['getStarred'] as List;
      final data = res.map((e) => VirtualStar.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
