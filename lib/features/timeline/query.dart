import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';

import '/core/services/moment/graphql_strings.dart' as gql_string;
import '../../core/utils/app_globals.dart';
import 'models/post_feed.dart';

class TimeLineQuery {
  Future<List<GetPostFeed>?> getAllPostFeeds(
      {int? pageLimit, int? pageNumber, String? authIdToGet}) async {
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
      'pageLimit': pageLimit ?? 50,
      'pageNumber': pageNumber ?? 1
    };

    authIdToGet != null
        ? queryVariables.addAll({'authIdToGet': authIdToGet})
        : null;

    QueryResult queryResult = await qlClient.query(
      // here it's get type so using query method
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getPostFeeds,
          ),
          variables: queryVariables),
    );
    log('from my timeline-query::::: $queryResult');
    if (queryResult.data != null) {
      return PostFeedModel.fromJson(queryResult.data!).getPostFeed;
    } else {
      return null;
    }
  }

  Future<Post?> getPost({required String postId}) async {
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

    Map<String, dynamic> queryVariables = {'postId': postId};

    QueryResult queryResult = await qlClient.query(
      // here it's get type so using query method
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getPost,
          ),
          variables: queryVariables),
    );
    log('from my timeline-post-getting-query::::: $queryResult');
    if (queryResult.data != null) {
      return Post.fromJson(queryResult.data!['getPost']);
    } else {
      return null;
    }
  }

  Future<bool> likePost({required String postId}) async {
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
    Map<String, dynamic> timeLineVariables = {'postId': postId};

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.likePost,
      ),
      variables: timeLineVariables,
    ));
    log('from my post-Liking-query::::: $queryResult');
    return queryResult.data?['likePost']['authId'] != null;
  }

  Future<bool> votePost(
      {required String postId, required String voteType}) async {
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
    Map<String, dynamic> timeLineVariables = {
      'postId': postId,
      'voteType': voteType
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.votePost,
      ),
      variables: timeLineVariables,
    ));
    log('from my post-voting-query::::: $queryResult');
    return queryResult.data?['votePost'] ?? false;
  }

  unlikePost({required String postId}) async {
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
    Map<String, dynamic> momentVariables = {'postId': postId};

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.unlikePost,
      ),
      variables: momentVariables,
    ));
    log('from my post-unLiking-query::::: $queryResult');
    return queryResult.data?['unlikePost'] ?? false;
  }
}
