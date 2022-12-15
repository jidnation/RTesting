part of 'video_call_bloc.dart';

@immutable
abstract class VideoCallState {}

class VideoCallInitial extends VideoCallState {}

class VideoCallLoading extends VideoCallState {}

class VideoCallSuccess extends VideoCallState {
  final InitiateCallResponse response;

  VideoCallSuccess({required this.response});
}

class VideoCallError extends VideoCallState {
  final String message;

  VideoCallError({required this.message});
}
