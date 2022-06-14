import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/services/api/api_client.dart';
import 'package:reach_me/features/home/data/datasources/home_remote_datasource.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
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
  }) async {
    try {
      final post = await _homeRemoteDataSource.createPost(
        audioMediaItem: audioMediaItem,
        commentOption: commentOption,
        content: content,
        imageMediaItems: imageMediaItems,
        videoMediaItem: videoMediaItem,
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

  Future<Either<String, bool>> likePost({
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

  Future<Either<String, CommentModel>> commentOnPost({
    required String postId,
    required String content,
    required String userId,
  }) async {
    try {
      final comment = await _homeRemoteDataSource.commentOnPost(
        postId: postId,
        content: content,
        userId: userId,
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

  Future<Either<String, PostVoteModel>> votePost({
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

  Future<Either<String, String>> deletePostVote({
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
  }) async {
    try {
      final comment = await _homeRemoteDataSource.unlikeCommentOnPost(
        commentLikeId: commentLikeId,
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
      return Right(postFeeds);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<PostModel>>> getAllPosts({
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    try {
      final posts = await _homeRemoteDataSource.getAllPosts(
        pageLimit: pageLimit,
        pageNumber: pageNumber,
      );
      return Right(posts);
    } on GraphQLError catch (e) {
      return Left(e.message);
    }
  }
}