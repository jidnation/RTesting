part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSending extends ChatState {}


class UserUploadingImage extends ChatState {}

class ChatUploadError extends ChatState {
  ChatUploadError({this.error});
  final String? error;
}

class GetUserThreadsSuccess extends ChatState {
  GetUserThreadsSuccess({this.userThreads});
  final List<ChatsThread>? userThreads;
}

class DeleteThreadsSuccess extends ChatState {
  DeleteThreadsSuccess({this.isDeleted});
  final bool? isDeleted;
}

class GetThreadMessagesSuccess extends ChatState {
  GetThreadMessagesSuccess({this.chat});
  final Chat? chat;
}

class ChatSendSuccess extends ChatState {
  ChatSendSuccess({this.chat});
  final Chat? chat;
}

class ChatError extends ChatState {
  ChatError({this.error});
  final String? error;
}

class ChatSendError extends ChatState {
  ChatSendError({this.error});
  final String? error;
}
