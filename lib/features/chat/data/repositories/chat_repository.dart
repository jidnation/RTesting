import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';

// abstract class IChatRepository {
//   Future<Either<String, User>> createAccount({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     String? phoneNumber,
//   });
// }

class ChatRepository {
  ChatRepository(
      {ChatRemoteDataSource? chatRemoteDataSource, ApiClient? apiClient})
      : _chatRemoteDataSource = chatRemoteDataSource ?? ChatRemoteDataSource(),
        _apiClient = apiClient ?? ApiClient();

  final ChatRemoteDataSource _chatRemoteDataSource;
  final ApiClient _apiClient;

  // @override
  Future<Either<String, Chat>> sendTextMessage({
    required String? senderId,
    required String? receiverId,
    required String? threadId,
    required String? value,
    required String? type,
  }) async {
    try {
      final chat = await _chatRemoteDataSource.sendTextMessage(
        senderId: senderId,
        receiverId: receiverId,
        threadId: threadId,
        value: value,
        type: type,
      );
      return Right(chat);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<Chat>>> getThreadMessages({
    required String? id,
    String? fromMessageId,
  }) async {
    try {
      final chat = await _chatRemoteDataSource.getThreadMessages(
        id: id,
        fromMessageId: fromMessageId,
      );
      return Right(chat);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<ChatsThread>>> getUserThreads(
      {required String? id}) async {
    try {
      final userThreads = await _chatRemoteDataSource.getUserThreads(id: id);
      return Right(userThreads);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deleteThread({required String? id}) async {
    try {
      final isDeleted = await _chatRemoteDataSource.deleteThread(id: id);
      return Right(isDeleted);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Stream<QueryResult> subcribeToChats({required String? id}) {
    final stream = _chatRemoteDataSource.subscribeToChats(id: id);
    return stream;
  }

  Future<Either<String, String>> uploadPhoto({XFile? file}) async {
    try {
      final user = await _apiClient.uploadImage(file!);
      final String imgUrl = user['data'];
      return Right(imgUrl);
    } on DioError catch (e) {
      return Left(e.message);
    }
  }
}
