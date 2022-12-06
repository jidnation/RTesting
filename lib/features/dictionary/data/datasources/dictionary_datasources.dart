import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/features/dictionary/data/models/add_to_glossarry_response.dart';
import 'package:reach_me/features/dictionary/data/models/get_word_model.dart';
import 'package:reach_me/features/dictionary/data/models/gethistory_model.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';

class DictionaryDataSource {
  DictionaryDataSource({GraphQLApiClient? client})
      : _client = client ?? GraphQLApiClient();
  final GraphQLApiClient _client;

  //*DELETE WORD FROM HSITORY
  Future<bool> deleteFromHistory({required String historyId}) async {
    String q = r'''mutation deleteSingleWordHistory($historyId:String!) {
  deleteSingleWordHistory(
    historyId: $historyId
  )
  
}''';
    try {
      Map<String, dynamic> historyInput = {
        "historyId": historyId,
      };
      final deleteHistory =
          await _client.mutate(gql(q), variables: historyInput);
      if (deleteHistory is GraphQLError) {
        throw GraphQLError(message: deleteHistory.message);
      }

      return deleteHistory.data["deleteSingleWordHistory"] as bool;
    } catch (e) {
      return false;
    }
  }

//* DELETE ALL WORDS FROM HISTORY
  Future<bool> deleteAllHistory() async {
    String q = r'''mutation {
  deleteAllWordHistory 
}''';
    try {
      final deleteAllHistory = await _client.mutate(gql(q), variables: {});
      if (deleteAllHistory is GraphQLError) {
        throw GraphQLError(message: deleteAllHistory.message);
      }

      return deleteAllHistory.data["deleteAllWordHistory"] as bool;
    } catch (e) {
      return false;
    }
  }

  //*ADD TO GLOSSARY MUTATION
  Future<AddWordToGlossaryResponse> addToGlossary({
    String? abbr,
    String? meaning,
    String? word,
    String? language,
  }) async {
    String q = r'''
        mutation addWordToGlossary($wordInput: WordInputDto!){
          addWordToGlossary(wordInput: $wordInput){
          abbr
          meaning
          authId
          created_at
          language
          word
          wordId
          }
        }''';
    try {
      Map<String, dynamic> wordInput = {
        "abbr": abbr,
        "meaning": meaning,
        "language": language,
        "word": word
      };

      final result = await _client.mutate(
        gql(q),
        variables: {'wordInput': wordInput},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return AddWordToGlossaryResponse.fromJson(
          result.data!['addWordToGlossary']);
    } catch (e) {
      rethrow;
    }
  }

  //*Get RECENT WORDS QUERY
  Future<List<GetRecentlyAddedWord>> getRecentWord(
      {required num pageLimit, required num pageNumber}) async {
    const String q =
        r'''query getRecentlyAddedWords($page_limit: Float!, $page_number:Float!){
  getRecentlyAddedWords(page_limit: $page_limit, page_number:$page_number){
    abbr
    authId
    meaning
    created_at
    language
    word
    wordId
  }
}''';

    try {
      final result = await _client.query(gql(q),
          variables: {'page_limit': pageLimit, 'page_number': pageNumber});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      final List<dynamic> res = result.data["getRecentlyAddedWords"] as List;
      final data = res.map((e) => GetRecentlyAddedWord.fromJson(e)).toList();

      return data;
    } catch (e) {
      rethrow;
    }
  }

//*GeT Words from database
  Future<List<Map<String, dynamic>>> getWords(
      {required num pageLimit, required num pageNumber}) async {
    const String q =
        r'''query getRecentlyAddedWords($page_limit: Float!, $page_number:Float!){
  getRecentlyAddedWords(page_limit: $page_limit, page_number:$page_number){
    abbr
    authId
    meaning
    created_at
    language
    word
    wordId
  }
}''';

    try {
      final result = await _client.query(gql(q),
          variables: {'page_limit': pageLimit, 'page_number': pageNumber});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      List<Map<String, dynamic>> res =
          (result.data["getRecentlyAddedWords"] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();

      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

//* Search Words
  Future<GetWordClass> searchWords({
    required String wordInput,
  }) async {
    const String q = r'''
    query getWord($word: String!){
    getWord(word: $word){
    abbr
    authId
    meaning
    word
    wordId
  }
}
''';

    try {
      final result =
          await _client.query(gql(q), variables: {'word': wordInput});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Map<String, dynamic> getWordFromDb = result.data['getWord'];
      final res = GetWordClass.fromJson(getWordFromDb);

      return res;
    } catch (e) {
      rethrow;
    }
  }

  //*Get searched Words List
  Future<List<GetSearchedWordsHistory>> getSearchList(
      {required num pageLimit, required num pageNumber}) async {
    const String q = r'''query{
   getSearchedWordsHistory(page_limit: 10, page_number:0){
   word
    created_at
    authId
    historyId
  }
}
 ''';

    try {
      final response = await _client.query(gql(q),
          variables: {'page_limit': pageLimit, 'page_number': pageNumber});
      if (response is GraphQLError) {
        throw GraphQLError(message: response.message);
      }
      final List<dynamic> res =
          response.data["getSearchedWordsHistory"] as List;
      final data = res.map((e) => GetSearchedWordsHistory.fromJson(e)).toList();
      log("message: THIS IS MY HISTORY RESPONSE $data");

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
