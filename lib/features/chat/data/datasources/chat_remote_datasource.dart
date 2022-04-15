import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/core/services/graphql/schemas/chat_schema.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';

// abstract class IChatRemoteDataSource {
//   Future<User> createAccount({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     String? phoneNumber,
//   });
// }

class ChatRemoteDataSource {
  ChatRemoteDataSource({GraphQLApiClient? client})
      : _client = client ?? GraphQLApiClient();
  final GraphQLApiClient _client;

  Future<Chat> sendTextMessage({
    required String? senderId,
    required String? receiverId,
    required String? threadId,
    required String? value,
    required String? type,
  }) async {
    String q = r'''
        mutation sendChatMessage(
          $senderId: String!
          $receiverId: String!
          $type: MessageType!
          $threadId: String
          $value: String
        ) {
          sendChatMessage(
            data: {
              senderId: $senderId
              receiverId: $receiverId
              type: $type
              threadId: $threadId
              value: $value
            }
          ) {
          ''' +
        ChatSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'senderId': senderId,
        'receiverId': receiverId,
        'type': type,
        'threadId': threadId,
        'value': value,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('send chat message', result.data);
      return Chat.fromJson(result.data!['sendChatMessage']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Chat> getThreadMessages({
    required String? id,
    String? fromMessageId,
  }) async {
    String q = r'''
        query getThreadMessages($id: String!, $fromMessageId: String) {
          getThreadMessages(id: $id, fromMessageId: $fromMessageId) {
            ''' +
        ChatSchema.schema +
        '''
          }
        }''';
    try {
      final Map<String, dynamic> variables = {};

      if (id != null) variables.putIfAbsent('id', () => id);
      if (fromMessageId != null) {
        variables.putIfAbsent('fromMessageId', () => fromMessageId);
      }

      final result = await _client.query(gql(q), variables: variables);
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get thread messages', result.data);
      return Chat.fromJson(result.data!['getThreadMessages']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatsThread>> getUserThreads({required String? id}) async {
    String q = r'''
        query getUserThreads($id: String!) {
          getUserThreads(id: $id) {
             ''' +
        ChatThreadSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {'id': id});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get user threads', result.data);
      var res = result.data!['getUserThreads'] as List;
      var data = res.map((e) => ChatsThread.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteThread({required String? id}) async {
    String q = r'''
          query deleteThread($id: String!) {
            deleteThread(id: $id) 
          }''';
    try {
      final result = await _client.query(gql(q), variables: {'id': id});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('delete thread', result.data);
      return result.data!['deleteThread'] as bool;
    } catch (e) {
      rethrow;
    }
  }
}
