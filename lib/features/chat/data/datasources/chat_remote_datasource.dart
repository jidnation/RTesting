import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/core/services/graphql/schemas/chat_schema.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/home/data/models/stream_model.dart';

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
    required String? receiverId,
    required String? threadId,
    required String? value,
    required String? type,
    String? quotedData,
    String? senderId,
    required String messageMode,
  }) async {
    String q = r'''
        mutation sendPrivateMessage(
          $receiverId: String!
          $messageMode: String!
          $contentType: String!
          $content: String!
          $sentAt: String!
          $threadId: String
          $quotedData: String
        ) {
          sendPrivateMessage(
            data: {
              receiverId: $receiverId
              messageMode: $messageMode
              contentType: $contentType
              content: $content
              sentAt: $sentAt
              threadId: $threadId
              quotedData: $quotedData
            }
          ) {
          ''' +
        ChatSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'receiverId': receiverId,
        'contentType': type,
        'threadId': threadId,
        'content': value,
        'sentAt': DateTime.now().toIso8601String(),
        'quotedData': quotedData,
        'messageMode': messageMode,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return Chat.fromJson(result.data!['sendPrivateMessage']);
    } catch (e) {
      rethrow;
    }
  }

//get thread messages {messages between two users}
  Future<List<Chat>> getThreadMessages({
    String? threadId,
    String? receiverId,
    String? fromMessageId,
  }) async {
    String q = r'''
        query getPrivateMessageFeed(
            $threadId: String, 
            $receiverId: String,
            $messageIdToStartSearch: String
        ) {
          getPrivateMessageFeed(
              threadId: $threadId,
              receiverId: $receiverId,
              messageIdToStartSearch: $messageIdToStartSearch
            ) {
            ''' +
        ChatSchema.schema +
        '''
          }
        }''';
    try {
      final Map<String, dynamic> variables = {};

      if (threadId != null) variables.putIfAbsent('threadId', () => threadId);
      if (receiverId != null) {
        variables.putIfAbsent('receiverId', () => receiverId);
      }
      if (fromMessageId != null) {
        variables.putIfAbsent('messageIdToStartSearch', () => fromMessageId);
      }

      final result = await _client.query(gql(q), variables: variables);
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      var res = result.data!['getPrivateMessageFeed'] as List;
      var data = res.map((e) => Chat.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

//list of people you have chatted with.
  Future<List<ChatsThread>> getUserThreads(
      {int? pageLimit, int? pageNumber}) async {
    String q = r'''
        query getAllThreads($page_limit: Int!, $page_number: Int!) {
          getAllThreads(page_limit: $page_limit, page_number: $page_number) {
             ''' +
        ChatThreadSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get user threads', result.data);
      var res = result.data!['getAllThreads'] as List;
      var data = res.map((e) => ChatsThread.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteThread({required String? id}) async {
    String q = r'''
          query deleteThread($threadId: String!) {
            deleteThread(threadId: $threadId) 
          }''';
    try {
      final result = await _client.query(gql(q), variables: {'threadId': id});
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
          subscription messageLiveFeed($token: String!) {
            messageLiveFeed(token: $token) {
              ''' +
        ChatSchema.schema +
        '''
            }
          }''';
    try {
      final result = _client.subscribe(gql(q), variables: {'token': id});
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

  Future<bool> joinLiveStream({
    required String? channelName,
  }) async {
    print("initiate repo3");
    String q = r'''
             mutation joinLiveStream(
              $channelName:String!
             ){
               joinLiveStream(
                channelName: $channelName
               )
             }''';
    try {
      print("initiate repo4");
      final result = await _client.mutate(gql(q), variables: {
        'channelName': channelName,
      });
      if (result is GraphQLError) {
        print("initiate repo5");
        print(result.message.toString());
        throw GraphQLError(message: result.message);
      }
      Console.log('joinLiveStream', result.data);
      print(result.data!.toString());
      return result.data!['joinLiveStream'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<StreamResponse> initiateLiveStreaming({
    required String? startedAt,
  }) async {
    String q = r'''
             mutation initiateLiveStream(
              $startedAt:String!
             ){
                initiateLiveStream(
                startedAt: $startedAt
               ){
                token,
                channelName
               }
             }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'startedAt': startedAt,
      });
      if (result is GraphQLError) {
        print("initiate repo5");
        print(result.message.toString());
        throw GraphQLError(message: result.message);
      }
      Console.log('Initiate LiveStreaming', result.data);
      print(result.data.toString());
      return StreamResponse.fromJson(result.data!['initiateLiveStream']);
    } catch (e) {
      rethrow;
    }
  }
}