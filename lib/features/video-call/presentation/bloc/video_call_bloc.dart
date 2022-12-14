import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_me/core/helper/logger.dart';

import '../../data/repositories/video_call_repository.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

enum CallMode { video, audio }

enum CallType { private, livestream }

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final VideoCallRepository videoCallRepository = VideoCallRepository();
  VideoCallBloc() : super(VideoCallInitial()) {
    on<InitiatePrivateCall>((event, emit) => _initiateCall(event, emit));
    on<AnswerPrivateCall>((event, emit) => _answerPrivateCall(event, emit));
    on<RejectPrivateCall>((event, emit) => _rejectPrivateCall(event, emit));
    on<UpdatePrivateCall>((event, emit) => _updatePrivateCall(event, emit));
    on<CompletePrivateCall>((event, emit) => _completePrivateCall(event, emit));
  }

  _initiateCall(InitiatePrivateCall event, emit) async {
    emit(VideoCallLoading());
    await videoCallRepository.initiatePrivateCall();
   
    emit(VideoCallSuccess());
  }

  _answerPrivateCall(AnswerPrivateCall event, emit) async {}

  _rejectPrivateCall(RejectPrivateCall event, emit) async {}

  _updatePrivateCall(UpdatePrivateCall event, emit) async {}

  _completePrivateCall(CompletePrivateCall event, emit) async {}
}
