import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_me/core/helper/logger.dart';

import '../../data/models/inititate_call_response.dart';
import '../../data/repositories/video_call_repository.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

enum CallMode {
  video('video'),
  audio('audio');

  final String type;
  const CallMode(this.type);
}

enum CallType {
  private('private'),
  group('group'),
  stream('stream');

  final String type;
  const CallType(this.type);
}

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final VideoCallRepository videoCallRepository = VideoCallRepository();
  VideoCallBloc() : super(VideoCallInitial()) {
    on<InitiatePrivateVideoCall>((event, emit) => _initiateCall(event, emit));
    on<AnswerPrivateVideoCall>(
        (event, emit) => _answerPrivateCall(event, emit));
    on<RejectPrivateVideoCall>(
        (event, emit) => _rejectPrivateCall(event, emit));
    on<UpdatePrivateVideoCall>(
        (event, emit) => _updatePrivateCall(event, emit));
    on<CompletePrivateVideoCall>(
        (event, emit) => _completePrivateCall(event, emit));
  }

  _initiateCall(InitiatePrivateVideoCall event, emit) async {
    emit(VideoCallLoading());
    final Either<String, InitiateCallResponse?> result = await videoCallRepository.initiatePrivateCall(event);
    Console.log('call result', result);
    result.fold(
      (l) => emit(VideoCallError()),
      (r) => emit(VideoCallSuccess()),
    );
  }

  _answerPrivateCall(AnswerPrivateVideoCall event, emit) async {}

  _rejectPrivateCall(RejectPrivateVideoCall event, emit) async {}

  _updatePrivateCall(UpdatePrivateVideoCall event, emit) async {}

  _completePrivateCall(CompletePrivateVideoCall event, emit) async {}
}
