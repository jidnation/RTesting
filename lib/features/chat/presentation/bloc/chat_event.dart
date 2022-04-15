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

class SendChatMessageEvent extends ChatEvent {
  SendChatMessageEvent({
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

// class UploadUserProfilePictureEvent extends ChatEvent {
//   UploadUserProfilePictureEvent({required this.file});
//   final XFile file;
// }
