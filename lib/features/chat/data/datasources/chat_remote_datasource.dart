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
  ChatRemoteDataSource({GraphQLChatClient? client})
      : _client = client ?? GraphQLChatClient();
  final GraphQLChatClient _client;

//send text message
  Future<Chat> sendTextMessage({
    required String? senderId,
    required String? receiverId,
    required String? threadId,
    required String? value,
    required String? type,
    required String? sentAt,
    required String? messageMode,
  }) async {
    String q = r'''
        mutation sendChatMessage(
          $senderId: String!
          $receiverId: String!
          $messageMode: String!
          $contentType: String!
          $content: String!
          $sentAt: String!
          $threadId: String!
          
        ) {
          sendChatMessage(
            data: {
              senderId: $senderId
              receiverId: $receiverId
              messageMode: $messageMode
              contentType: $contentType
              content: $content
              sentAt: $sentAt
              threadId: $threadId
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
        'contentType': type,
        'threadId': threadId,
        'content': value,
        'sentAt': sentAt,
        'messageMode': messageMode,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return Chat.fromJson(result.data!['sendChatMessage']);
    } catch (e) {
      rethrow;
    }
  }

//get thread messages {messages between two users}
  Future<List<Chat>> getThreadMessages({
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
      var res = result.data!['getThreadMessages'] as List;
      var data = res.map((e) => Chat.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

//list of people you have chatted with.
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

  Stream<QueryResult> subscribeToChats({required String? id}) {
    Console.log('sub id', id);
    String q = r'''
          subscription messageAdded($id: String!) {
            messageAdded(id: $id) {
                _id
                id
                senderId
                receiverId
                receivers
                type
                value
                threadId
                sentAt
                createdAt
                updatedAt
            }
          }''';
    try {
      final result = _client.subscribe(gql(q), variables: {'id': id});
      // result.listen((event) {
      //   if (event.hasException) {
      //     Console.log('subscription exception', event.exception);
      //   } else if (event.isLoading) {
      //     Console.log('subscription loading', event.isLoading);
      //   } else {
      //     Console.log('subscription data', event.data);
      //   }
      // });
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
