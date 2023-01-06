import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';

import '../../../../core/services/graphql/gql_client.dart';
import '../../presentation/bloc/call_bloc.dart';
import '../models/initiate_call_response.dart';

class CallRemoteDataSource {
  CallRemoteDataSource({GraphQLChatClient? client})
      : _client = client ?? GraphQLChatClient();
  final GraphQLChatClient _client;

  Future<InitiateCallResponse> initiatePrivateCall(
      InitiatePrivateCall privateCall) async {
        
    String q = '''
            mutation{
  initiatePrivateCall(
    data:{
      receiverId:"${privateCall.receiverId}"
      callMode:"${privateCall.callMode.type}"
      callType:"${privateCall.callType.type}"
      initiatedAt:"${privateCall.dateTime}"
    }
  ){
    token
    channelName
  }
}
                ''';
    try {
      var result = await _client.mutate(gql(q), variables: {});
      Console.log('call result', result);
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return InitiateCallResponse.fromJson(result.data['initiatePrivateCall']);
    } catch (e) {
      Console.log('call result', e);
      rethrow;
    }
  }

  Future<dynamic> answerPrivateCall(AnswerPrivateCall privateCall) async {}

  Future<dynamic> completePrivateCall() async {}

  Future<dynamic> rejectPrivateCall(RejectPrivateCall privateCall) async {}

  Future<dynamic> updatePrivateCall() async {}
}
