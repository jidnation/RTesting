import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/features/auth/data/models/user.dart';

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
    const String q = r'''
        query getUserBy($prop: String!) {
          getUserBy(prop: $prop) {
            _id
            bio
            dateOfBirth
            displayPicture
            gender
            location
            phone
            profilePicture
            profileSlug
            showContact
            showLocation
            userId
            userQR
            username
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'prop': email,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get user profile', result.data);
      return User.fromJson(result.data!['getUserBy']);
    } catch (e) {
      rethrow;
    }
  }
}
