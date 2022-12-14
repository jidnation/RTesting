import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/video_call_repository.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

enum CallMode { video, audio }

enum CallType { private, livestream }

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final VideoCallRepository videoCallRepository = VideoCallRepository();
  VideoCallBloc() : super(VideoCallInitial()) {
    on<InitiatePrivateVideoCall>((event, emit) => _initiateCall(event, emit));
    on<AnswerPrivateVideoCall>((event, emit) => _answerPrivateCall(event, emit));
    on<RejectPrivateVideoCall>((event, emit) => _rejectPrivateCall(event, emit));
    on<UpdatePrivateVideoCall>((event, emit) => _updatePrivateCall(event, emit));
    on<CompletePrivateVideoCall>((event, emit) => _completePrivateCall(event, emit));
  }

  _initiateCall(InitiatePrivateVideoCall event, emit) async {
    emit(VideoCallLoading());
    await videoCallRepository.initiatePrivateCall(event);
    emit(VideoCallSuccess());
  }

  _answerPrivateCall(AnswerPrivateVideoCall event, emit) async {}

  _rejectPrivateCall(RejectPrivateVideoCall event, emit) async {}

  _updatePrivateCall(UpdatePrivateVideoCall event, emit) async {}

  _completePrivateCall(CompletePrivateVideoCall event, emit) async {}
}
