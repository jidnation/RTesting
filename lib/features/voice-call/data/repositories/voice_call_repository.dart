import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/helper/logger.dart';
import '../../../video-call/data/models/inititate_call_response.dart';
import '../../presentation/bloc/voice_call_bloc.dart';
import '../datasources/audio_call_remote_datasource.dart';

class VoiceCallRepository {
  VoiceCallRepository({VoiceCallRemoteDataSource? voiceCallRemoteDataSource})
      : _voiceCallRemoteDataSource =
            voiceCallRemoteDataSource ?? VoiceCallRemoteDataSource();

  final VoiceCallRemoteDataSource _voiceCallRemoteDataSource;

   Future<Either<String, InitiateCallResponse>> initiatePrivateCall(
      InitiatePrivateAudioCall privateCall) async {
    try {
      final InitiateCallResponse response =
          await _voiceCallRemoteDataSource.initiatePrivateCall(privateCall);
      Console.log('call response', response);
      return Right(response);
    } on GraphQLError catch (e) {
            Console.log('call response', e);

      return Left(e.message);
    }
  }

  answerPrivateCall() {}

  completePrivateCall() {}

  rejectPrivateCall() {}

  updatePrivateCall() {}
}
