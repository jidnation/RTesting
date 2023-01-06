part of 'call_bloc.dart';

@immutable
abstract class CallEvent {}

class InitiatePrivateCall extends CallEvent {
  final CallMode callMode;
  final CallType callType;
  final String dateTime = DateTime.now().toIso8601String();
  final String receiverId;

  InitiatePrivateCall({
    required this.callMode,
    required this.callType,
    required this.receiverId,
  });
}

class AnswerPrivateCall extends CallEvent {
  final String channelName;

  AnswerPrivateCall({
    required this.channelName,
  });
}

class RejectPrivateCall extends CallEvent {
  final String channelName;
  final String? endedAt = DateTime.now().toIso8601String();

  RejectPrivateCall({
    required this.channelName,
  });
}

class UpdatePrivateCall extends CallEvent {
  final String channelName;
  final bool status = true;
  final String? endedAt = DateTime.now().toIso8601String();

  UpdatePrivateCall({required this.channelName});
}

class CompletePrivateCall extends CallEvent {}
