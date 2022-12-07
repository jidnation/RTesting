import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../utils/app_globals.dart';
import 'graphql_strings.dart' as gql_string;

class MomentQuery {
  static Future<bool> postMoment(
      {String? name, String? email, String? job}) async {
    HttpLink link = HttpLink(
      "https://api.myreach.me/",
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    // final store = await HiveStore.open(path: 'my/cache/path');
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
    QueryResult queryResult = await qlClient.mutate(
      MutationOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.createMoment,
          ),
          // (\$caption: String, \$hashTags: [String], \$mentionList: [String], \$sound: String, \$videoMediaItem: String)
          variables: const {
            'caption': 'testing',
            'videoMediaItem': 'http://google.com',
            // 'hashTags': [],
            // 'mentionList': [],
            // 'sound': 'http://google.com'
          }),
    );
    log('from my first-query::::: ${queryResult}');
    return queryResult.data?['createUser'] ?? false;
  }
}
