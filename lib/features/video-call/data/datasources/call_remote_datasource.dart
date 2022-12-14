import '../../../../core/services/graphql/gql_client.dart';
import '../../presentation/bloc/video_call_bloc.dart';

class VideoCallRemoteDataSource {
  VideoCallRemoteDataSource({GraphQLChatClient? client})
      : _client = client ?? GraphQLChatClient();
  final GraphQLChatClient _client;

  Future<dynamic> initiatePrivateCall(
    InitiatePrivateVideoCall privateCall) async {}

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
