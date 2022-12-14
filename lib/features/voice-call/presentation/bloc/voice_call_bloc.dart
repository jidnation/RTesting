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
    on<InitiatePrivateAudioCall>((event, emit) => _initiateCall(event, emit));
    on<AnswerPrivateAudioCall>((event, emit) => _answerPrivateCall(event, emit));
    on<RejectPrivateAudioCall>((event, emit) => _rejectPrivateCall(event, emit));
    on<UpdatePrivateAudioCall>((event, emit) => _updatePrivateCall(event, emit));
    on<CompletePrivateAudioCall>((event, emit) => _completePrivateCall(event, emit));
  }

  _initiateCall(InitiatePrivateAudioCall event, emit) async {
    emit(VoiceCallLoading());
    await videoCallRepository.initiatePrivateCall();
    emit(VoiceCallSuccess());
  }

  _answerPrivateCall(AnswerPrivateAudioCall event, emit) async {}

  _rejectPrivateCall(RejectPrivateAudioCall event, emit) async {}

  _updatePrivateCall(UpdatePrivateAudioCall event, emit) async {}

  _completePrivateCall(CompletePrivateAudioCall event, emit) async {}
}
