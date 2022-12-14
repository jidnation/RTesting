import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/video_call_repository.dart';

part 'voice_call_event.dart';
part 'voice_call_state.dart';

enum CallMode { video, audio }

enum CallType { private, livestream }

class VoiceCallBloc extends Bloc<VoiceCallEvent, VoiceCallState> {
  final VoiceCallRepository videoCallRepository = VoiceCallRepository();
  VoiceCallBloc() : super(VoiceCallInitial()) {
    on<InitiatePrivateCall>((event, emit) => _initiateCall(event, emit));
    on<AnswerPrivateCall>((event, emit) => _answerPrivateCall(event, emit));
    on<RejectPrivateCall>((event, emit) => _rejectPrivateCall(event, emit));
    on<UpdatePrivateCall>((event, emit) => _updatePrivateCall(event, emit));
    on<CompletePrivateCall>((event, emit) => _completePrivateCall(event, emit));
  }

  _initiateCall(InitiatePrivateCall event, emit) async {
    emit(VoiceCallLoading());
    await videoCallRepository.initiatePrivateCall();
    emit(VoiceCallSuccess());
  }

  _answerPrivateCall(AnswerPrivateCall event, emit) async {}

  _rejectPrivateCall(RejectPrivateCall event, emit) async {}

  _updatePrivateCall(UpdatePrivateCall event, emit) async {}

  _completePrivateCall(CompletePrivateCall event, emit) async {}
}
