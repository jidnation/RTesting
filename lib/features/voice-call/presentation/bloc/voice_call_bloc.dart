import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../video-call/presentation/bloc/video_call_bloc.dart';
import '../../data/repositories/voice_call_repository.dart';

part 'voice_call_event.dart';
part 'voice_call_state.dart';


class VoiceCallBloc extends Bloc<VoiceCallEvent, VoiceCallState> {
  final VoiceCallRepository voiceCallRepository = VoiceCallRepository();
  VoiceCallBloc() : super(VoiceCallInitial()) {
    on<InitiatePrivateAudioCall>((event, emit) => _initiateCall(event, emit));
    on<AnswerPrivateAudioCall>((event, emit) => _answerPrivateCall(event, emit));
    on<RejectPrivateAudioCall>((event, emit) => _rejectPrivateCall(event, emit));
    on<UpdatePrivateAudioCall>((event, emit) => _updatePrivateCall(event, emit));
    on<CompletePrivateAudioCall>((event, emit) => _completePrivateCall(event, emit));
  }

  _initiateCall(InitiatePrivateAudioCall event, emit) async {
    emit(VoiceCallLoading());
    await voiceCallRepository.initiatePrivateCall(event);
    emit(VoiceCallSuccess());
  }

  _answerPrivateCall(AnswerPrivateAudioCall event, emit) async {}

  _rejectPrivateCall(RejectPrivateAudioCall event, emit) async {}

  _updatePrivateCall(UpdatePrivateAudioCall event, emit) async {}

  _completePrivateCall(CompletePrivateAudioCall event, emit) async {}
}
