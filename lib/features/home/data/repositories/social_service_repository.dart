import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/home/data/datasources/home_remote_datasource.dart';
import 'package:reach_me/features/home/data/dtos/create.status.dto.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';

class SocialServiceRepository {
  SocialServiceRepository(
      {HomeRemoteDataSource? homeRemoteDataSource, ApiClient? apiClient})
      : _homeRemoteDataSource = homeRemoteDataSource ?? HomeRemoteDataSource(),
        _apiClient = apiClient ?? ApiClient();

  final HomeRemoteDataSource _homeRemoteDataSource;
  final ApiClient _apiClient;

  Future<Either<String, PostModel>> createPost({
    String? audioMediaItem,
    String? commentOption,
    String? content,
    List<String>? imageMediaItems,
    String? videoMediaItem,
    String? location,
  }) async {
    try {
      final post = await _homeRemoteDataSource.createPost(
        audioMediaItem: audioMediaItem,
        commentOption: commentOption,
        content: content,
        imageMediaItems: imageMediaItems,
        videoMediaItem: videoMediaItem,
        location: location,
      );
      return Right(post);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, PostModel>> editContent({
    required String postId,
    required String content,
  }) async {
    try {
      final post = await _homeRemoteDataSource.editContent(
        postId: postId,
        content: content,
      );
      return Right(post);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deletePost({
    required String postId,
  }) async {
    try {
      final post = await _homeRemoteDataSource.deletePost(postId: postId);
      return Right(post);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, PostLikeModel>> likePost({
    required String postId,
  }) async {
    try {
      final post = await _homeRemoteDataSource.likePost(postId: postId);
      return Right(post);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> unlikePost({
    required String postId,
  }) async {
    try {
      final post = await _homeRemoteDataSource.unlikePost(postId: postId);
      return Right(post);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, CommentModel>> commentOnPost(
      {required String postId,
      required String content,
      required String userId,
      required String postOwnerId}) async {
    try {
      final comment = await _homeRemoteDataSource.commentOnPost(
        postId: postId,
        content: content,
        userId: userId,
        postOwnerId: postOwnerId,
      );
      return Right(comment);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, CommentModel>> deletePostComment(
      {required String commentId}) async {
    try {
      final comment = await _homeRemoteDataSource.deletePostComment(
        commentId: commentId,
      );
      return Right(comment);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> votePost({
    required String voteType,
    required String postId,
  }) async {
    try {
      final vote = await _homeRemoteDataSource.votePost(
        voteType: voteType,
        postId: postId,
      );
      return Right(vote);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deletePostVote({
    required String voteId,
  }) async {
    try {
      final vote = await _homeRemoteDataSource.deletePostVote(voteId: voteId);
      return Right(vote);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, CommentLikeModel>> likeCommentOnPost({
    required String postId,
    required String commentId,
  }) async {
    try {
      final comment = await _homeRemoteDataSource.likeCommentOnPost(
        postId: postId,
        commentId: commentId,
      );
      return Right(comment);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> unlikeCommentOnPost({
    required String commentLikeId,
    required String postId,
  }) async {
    try {
      final comment = await _homeRemoteDataSource.unlikeCommentOnPost(
        commentId: commentLikeId,
        postId: postId,
      );
      return Right(comment);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> checkCommentLike({
    required String commentLikeId,
  }) async {
    try {
      final comment = await _homeRemoteDataSource.checkCommentLike(
        commentLikeId: commentLikeId,
      );
      return Right(comment);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> checkPostLike({
    required String postId,
  }) async {
    try {
      final post = await _homeRemoteDataSource.checkPostLike(
        postId: postId,
      );
      return Right(post);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, String>> checkPostVote({
    required String postId,
  }) async {
    try {
      final vote = await _homeRemoteDataSource.checkPostVote(
        postId: postId,
      );
      return Right(vote);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<CommentLikeModel>>> getAllCommentLikes({
    required String commentId,
  }) async {
    try {
      final comments = await _homeRemoteDataSource.getAllCommentLikes(
        commentId: commentId,
      );
      return Right(comments);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<CommentModel>>> getAllCommentsOnPost({
    required String postId,
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    try {
      final comments = await _homeRemoteDataSource.getAllCommentsOnPost(
        postId: postId,
        pageLimit: pageLimit,
        pageNumber: pageNumber,
      );
      return Right(comments);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<CommentModel>>> getPersonalComments({
    String? authId,
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    try {
      final comments = await _homeRemoteDataSource.getPersonalComments(
        authId: authId,
        pageLimit: pageLimit,
        pageNumber: pageNumber,
      );
      return Right(comments);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<VirtualPostLikeModel>>> getLikesOnPost({
    required String postId,
  }) async {
    try {
      final virtualPosts = await _homeRemoteDataSource.getLikesOnPost(
        postId: postId,
      );
      return Right(virtualPosts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, PostModel>> getPost({
    required String postId,
  }) async {
    try {
      final virtualPost = await _homeRemoteDataSource.getPost(
        postId: postId,
      );
      return Right(virtualPost);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, VirtualCommentModel>> getSingleCommentOnPost({
    required String postId,
  }) async {
    try {
      final virtualComment = await _homeRemoteDataSource.getSingleCommentOnPost(
        postId: postId,
      );
      return Right(virtualComment);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<PostFeedModel>>> getPostFeed({
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    try {
      final postFeeds = await _homeRemoteDataSource.getPostFeed(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
      );
      print("Post Feed comment options ${postFeeds[0].post!.commentOption}");
      return Right(postFeeds);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<PostModel>>> getAllPosts({
    required int? pageLimit,
    required int? pageNumber,
    String? authId,
  }) async {
    try {
      final posts = await _homeRemoteDataSource.getAllPosts(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
        authId: authId,
      );
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<SavePostModel>>> getAllSavedPosts({
    required int pageLimit,
    required int pageNumber,
  }) async {
    try {
      final posts = await _homeRemoteDataSource.getAllSavedPosts(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
      );
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, SavePostModel>> savePost({
    required String postId,
  }) async {
    try {
      final posts = await _homeRemoteDataSource.savePost(
        postId: postId,
      );
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deleteSavedPost({
    required String postId,
  }) async {
    try {
      final isDeleted = await _homeRemoteDataSource.deleteSavedPost(
        postId: postId,
      );
      return Right(isDeleted);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> deleteStatus({
    required String statusId,
  }) async {
    try {
      final isDeleted = await _homeRemoteDataSource.deleteStatus(
        statusId: statusId,
      );
      return Right(isDeleted);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, MutedStatusModel>> muteStatus({
    required String idToMute,
  }) async {
    try {
      final res = await _homeRemoteDataSource.muteStatus(idToMute: idToMute);
      return Right(res);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> unmuteStatus({
    required String idToUnmute,
  }) async {
    try {
      final res =
          await _homeRemoteDataSource.unmuteStatus(idToUnmute: idToUnmute);
      return Right(res);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, ReportStatusModel>> reportStatus({
    required String statusId,
    required String reportReason,
  }) async {
    try {
      final res = await _homeRemoteDataSource.reportStatus(
          statusId: statusId, reportReason: reportReason);
      return Right(res);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<StatusModel>>> getAllStatus({
    required int pageLimit,
    required int pageNumber,
  }) async {
    try {
      final posts = await _homeRemoteDataSource.getAllStatus(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
      );
      print(posts);
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<StatusFeedModel>>> getStatusFeed({
    required int pageLimit,
    required int pageNumber,
  }) async {
    try {
      final status = await _homeRemoteDataSource.getStatusFeed(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
      );
      print(status);
      return Right(status);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, StatusModel>> getStatus({
    required String statusId,
  }) async {
    try {
      final posts = await _homeRemoteDataSource.getStatus(statusId: statusId);
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, StatusModel>> createStatus({
    required CreateStatusDto createStatusDto,
  }) async {
    try {
      final posts = await _homeRemoteDataSource.createStatus(
          createStatusDto: createStatusDto);
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<ProfileIndexModel>>> searchProfile({
    required int pageLimit,
    required int pageNumber,
    required String name,
  }) async {
    try {
      final users = await _homeRemoteDataSource.searchProfile(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
        name: name,
      );
      return Right(users);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<PostFeedModel>>> getLikedPosts(
      {required int pageLimit, required int pageNumber, String? authId}) async {
    try {
      final posts = await _homeRemoteDataSource.getLikedPosts(
          pageLimit: pageLimit, pageNumber: pageNumber, authId: authId);
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<PostFeedModel>>> getVotedPosts(
      {required int pageLimit,
      required int pageNumber,
      required String authId,
      required String voteType}) async {
    try {
      final posts = await _homeRemoteDataSource.getVotedPosts(
          pageLimit: pageLimit,
          pageNumber: pageNumber,
          voteType: voteType,
          authId: authId);
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<User>>> suggestUser() async {
    try {
      final users = await _homeRemoteDataSource.suggestUser();
      return Right(users);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }
}
