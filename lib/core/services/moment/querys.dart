import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../features/home/presentation/views/status/widgets/user_posting.dart';
import '../../../features/momentControlRoom/models/get_moment_feed.dart';
import '../../utils/app_globals.dart';
import 'graphql_strings.dart' as gql_string;

class MomentQuery {
  static Future<bool> postMoment(
      {required String videoMediaItem,
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
      'caption': momentCtrl.caption.value.isNotEmpty
          ? momentCtrl.caption.value
          : 'No Caption',
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

   deleteMoment({required String momentId}) async {
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
    Map<String, dynamic> momentVariables = {'momentId': momentId};

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.deleteMoment,
      ),
      variables: momentVariables,
    ));
    log('from my first-query::::: ${queryResult}');
    // return queryResult.data?['createMoment']['authId'] != null;
  }

  likeMoment({required String momentId}) async {
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
    Map<String, dynamic> momentVariables = {'momentId': momentId};

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.likeMoment,
      ),
      variables: momentVariables,
    ));
    log('from my moment-Liking-query::::: $queryResult');
    return queryResult.data?['likeMoment']['authId'] != null;
  }

  reachUser({required String reachingId}) async {
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
    Map<String, dynamic> momentVariables = {'userIdToReach': reachingId};

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.likeMoment,
      ),
      variables: momentVariables,
    ));
    log('from the reaching user end::::: $queryResult');
    // return queryResult.data?['likeMoment']['authId'] != null;
  }

   unlikeMoment({required String momentId}) async {
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
    Map<String, dynamic> momentVariables = {'momentId': momentId};

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.unlikeMoment,
      ),
      variables: momentVariables,
    ));
    log('from my moment-unLiking-query::::: $queryResult');
    return queryResult.data?['unlikeMoment'] ?? false;
  }

  Future<MomentFeedModel?>? getAllFeeds(
      {required int pageLimit,
      required int pageNumber,
      String? authIdToGet}) async {
    HttpLink link = HttpLink(
      "https://api.myreach.me/",
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    // ($pageLimit: int!, $pageNumber: int!, $authIdToGet: String)
    Map<String, dynamic> queryVariables = {
      'pageLimit': pageLimit,
      'pageNumber': pageNumber
    };

    authIdToGet != null
        ? queryVariables.addAll({'authIdToGet': authIdToGet})
        : null;

    QueryResult queryResult = await qlClient.query(
      // here it's get type so using query method
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getMomentFeed,
          ),
          variables: queryVariables),
    );
    log('from my feed-query::::: $queryResult');
    if (queryResult.data != null) {
      return MomentFeedModel.fromJson(queryResult.data!);
    } else {
      return null;
    }
  }

   Future<Moment?>? getMoment({required String momentId}) async {
    HttpLink link = HttpLink(
      "https://api.myreach.me/",
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    Map<String, dynamic> queryVariables = {'momentId': momentId};

    QueryResult queryResult = await qlClient.query(
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getMoment,
          ),
          variables: queryVariables),
    );
    log('from my moment-query::::: $queryResult');
    if (queryResult.data != null) {
      return Moment.fromJson(queryResult.data!['getMoment']);
    } else {
      return null;
    }
  }

  static getMomentLikes({required String momentId}) async {
    HttpLink link = HttpLink(
      "https://api.myreach.me/",
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    Map<String, dynamic> queryVariables = {'momentId': momentId};

    QueryResult queryResult = await qlClient.query(
      // here it's get type so using query method
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getMomentLikes,
          ),
          variables: queryVariables),
    );
    log('from my moment-query::::: ${queryResult.data?['getMomentLikes']}');
    if (queryResult.data != null) {
      // return GetMomentFeed.fromJson(queryResult.data!);
    } else {
      return null;
    }
  }

  static getMomentComments({
    required String momentId,
    required int pageLimit,
    required int pageNumber,
  }) async {
    HttpLink link = HttpLink(
      "https://api.myreach.me/",
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    Map<String, dynamic> queryVariables = {
      'momentId': momentId,
      'pageNumber': pageNumber,
      'pageLimit': pageLimit,
    };

    QueryResult queryResult = await qlClient.query(
      // here it's get type so using query method
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getMomentComments,
          ),
          variables: queryVariables),
    );
    log('from my moment-query::::: ${queryResult.data?['getMomentComments']}');
    if (queryResult.data != null) {
      // return GetMomentFeed.fromJson(queryResult.data!);
    } else {
      return null;
    }
  }
}
