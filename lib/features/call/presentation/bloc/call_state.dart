part of 'call_bloc.dart';

@immutable
abstract class CallState {}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallSuccess extends CallState {
  final InitiateCallResponse response;

  CallSuccess({required this.response});
}

class CallError extends CallState {
  final String message;

  CallError({required this.message});
}
