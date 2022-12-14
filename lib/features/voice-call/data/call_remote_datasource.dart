import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/helper/logger.dart';
import '../../../core/services/graphql/gql_client.dart';
import '../../home/data/models/virtual_models.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource({GraphQLNotificationClient? client})
      : _client = client ?? GraphQLNotificationClient();
  final GraphQLNotificationClient _client;

  Future<dynamic> getBlockList() async {
    String q = r'''
         query getBlockList() {
          getBlockList() {  
                authId
                blockedAuthId
                blockedProfile {
                }
          }
         }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('GetBlockedList', result.data);
      return (result.data['getBlockList'] as List)
          .map((e) => Block.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
