import '../../../../core/services/graphql/gql_client.dart';
class VoiceCallRemoteDataSource {
  VoiceCallRemoteDataSource({GraphQLChatClient? client})
      : _client = client ?? GraphQLChatClient();
  final GraphQLChatClient _client;

  Future<dynamic> initiatePrivateCall(
   ) async {}

  Future<dynamic> answerPrivateCall() async {}

  Future<dynamic> completePrivateCall() async {}

  Future<dynamic> rejectPrivateCall() async {}

  Future<dynamic> updatePrivateCall() async {}

  // Future<dynamic> testNotifications() async {
  //   String q = '''
  //         mutation {
  //           testNotification(
  //             payload:{
  //               title: "title"
  //               message: "message"
  //             }
  //           )
  //         }
  //     ''';
  //   try {
  //     final result = await _client.mutate(gql(q), variables: {});
  //     if (result is GraphQLError) {
  //       Console.log('error message', result);
  //       throw GraphQLError(message: result.message);
  //     }
  //     Console.log('notification response', result.data);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
