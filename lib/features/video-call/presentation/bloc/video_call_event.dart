part of 'video_call_bloc.dart';

@immutable
abstract class VideoCallEvent {}

class InitiatePrivateCall extends VideoCallEvent {
  final CallMode callMode;
  final CallType callType;
  final DateTime? dateTime = DateTime.now();
  final String receiverId;

  InitiatePrivateCall({required this.callMode, required this.callType,required this.receiverId,});
}

class AnswerPrivateCall extends VideoCallEvent {}

class RejectPrivateCall extends VideoCallEvent {}

class UpdatePrivateCall extends VideoCallEvent {}

class CompletePrivateCall extends VideoCallEvent {}
