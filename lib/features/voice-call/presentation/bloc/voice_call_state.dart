part of 'voice_call_bloc.dart';

@immutable
abstract class VoiceCallState {}


class VoiceCallInitial extends VoiceCallState{}

class VoiceCallLoading extends VoiceCallState{}

class VoiceCallSuccess extends VoiceCallState{}

class VoiceCallError extends VoiceCallState{}