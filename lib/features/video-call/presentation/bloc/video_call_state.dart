part of 'video_call_bloc.dart';

@immutable
abstract class VideoCallState {}


class VideoCallInitial extends VideoCallState{}

class VideoCallLoading extends VideoCallState{}

class VideoCallSuccess extends VideoCallState{}

class VideoCallError extends VideoCallState{}