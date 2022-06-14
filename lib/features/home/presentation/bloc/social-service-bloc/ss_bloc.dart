import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
import 'package:reach_me/features/home/data/repositories/social_service_repository.dart';

part 'ss_event.dart';
part 'ss_state.dart';

class SocialServiceBloc extends Bloc<SocialServiceEvent, SocialServiceState> {
  final SocialServiceRepository socialServiceRepository =
      SocialServiceRepository();
  SocialServiceBloc() : super(SocialServiceInitial()) {
    on<CreatePostEvent>((event, emit) async {
      emit(CreatePostLoading());
      try {
        final response = await socialServiceRepository.createPost(
          audioMediaItem: event.audioMediaItem,
          imageMediaItems: event.imageMediaItem,
          videoMediaItem: event.videoMediaItem,
          commentOption: event.commentOption,
          content: event.content,
        );
        response.fold(
          (error) => emit(CreatePostError(error: error)),
          (post) {
            Console.log('post data bloc', post.toJson());
            emit(CreatePostSuccess(post: post));
          },
        );
      } on GraphQLError catch (e) {
        emit(CreatePostError(error: e.message));
      }
    });
    on<EditContentEvent>((event, emit) async {
      emit(EditContentLoading());
      try {
        final response = await socialServiceRepository.editContent(
          content: event.content!,
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(EditContentError(error: error)),
          (post) => emit(EditContentSuccess(post: post)),
        );
      } on GraphQLError catch (e) {
        emit(EditContentError(error: e.message));
      }
    });
    on<DeletePostEvent>((event, emit) async {
      emit(DeletePostLoading());
      try {
        final response = await socialServiceRepository.deletePost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(DeletePostError(error: error)),
          (post) => emit(DeletePostSuccess(post: post)),
        );
      } on GraphQLError catch (e) {
        emit(DeletePostError(error: e.message));
      }
    });
    on<LikePostEvent>((event, emit) async {
      emit(LikePostLoading());
      try {
        final response = await socialServiceRepository.likePost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(LikePostError(error: error)),
          (postLike) => emit(LikePostSuccess(isLiked: postLike)),
        );
      } on GraphQLError catch (e) {
        emit(LikePostError(error: e.message));
      }
    });
    on<UnlikePostEvent>((event, emit) async {
      emit(UnlikePostLoading());
      try {
        final response = await socialServiceRepository.unlikePost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(UnlikePostError(error: error)),
          (isUnliked) => emit(UnlikePostSuccess(isUnliked: isUnliked)),
        );
      } on GraphQLError catch (e) {
        emit(UnlikePostError(error: e.message));
      }
    });
    on<CommentOnPostEvent>((event, emit) async {
      emit(CommentOnPostLoading());
      try {
        final response = await socialServiceRepository.commentOnPost(
          postId: event.postId!,
          content: event.content!,
          userId: event.userId!,
        );
        response.fold(
          (error) => emit(CommentOnPostError(error: error)),
          (comment) => emit(CommentOnPostSuccess(commentModel: comment)),
        );
      } on GraphQLError catch (e) {
        emit(CommentOnPostError(error: e.message));
      }
    });
    on<DeletePostCommentEvent>((event, emit) async {
      emit(DeletePostCommentLoading());
      try {
        final response = await socialServiceRepository.deletePostComment(
          commentId: event.commentId!,
        );
        response.fold(
          (error) => emit(DeletePostCommentError(error: error)),
          (comment) => emit(DeletePostCommentSuccess(commentModel: comment)),
        );
      } on GraphQLError catch (e) {
        emit(DeletePostCommentError(error: e.message));
      }
    });
    on<VotePostEvent>((event, emit) async {
      emit(VotePostLoading());
      try {
        final response = await socialServiceRepository.votePost(
          postId: event.postId!,
          voteType: event.voteType!,
        );
        response.fold(
          (error) => emit(VotePostError(error: error)),
          (postVote) => emit(VotePostSuccess(postVoteModel: postVote)),
        );
      } on GraphQLError catch (e) {
        emit(VotePostError(error: e.message));
      }
    });
    on<DeletePostVoteEvent>((event, emit) async {
      emit(DeletePostVoteLoading());
      try {
        final response = await socialServiceRepository.deletePostVote(
          voteId: event.voteId!,
        );
        response.fold(
          (error) => emit(DeletePostVoteError(error: error)),
          (postVote) => emit(DeletePostVoteSuccess(data: postVote)),
        );
      } on GraphQLError catch (e) {
        emit(DeletePostVoteError(error: e.message));
      }
    });
    on<LikeCommentOnPostEvent>((event, emit) async {
      emit(LikeCommentOnPostLoading());
      try {
        final response = await socialServiceRepository.likeCommentOnPost(
          postId: event.postId!,
          commentId: event.commentId!,
        );
        response.fold(
          (error) => emit(LikeCommentOnPostError(error: error)),
          (commentLikeModel) => emit(
              LikeCommentOnPostSuccess(commentLikeModel: commentLikeModel)),
        );
      } on GraphQLError catch (e) {
        emit(LikeCommentOnPostError(error: e.message));
      }
    });
    on<UnlikeCommentOnPostEvent>((event, emit) async {
      emit(UnlikeCommentOnPostLoading());
      try {
        final response = await socialServiceRepository.unlikeCommentOnPost(
          commentLikeId: event.commentLikeId!,
        );
        response.fold(
          (error) => emit(UnlikeCommentOnPostError(error: error)),
          (unlikeComment) =>
              emit(UnlikeCommentOnPostSuccess(unlikeComment: unlikeComment)),
        );
      } on GraphQLError catch (e) {
        emit(UnlikeCommentOnPostError(error: e.message));
      }
    });
    on<CheckCommentLikeEvent>((event, emit) async {
      emit(CheckCommentLikeLoading());
      try {
        final response = await socialServiceRepository.checkCommentLike(
          commentLikeId: event.commentLikeId!,
        );
        response.fold(
          (error) => emit(CheckCommentLikeError(error: error)),
          (checkCommentLike) =>
              emit(CheckCommentLikeSuccess(checkCommentLike: checkCommentLike)),
        );
      } on GraphQLError catch (e) {
        emit(CheckCommentLikeError(error: e.message));
      }
    });
    on<CheckPostLikeEvent>((event, emit) async {
      emit(CheckPostLikeLoading());
      try {
        final response = await socialServiceRepository.checkPostLike(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(CheckPostLikeError(error: error)),
          (checkPostLike) =>
              emit(CheckPostLikeSuccess(checkPostLike: checkPostLike)),
        );
      } on GraphQLError catch (e) {
        emit(CheckPostLikeError(error: e.message));
      }
    });
    on<CheckPostVoteEvent>((event, emit) async {
      emit(CheckPostVoteLoading());
      try {
        final response = await socialServiceRepository.checkPostVote(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(CheckPostVoteError(error: error)),
          (data) => emit(CheckPostVoteSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(CheckPostVoteError(error: e.message));
      }
    });
    on<GetAllCommentLikesEvent>((event, emit) async {
      emit(GetAllCommentLikesLoading());
      try {
        final response = await socialServiceRepository.getAllCommentLikes(
          commentId: event.commentId!,
        );
        response.fold(
          (error) => emit(GetAllCommentLikesError(error: error)),
          (data) => emit(GetAllCommentLikesSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetAllCommentLikesError(error: e.message));
      }
    });
    on<GetAllCommentsOnPostEvent>((event, emit) async {
      emit(GetAllCommentsOnPostLoading());
      try {
        final response = await socialServiceRepository.getAllCommentsOnPost(
          postId: event.postId!,
          pageLimit: event.pageLimit!,
          pageNumber: event.pageNumber!,
        );
        response.fold(
          (error) => emit(GetAllCommentsOnPostError(error: error)),
          (data) => emit(GetAllCommentsOnPostSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetAllCommentsOnPostError(error: e.message));
      }
    });
    on<GetLikesOnPostEvent>((event, emit) async {
      emit(GetLikesOnPostLoading());
      try {
        final response = await socialServiceRepository.getLikesOnPost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(GetLikesOnPostError(error: error)),
          (data) => emit(GetLikesOnPostSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetLikesOnPostError(error: e.message));
      }
    });
    on<GetSingleCommentOnPostEvent>((event, emit) async {
      emit(GetSingleCommentOnPostLoading());
      try {
        final response = await socialServiceRepository.getSingleCommentOnPost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(GetSingleCommentOnPostError(error: error)),
          (data) => emit(GetSingleCommentOnPostSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetSingleCommentOnPostError(error: e.message));
      }
    });
    on<GetPostFeedEvent>((event, emit) async {
      emit(GetPostFeedLoading());
      try {
        final response = await socialServiceRepository.getPostFeed(
          pageNumber: event.pageNumber!,
          pageLimit: event.pageLimit!,
        );
        response.fold(
          (error) => emit(GetPostFeedError(error: error)),
          (data) => emit(GetPostFeedSuccess(posts: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetPostFeedError(error: e.message));
      }
    });
    on<GetAllPostsEvent>((event, emit) async {
      emit(GetAllPostsLoading());
      try {
        final response = await socialServiceRepository.getAllPosts(
          pageNumber: event.pageNumber!,
          pageLimit: event.pageLimit!,
        );
        response.fold(
          (error) => emit(GetAllPostsError(error: error)),
          (data) => emit(GetAllPostsSuccess(posts: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetAllPostsError(error: e.message));
      }
    });
    on<GetPostEvent>((event, emit) async {
      emit(GetPostLoading());
      try {
        final response = await socialServiceRepository.getPost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(GetPostError(error: error)),
          (data) => emit(GetPostSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetPostError(error: e.message));
      }
    });
  }
}