part of 'voice_call_bloc.dart';

@immutable
abstract class VoiceCallEvent {}

class InitiatePrivateCall extends VoiceCallEvent {
  final CallMode callMode;
  final CallType callType;
  final DateTime? dateTime = DateTime.now();
  final String receiverId;

  InitiatePrivateCall({required this.callMode, required this.callType,required this.receiverId,});
}

class AnswerPrivateCall extends VoiceCallEvent {}

class RejectPrivateCall extends VoiceCallEvent {}

class UpdatePrivateCall extends VoiceCallEvent {}

class CompletePrivateCall extends VoiceCallEvent {}
