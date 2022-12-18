part of 'video_call_bloc.dart';

@immutable
abstract class VideoCallEvent {}

class InitiatePrivateVideoCall extends VideoCallEvent {
  final CallMode callMode = CallMode.video;
  final CallType callType;
  final String dateTime = DateTime.now().toIso8601String();
  final String receiverId;

  InitiatePrivateVideoCall({ required this.callType,required this.receiverId,});
}

class AnswerPrivateVideoCall extends VideoCallEvent {}

class RejectPrivateVideoCall extends VideoCallEvent {}

class UpdatePrivateVideoCall extends VideoCallEvent {}

class CompletePrivateVideoCall extends VideoCallEvent {}
