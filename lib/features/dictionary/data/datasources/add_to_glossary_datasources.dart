import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/features/dictionary/data/models/add_to_glossarry_response.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added.dart';

class AddToGlossaryDataSource {
  AddToGlossaryDataSource({GraphQLApiClient? client})
      : _client = client ?? GraphQLApiClient();
  final GraphQLApiClient _client;

  //ADD TO GLOSSARY
  Future<AddWordToGlossaryResponse> addToGlossary({
    String? abbr,
    String? meaning,
    String? word,
    String? language,
  }) async {
    String q = r'''
        mutation addWordToGlossary($wordInput: WordInput!){
          addWordToGlossary(wordInput: $wordInput){
            abbr:String!
            meaning:String!
            language:String!
            word:String!
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

  Future<List<GetRecentlyAddedWord>> getRecentWord(
      { required num pageLimit,required num pageNumber}) async {
    const String q =
        r'''  getRecentlyAddedWords(page_limit: $page_Limit, page_number:$page_number){
    abbr
    authId
    meaning
    created_at
    language
    word
    wordId
  }  ''';

    try {
      final result = await _client.query(gql(q),
          variables: {'page_limit': pageLimit, ' page_number': pageNumber});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      var res = result.data['getRecentlyAddedWords'] as List;
      final data = res.map((e) => GetRecentlyAddedWord.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }
}

// class WordInput {
//   String? abbr;
//   String? meaning;
//   String? authId;
//   String? createdAt;
//   String? language;
//   String? word;
//   String? wordId;
// }


