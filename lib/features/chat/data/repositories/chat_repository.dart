import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/home/data/models/stream_model.dart';

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
    String? quotedData,
    required String messageMode,
  }) async {
    try {
      final chat = await _chatRemoteDataSource.sendTextMessage(
          senderId: senderId,
          receiverId: receiverId,
          threadId: threadId,
          value: value,
          type: type,
          messageMode: messageMode,
          quotedData: quotedData);
      return Right(chat);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<Chat>>> getThreadMessages({
    String? threadId,
    String? receiverId,
    String? fromMessageId,
  }) async {
    try {
      final chat = await _chatRemoteDataSource.getThreadMessages(
        threadId: threadId,
        receiverId: receiverId,
        fromMessageId: fromMessageId,
      );
      return Right(chat);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<ChatsThread>>> getUserThreads(
      {int? pageLimit, int? pageNumber}) async {
    try {
      final userThreads = await _chatRemoteDataSource.getUserThreads(
          pageNumber: pageNumber, pageLimit: pageLimit);
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

  Future<Either<String, String>> uploadPhoto({File? file}) async {
    try {
      //TODO: WORK ON THIS
      final user = await _apiClient.uploadImage(url: '', file: file!);
      final String imgUrl = user['data'];
      return Right(imgUrl);
    } on DioError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, StreamResponse>> initiateLiveStream({
    required String startedAt,
  }) async {
    print("initiate repo");
    try {
      final initiate = await _chatRemoteDataSource.initiateLiveStreaming(
          startedAt: startedAt);
      print("initiate repo2");
      return Right(initiate);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> joinStream({
    required String? channelName,
  }) async {
    try {
      print("initiate repo2");
      final join =
          await _chatRemoteDataSource.joinLiveStream(channelName: channelName);

      return Right(join);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }
}
