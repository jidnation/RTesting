part of 'video_call_bloc.dart';

@immutable
abstract class VideoCallEvent {}

class InitiateCall extends VideoCallEvent {}

class EndCall extends VideoCallEvent {}
