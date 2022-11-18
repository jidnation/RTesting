import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/features/dictionary/data/models/add_to_glossarry_response.dart';
import 'package:reach_me/features/dictionary/data/models/get_word_model.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';

class DictionaryDataSource {
  DictionaryDataSource({GraphQLApiClient? client})
      : _client = client ?? GraphQLApiClient();
  final GraphQLApiClient _client;

  //*ADD TO GLOSSARY MUTATION
  Future<AddWordToGlossaryResponse> addToGlossary({
    String? abbr,
    String? meaning,
    String? word,
    String? language,
  }) async {
    String q = r'''
        mutation addWordToGlossary($wordInput: WordInput!){
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

      var res = result.data["getRecentlyAddedWords"] as List;
      final data = res.map((e) => GetRecentlyAddedWord.fromJson(e)).toList();

      return data;
    } catch (e) {
      rethrow;
    }
  }

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
      log('message>>>>>>>>> $res');
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
