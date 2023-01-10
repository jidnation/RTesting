part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class GetUserThreadsEvent extends ChatEvent {
  GetUserThreadsEvent({required this.id});
  final String? id;
}

class GetThreadMessagesEvent extends ChatEvent {
  GetThreadMessagesEvent({required this.id, this.fromMessageId});
  final String? id;
  final String? fromMessageId;
}

class DeleteThreadEvent extends ChatEvent {
  DeleteThreadEvent({required this.id, this.fromMessageId});
  final String? id;
  final String? fromMessageId;
}

class SubcribeToChatStreamEvent extends ChatEvent {
  SubcribeToChatStreamEvent({required this.id});
  final String? id;
}

class SendChatMessageEvent extends ChatEvent {
  SendChatMessageEvent({
    required this.senderId,
    required this.receiverId,
    required this.threadId,
    required this.value,
    required this.type,
    required this.sentAt,
    required this.messageMode,
  });
  final String? senderId;
  final String? receiverId;
  final String? threadId;
  final String? value;
  final String? type;
  final String? sentAt;
  final String? messageMode;
}

class SendImageMessageEvent extends ChatEvent {
  SendImageMessageEvent({
    required this.senderId,
    required this.receiverId,
    required this.threadId,
    required this.value,
    required this.type,
  });
  final String? senderId;
  final String? receiverId;
  final String? threadId;
  final String? value;
  final String? type;
}

class UploadImageFileEvent extends ChatEvent {
  UploadImageFileEvent({required this.file});
  final File file;
}

class InitiateLiveStreamEvent extends ChatEvent {
  final String startedAt;

  InitiateLiveStreamEvent({required this.startedAt});
}

class JoinStreamEvent extends ChatEvent {
  final String channelName;
  JoinStreamEvent({required this.channelName});
}
