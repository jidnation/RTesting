import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_me/core/helper/logger.dart';

import '../../data/models/initiate_call_response.dart';
import '../../data/repositories/call_repository.dart';

part 'call_event.dart';
part 'call_state.dart';

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

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository callRepository = CallRepository();
  CallBloc() : super(CallInitial()) {
    on<InitiatePrivateCall>((event, emit) => _initiateCall(event, emit));
    on<AnswerPrivateCall>((event, emit) => _answerPrivateCall(event, emit));
    on<RejectPrivateCall>((event, emit) => _rejectPrivateCall(event, emit));
    on<UpdatePrivateCall>((event, emit) => _updatePrivateCall(event, emit));
    on<CompletePrivateCall>((event, emit) => _completePrivateCall(event, emit));
  }

  _initiateCall(InitiatePrivateCall event, emit) async {
    emit(CallLoading());
    final result = await callRepository.initiatePrivateCall(event);
    Console.log('call result bloc', result);
    result.fold(
      (l) => emit(CallError(message: l)),
      (r) => emit(CallSuccess(response: r)),
    );
  }

  _answerPrivateCall(AnswerPrivateCall event, emit) {
    callRepository.answerPrivateCall(event);
  }

  _rejectPrivateCall(RejectPrivateCall event, emit) async {
    callRepository.rejectPrivateCall(event);
  }

  _updatePrivateCall(UpdatePrivateCall event, emit) async {
    
  }

  _completePrivateCall(CompletePrivateCall event, emit) async {}
}
