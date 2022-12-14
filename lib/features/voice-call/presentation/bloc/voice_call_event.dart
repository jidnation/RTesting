part of 'voice_call_bloc.dart';

@immutable
abstract class VoiceCallEvent {}

class InitiatePrivateAudioCall extends VoiceCallEvent {
  final CallMode callMode;
  final CallType callType;
  final DateTime? dateTime = DateTime.now();
  final String receiverId;

  InitiatePrivateAudioCall({required this.callMode, required this.callType,required this.receiverId,});
}

class AnswerPrivateAudioCall extends VoiceCallEvent {}

class RejectPrivateAudioCall extends VoiceCallEvent {}

class UpdatePrivateAudioCall extends VoiceCallEvent {}

class CompletePrivateAudioCall extends VoiceCallEvent {}
