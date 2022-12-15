import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/features/auth/data/models/login_response.dart';

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
  Future<LoginResponse> createAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    const String q = r'''
    mutation createAccount(
    $email: String!
    $firstName: String!
    $lastName: String!
    $password: String!
    ) {
    createAccount(
      data: {
        email: $email
        firstName: $firstName
        lastName: $lastName
        password: $password
    }
    ) {
    id
    email
  }
}''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('create account result', result.data);
      return LoginResponse.fromJson(result.data!['createAccount']);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> verifyAccount(
      {required String? email, required int pin}) async {
    const String q = r'''
      query activateAccount($email: String!, $pin: Int!) {
        activateAccount(email: $email, pin: $pin) {
          id
          email
        }
      }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'email': email,
        'pin': pin,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('verify account', result.data);
      return LoginResponse.fromJson(result.data!['activateAccount']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> initiatePasswordReset({required String? email}) async {
    const String q = r'''
        query initiatePasswordReset($email: String!) {
          initiatePasswordReset(email: $email) 
        }''';
    try {
      final result = await _client.query(gql(q), variables: {'email': email});

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      if (result is QueryResult &&
              result.data!['initiatePasswordReset'] == null ||
          result.data!['initiatePasswordReset'] == false) {
        return false;
      }

      Console.log('initiate password reset', result.data);
      return result.data!['initiatePasswordReset'];
    } catch (e) {
      rethrow;
    }
  }

  Future<String> verifyPasswordResetPin(
      {required String? email, required int? pin}) async {
    const String q = r'''
        query verifyResetPin($email: String!, $pin: Int!) {
          verifyResetPin(email: $email, pin: $pin) {
            token
          }
        }''';
    try {
      final result = await _client.query(
        gql(q),
        variables: {'email': email, 'pin': pin},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      Console.log('verify reset pin', result.data);
      return result.data!['verifyResetPin'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPasswordWithToken(
      {required String? password, required String? token}) async {
    const String q = r'''
        query resetPasswordWithToken($password: String!, $token: String!) {
          resetPasswordWithToken(password: $password, token: $token) 
        }''';
    try {
      final result = await _client.query(
        gql(q),
        variables: {'token': token, 'password': password},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      if (result is QueryResult &&
              result.data!['resetPasswordWithToken'] == null ||
          result.data!['resetPasswordWithToken'] == false) {
        return false;
      }
      Console.log('reset password with token', result.data);
      return result.data!['resetPasswordWithToken'];
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> login(
      {required String? email, required String password}) async {
    const String q = r'''
      query login($email: String!, $password: String!) {
      login(email: $email, password: $password) {
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
      final result = await _client.query(gql(q), variables: {
        'email': email,
        'password': password,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('login account', result.data);
      return LoginResponse.fromJson(result.data!['login']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerDeviceForNotification() async {
    var token = await OneSignal.shared.getDeviceState();
    String q = r'''
  mutation{
      registerDeviceForNotification(
      playerId: $playerId
    )
  }
    ''';
    final result = await _client.mutate(
      gql(q),
      variables: {
        "playerId":token!.userId!
      },
    );
    Console.log('fcmtokenresult', result);
  }
}
