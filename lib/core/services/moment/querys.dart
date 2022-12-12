import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../features/home/presentation/views/status/widgets/user_posting.dart';
import '../../utils/app_globals.dart';
import 'graphql_strings.dart' as gql_string;

class MomentQuery {
  static Future<bool> postMoment(
      {required String caption,
      required String videoMediaItem,
      List<String>? hashTags,
      List<String>? mentionList,
      String? sound}) async {
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
    Map<String, dynamic> momentVariables = {
      'caption': caption,
      'videoMediaItem': videoMediaItem,
    };

    ///
    hashTags != null ? momentVariables.addAll({'hashTags': hashTags}) : null;
    mentionList != null
        ? momentVariables.addAll({'mentionList': mentionList})
        : null;
    momentCtrl.audioUrl.value.isNotEmpty
        ? momentVariables.addAll({'sound': momentCtrl.audioUrl.value})
        : null;

    ///

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.createMoment,
      ),
      // (\$caption: String, \$hashTags: [String], \$mentionList: [String], \$sound: String, \$videoMediaItem: String)
      variables: momentVariables,
    ));
    log('from my first-query::::: ${queryResult}');
    return queryResult.data?['createMoment']['authId'] != null;
  }
}
