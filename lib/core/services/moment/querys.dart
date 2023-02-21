import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/endpoints.dart';

import '../../../features/moment/momentControlRoom/models/comment_reply.dart';
import '../../../features/moment/momentControlRoom/models/get_comments_model.dart';
import '../../../features/moment/momentControlRoom/models/get_moment_feed.dart';
import '../../../features/moment/user_posting.dart';
import '../../utils/app_globals.dart';
import 'graphql_strings.dart' as gql_string;

class MomentQuery {
  static String hostUrl = "${Endpoints.graphQLBaseUrl}/";
  static Future<bool> postMoment(
      {required String videoMediaItem,
      List<String>? hashTags,
      List<String>? mentionList,
      String? sound}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
    momentCtrl.audioName.value.isNotEmpty
        ? momentVariables.addAll({'musicName': momentCtrl.audioName.value})
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
      hostUrl,
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

  deleteMomentCommentReply(
      {required String commentId, required String replyId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'replyId': replyId,
      'commentId': commentId,
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.deleteMomentCommentReply,
      ),
      variables: momentVariables,
    ));
    log('from my delete-moment comment-reply query::::: ${queryResult}');
    return queryResult.data?['deleteMomentCommentReply'];
  }

  likeMoment({required String momentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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

  replyPostComment(
      {required String postId,
      required commentId,
      required String content}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'postId': postId,
      'commentId': commentId,
      'content': content,
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.replyPostComment,
      ),
      variables: momentVariables,
    ));
    log('from my post comment reply::::: $queryResult');
    return queryResult.data?['replyCommentOnPost']['authId'] != null;
  }

  Future<bool> likeMomentComment(
      {required String momentId, required String commentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'momentId': momentId,
      'commentId': commentId,
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.likeMomentComment,
      ),
      variables: momentVariables,
    ));
    log('from my moment-Liking-query::::: $queryResult');
    return queryResult.data?['likeMomentComment']['authId'] != null;
  }

  Future<bool> likePostComment(
      {required String postId, required String commentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'postId': postId,
      'commentId': commentId,
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.likePostComment,
      ),
      variables: momentVariables,
    ));
    log('from my moment-Liking-query::::: $queryResult');
    return queryResult.data?['likeCommentOnPost']['authId'] != null;
  }

  Future<bool> likeCommentReply(
      {required String momentId,
      required String commentId,
      required String replyId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'replyId': replyId,
      'momentId': momentId,
      'commentId': commentId,
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.likeStreakCommentReply,
      ),
      variables: momentVariables,
    ));
    log('from my moment-Liking-query::::: $queryResult');
    // return false;
    return queryResult.data?['likeMomentReply']['authId'] != null;
  }

  createMomentComment({
    required String momentId,
    required String momentOwnerId,
    String? userComment,
    String? videoUrl,
    String? audioUrl,
    List<String>? images,
  }) async {
    HttpLink link = HttpLink(
      hostUrl,
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    // final store = await HiveStore.open(path: 'my/cache/path');
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
    // {content : $content, audioMediaItem: $sound, momentOwnerId: $momentOwnerId, imageMediaItems: $imageList, videoMediaItem: $videoUrl}

    Map<String, dynamic> commentBody = {
      'momentId': momentId,
      'momentOwnerId': momentOwnerId
    };
    userComment != null ? commentBody.addAll({'content': userComment}) : null;
    images != null ? commentBody.addAll({'imageMediaItems': images}) : null;
    audioUrl != null ? commentBody.addAll({'audioMediaItem': audioUrl}) : null;
    videoUrl != null ? commentBody.addAll({'videoMediaItem': videoUrl}) : null;

    Map<String, dynamic> momentVariables = {'commentBody': commentBody};

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.createMomentComment,
      ),
      variables: momentVariables,
    ));
    log('from my moment-Liking-query::::: $queryResult');
    return queryResult.data?['createMomentComment']['authId'] != null;
  }

  // ($momentId: String!, $commentId: String!, $content: String!)
  replyMomentComment(
      {required String momentId,
      required String commentId,
      required String content}) async {
    HttpLink link = HttpLink(
      hostUrl,
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    // final store = await HiveStore.open(path: 'my/cache/path');
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    Map<String, dynamic> commentBody = {
      'momentId': momentId,
      'commentId': commentId,
      'content': content,
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.replyMomentComment,
      ),
      variables: commentBody,
    ));
    log('from my reply comment-query::::: $queryResult');
    return queryResult.data?['replyMomentComment']['authId'] != null;
  }

  Future<List<GetMomentCommentReply>?> getStreakCommentReplies(
      {required String momentId, required String commentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    Map<String, dynamic> queryVariables = {
      "commentId": commentId,
      "momentId": momentId,
      "pageLimit": 30,
      "pageNumber": 1
    };

    QueryResult queryResult = await qlClient.query(
      // here it's get type so using query method
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getMomentCommentReplies,
          ),
          variables: queryVariables),
    );
    if (queryResult.data != null) {
      log(":::::: from getCommentReplies:::: ${queryResult.data}");
      return CommentReplyModel.fromJson(queryResult.data!)
          .getMomentCommentReplies;
    } else {
      log(":::::: from getCommentReplies:: e:: ${queryResult.exception}");
      return null;
    }
  }

  reachUser({required String reachingId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
        gql_string.reachUser,
      ),
      variables: momentVariables,
    ));
    log('from the reaching user end::::: $queryResult');
    // return queryResult.data?['likeMoment']['authId'] != null;
  }

  unlikeMoment({required String momentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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

  unlikeMomentComment(
      {required String commentId, required String likeId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'commentId': commentId,
      'likeId': likeId
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.unlikeMomentComment,
      ),
      variables: momentVariables,
    ));
    log('from my moment-unLiking-query::::: $queryResult');
    return queryResult.data?['unlikeMomentComment'] ?? false;
  }

  unlikeMomentCommentReply(
      {required String commentId, required String replyId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'commentId': commentId,
      'replyId': replyId
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.unlikeMomentCommentReply,
      ),
      variables: momentVariables,
    ));
    log('from my moment-comment-reply-unLiking-query::::: $queryResult');
    return queryResult.data?['unlikeMomentReply'] ?? false;
  }

  unlikeCommentPost({required String commentId, required String likeId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'commentId': commentId,
      'likeId': likeId
    };

    QueryResult queryResult = await qlClient.mutate(MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.unlikePostComment,
      ),
      variables: momentVariables,
    ));
    log('from my comment-post-unLiking-query::::: $queryResult');
    return queryResult.data?['unlikeCommentOnPost'] != 'false';
  }

  Future<MomentFeedModel?>? getAllFeeds(
      {required int pageLimit,
      required int pageNumber,
      String? authIdToGet}) async {
    HttpLink link = HttpLink(
      hostUrl,
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
    log('from my feed-query::????????::: $queryResult');
    if (queryResult.data != null) {
      return MomentFeedModel.fromJson(queryResult.data!);
    } else {
      return null;
    }
  }

  Future<Moment?>? getMoment({required String momentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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

  Future<GetMomentComment?>? getMomentComment(
      {required String commentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
      defaultHeaders: <String, String>{
        'Authorization': 'Bearer ${globals.token}',
      },
    );
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );

    Map<String, dynamic> queryVariables = {'commentId': commentId};

    QueryResult queryResult = await qlClient.query(
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getMomentComment,
          ),
          variables: queryVariables),
    );
    log('from getting commentInfo-query::::: $queryResult');
    if (queryResult.data != null) {
      return GetMomentComment.fromJson(queryResult.data!['getMomentComment']);
    } else {
      return null;
    }
  }

  static getMomentLikes({required String momentId}) async {
    HttpLink link = HttpLink(
      hostUrl,
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

  Future<List<GetMomentComment>?>? getMomentComments({
    required String momentId,
    int? pageLimit,
    int? pageNumber,
  }) async {
    HttpLink link = HttpLink(
      hostUrl,
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
      'pageNumber': pageNumber ?? 1,
      'pageLimit': pageLimit ?? 30,
    };

    print(':::::::::::::from checking plug::::: $queryVariables');
    QueryResult queryResult = await qlClient.query(
      // here it's get type so using query method
      QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
            gql_string.getMomentComments,
          ),
          variables: queryVariables),
    );
    log('from my moment-comments-query::::: $queryResult');
    if (queryResult.data != null) {
      return MomentCommentModel.fromJson(queryResult.data!).getMomentComments;
    } else {
      return null;
    }
  }
}
