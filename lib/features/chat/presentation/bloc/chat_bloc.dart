// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/data/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository = ChatRepository();
  ChatBloc() : super(ChatInitial()) {
    on<GetThreadMessagesEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final response = await chatRepository.getThreadMessages(
          id: event.id,
          fromMessageId: event.fromMessageId,
        );
        response.fold(
          (error) => emit(ChatError(error: error)),
          (chat) {
            globals.userChat = chat;
            emit(GetThreadMessagesSuccess(chat: chat));
          },
        );
      } on GraphQLError catch (e) {
        emit(ChatError(error: e.message));
      }
    });
    on<GetUserThreadsEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final response = await chatRepository.getUserThreads(id: event.id);
        response.fold(
          (error) => emit(ChatError(error: error)),
          (userThreads) {
            globals.userThreads = userThreads;
            emit(GetUserThreadsSuccess(userThreads: userThreads));
          },
        );
      } on GraphQLError catch (e) {
        emit(ChatError(error: e.message));
      }
    });
    on<DeleteThreadEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final response = await chatRepository.deleteThread(id: event.id);
        response.fold(
          (error) => emit(ChatError(error: error)),
          (isDeleted) {
            emit(DeleteThreadsSuccess(isDeleted: isDeleted));
          },
        );
      } on GraphQLError catch (e) {
        emit(ChatError(error: e.message));
      }
    });
    on<SendChatMessageEvent>((event, emit) async {
      emit(ChatSending());
      try {
        final response = await chatRepository.sendTextMessage(
          senderId: event.senderId,
          receiverId: event.receiverId,
          value: event.value,
          type: event.type,
          threadId: event.threadId,
        );
        response.fold(
          (error) => emit(ChatSendError(error: error)),
          (chat) {
            emit(ChatSendSuccess(chat: chat));
          },
        );
      } on GraphQLError catch (e) {
        emit(ChatSendError(error: e.message));
      }
    });
    // on<UploadUserProfilePictureEvent>((event, emit) async {
    //   emit(UserUploadingImage());
    //   String imageUrl = '';
    //   try {
    //     //UPLOAD FILE & GET IMAGE URL
    //     final response = await chatRepository.uploadPhoto(
    //       file: event.file,
    //     );
    //     response.fold(
    //       (error) => emit(UserUploadError(error: error)),
    //       (imgUrl) => imageUrl = imgUrl,
    //     );
    //     //SAVE TO
    //     final userRes = await userRepository.setImage(
    //       imageUrl: imageUrl,
    //       type: 'profilePicture',
    //     );
    //     userRes.fold(
    //       (error) => emit(UserUploadError(error: error)),
    //       (user) {
    //         globals.user = user;
    //         emit(UserUploadProfilePictureSuccess(user: user));
    //       },
    //     );
    //   } on GraphQLError catch (e) {
    //     emit(UserUploadError(error: e.message));
    //   }
    // });
  }
}
