part of 'video_call_bloc.dart';

@immutable
abstract class VideoCallEvent {}

class InitiatePrivateVideoCall extends VideoCallEvent {
  final CallMode callMode;
  final CallType callType;
  final DateTime? dateTime = DateTime.now();
  final String receiverId;

  InitiatePrivateVideoCall({required this.callMode, required this.callType,required this.receiverId,});
}

class AnswerPrivateVideoCall extends VideoCallEvent {}

class RejectPrivateVideoCall extends VideoCallEvent {}

class UpdatePrivateVideoCall extends VideoCallEvent {}

class CompletePrivateVideoCall extends VideoCallEvent {}
