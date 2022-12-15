import 'package:dartz/dartz.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:reach_me/features/video-call/data/models/inititate_call_response.dart';

import '../../presentation/bloc/video_call_bloc.dart';
import '../datasources/call_remote_datasource.dart';

class VideoCallRepository {
  VideoCallRepository({VideoCallRemoteDataSource? videoCallRemoteDataSource})
      : _videoCallRemoteDataSource =
            videoCallRemoteDataSource ?? VideoCallRemoteDataSource();

  final VideoCallRemoteDataSource _videoCallRemoteDataSource;

  Future<Either<String, InitiateCallResponse?>> initiatePrivateCall(
      InitiatePrivateVideoCall privateCall) async {
    try {
      final InitiateCallResponse? response =
          await _videoCallRemoteDataSource.initiatePrivateCall(privateCall);
      return Right(response!);
    } on GraphQLError catch (e) {
      return Left(e.message!);
    }
  }

  answerPrivateCall() {}

  completePrivateCall() {}

  rejectPrivateCall() {}

  updatePrivateCall() {}
}
