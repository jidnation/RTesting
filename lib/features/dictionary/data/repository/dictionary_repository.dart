import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/dictionary/data/datasources/dictionary_datasources.dart';
import 'package:reach_me/features/dictionary/data/models/add_to_glossarry_response.dart';
import 'package:reach_me/features/dictionary/data/models/gethistory_model.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';

class DictionaryRepository {
  DictionaryRepository(
      {DictionaryDataSource? dictionaryDataSource, ApiClient? apiClient})
      : _dictionaryDataSource = dictionaryDataSource ?? DictionaryDataSource(),
        _apiClient = apiClient ?? ApiClient();
  final DictionaryDataSource _dictionaryDataSource;
  final ApiClient _apiClient;

  Future<Either<String, AddWordToGlossaryResponse>> addToGlossary({
    String? abbr,
    String? meaning,
    String? word,
    String? language,
  }) async {
    try {
      final addGlossary = await _dictionaryDataSource.addToGlossary(
          abbr: abbr, meaning: meaning, word: word, language: language);

      return Right(addGlossary);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<GetRecentlyAddedWord>>> getRecentAddedWords({
    required num pageLimit,
    required num pageNumber,
  }) async {
    try {
      final getWords = await _dictionaryDataSource.getRecentWord(
          pageLimit: pageLimit, pageNumber: pageNumber);
      return Right(getWords);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<GetSearchedWordsHistory>>> getWordHistory({
    required num pageLimit,
    required num pageNumber,
  }) async {
    try {
      final getHistory = await _dictionaryDataSource.getSearchList(
          pageLimit: pageLimit, pageNumber: pageNumber);
      return Right(getHistory);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<Map<String, dynamic>>>> addWordsToMentions({
    required num pageLimit,
    required num pageNumber,
  }) async {
    try {
      final getWords = await _dictionaryDataSource.getWords(
          pageLimit: pageLimit, pageNumber: pageNumber);

      return Right(getWords);
    } on GraphQLError catch (e) {
      log(e.toString());
      return Left(e.message);
    }
  }

  Future<Either<String, dynamic>> searchWords(
      {required String wordInput}) async {
    try {
      final searchWords =
          await _dictionaryDataSource.searchWords(wordInput: wordInput);

      return Right(searchWords);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deleteWordHistory(
      {required String historyId}) async {
    try {
      final deleteWordHistory =
          await _dictionaryDataSource.deleteFromHistory(historyId: historyId);
      return Right(deleteWordHistory);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deleteAllHistory() async {
    try {
      final deleteWordHistory = await _dictionaryDataSource.deleteAllHistory();
      return Right(deleteWordHistory);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }
}
