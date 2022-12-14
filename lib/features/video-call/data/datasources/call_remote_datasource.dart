import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/services/graphql/gql_client.dart';

class VideoCallRemoteDataSource {
  VideoCallRemoteDataSource({GraphQLNotificationClient? client})
      : _client = client ?? GraphQLNotificationClient();
  final GraphQLNotificationClient _client;

  Future<dynamic> testNotifications() async {
    String q = '''
          mutation {
            testNotification(
              payload:{
                title: "title"
                message: "message"
              }
            )
          }
      ''';
    try {
      final result = await _client.mutate(gql(q), variables: {});
      if (result is GraphQLError) {
        Console.log('error message', result);
        throw GraphQLError(message: result.message);
      }
      Console.log('notification response', result.data);
    } catch (e) {
      rethrow;
    }
  }
}
