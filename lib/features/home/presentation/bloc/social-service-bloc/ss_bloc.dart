import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/features/home/data/dtos/create.status.dto.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
import 'package:reach_me/features/home/data/repositories/social_service_repository.dart';
import 'package:reach_me/features/home/data/repositories/user_repository.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';

import '../../../data/dtos/create.repost.input.dart';

part 'ss_event.dart';
part 'ss_state.dart';

class SocialServiceBloc extends Bloc<SocialServiceEvent, SocialServiceState> {
  final socialServiceRepository = SocialServiceRepository();
  final userRepository = UserRepository();
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
            location: event.location,
            mentionList: event.mentionList,
            postRating: event.postRating);
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
    on<CreateRepostEvent>((event, emit) async {
      emit(CreateRepostLoading());
      // Console.log('kkk', event.input.toJson());
      try {
        final response =
            await socialServiceRepository.createRepost(input: event.input);
        response.fold(
          (error) => emit(CreateRepostError(error: error)),
          (post) => emit(CreateRepostSuccess(post: post)),
        );
      } on GraphQLError catch (e) {
        emit(CreateRepostError(error: e.message));
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
          (error) => emit(LikePostError(error: error, postId: event.postId!)),
          (postLike) =>
              emit(LikePostSuccess(isLiked: postLike, postId: event.postId)),
        );
      } on GraphQLError catch (e) {
        emit(LikePostError(error: e.message, postId: event.postId!));
      }
    });
    on<UnlikePostEvent>((event, emit) async {
      emit(UnlikePostLoading());
      try {
        final response = await socialServiceRepository.unlikePost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(UnlikePostError(
            error: error,
            postId: event.postId!,
          )),
          (isUnliked) => emit(
              UnlikePostSuccess(isUnliked: isUnliked, postId: event.postId)),
        );
      } on GraphQLError catch (e) {
        emit(UnlikePostError(
          error: e.message,
          postId: event.postId!,
        ));
      }
    });
    on<CommentOnPostEvent>((event, emit) async {
      emit(CommentOnPostLoading());
      try {
        final response = await socialServiceRepository.commentOnPost(
            postId: event.postId!,
            content: event.content,
            userId: event.userId!,
            imageMediaItems: event.imageMediaItems,
            videoMediaItem: event.videoMediaItem,
            audioMediaItem: event.audioMediaItem,
            postOwnerId: event.postOwnerId!);
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
          postId: event.postId ?? '',
          voteType: event.voteType!,
        );
        response.fold(
          (error) => emit(VotePostError(error: error)),
          (postVote) => emit(VotePostSuccess(
              isVoted: event.voteType == 'Upvote' ? true : false)),
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
          (error) => emit(LikeCommentOnPostError(
              error: error, commentId: event.commentId!)),
          (commentLikeModel) => emit(
              LikeCommentOnPostSuccess(commentLikeModel: commentLikeModel)),
        );
      } on GraphQLError catch (e) {
        emit(LikeCommentOnPostError(
            error: e.message, commentId: event.commentId!));
      }
    });
    on<UnlikeCommentOnPostEvent>((event, emit) async {
      emit(UnlikeCommentOnPostLoading());
      try {
        final response = await socialServiceRepository.unlikeCommentOnPost(
          commentLikeId: event.commentId!,
          likeId: event.likeId!,
        );
        response.fold(
          (error) => emit(UnlikeCommentOnPostError(
              error: error, commentId: event.commentId!)),
          (unlikeComment) =>
              emit(UnlikeCommentOnPostSuccess(unlikeComment: unlikeComment)),
        );
      } on GraphQLError catch (e) {
        emit(UnlikeCommentOnPostError(
            error: e.message, commentId: event.commentId!));
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
    on<GetPersonalCommentsEvent>((event, emit) async {
      emit(GetPersonalCommentsLoading());
      try {
        final response = await socialServiceRepository.getPersonalComments(
          authId: event.authId!,
          pageLimit: event.pageLimit!,
          pageNumber: event.pageNumber!,
        );
        response.fold(
          (error) => emit(GetPersonalCommentsError(error: error)),
          (data) => emit(GetPersonalCommentsSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetPersonalCommentsError(error: e.message));
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
          authId: event.authId,
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
    on<GetAllSavedPostsEvent>((event, emit) async {
      emit(GetAllSavedPostsLoading());
      try {
        final response = await socialServiceRepository.getAllSavedPosts(
          pageLimit: event.pageLimit!,
          pageNumber: event.pageNumber!,
        );
        response.fold(
          (error) => emit(GetAllSavedPostsError(error: error)),
          (data) => emit(GetAllSavedPostsSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(GetAllSavedPostsError(error: e.message));
      }
    });
    on<SavePostEvent>((event, emit) async {
      emit(SavePostLoading());
      try {
        final response = await socialServiceRepository.savePost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(SavePostError(error: error)),
          (data) => emit(SavePostSuccess(data: data)),
        );
      } on GraphQLError catch (e) {
        emit(SavePostError(error: e.message));
      }
    });
    on<DeleteSavedPostEvent>((event, emit) async {
      emit(DeleteSavedPostLoading());
      try {
        final response = await socialServiceRepository.deleteSavedPost(
          postId: event.postId!,
        );
        response.fold(
          (error) => emit(DeleteSavedPostError(error: error)),
          (isDeleted) => emit(DeleteSavedPostSuccess(isDeleted: isDeleted)),
        );
      } on GraphQLError catch (e) {
        emit(DeleteSavedPostError(error: e.message));
      }
    });
    on<CreateStatusEvent>((event, emit) async {
      emit(CreateStatusLoading());
      try {
        final response = await socialServiceRepository.createStatus(
          createStatusDto: event.createStatusDto!,
        );
        response.fold(
          (error) => emit(CreateStatusError(error: error)),
          (status) => emit(CreateStatusSuccess(status: status)),
        );
      } on GraphQLError catch (e) {
        emit(CreateStatusError(error: e.message));
      }
    });
    on<DeleteStatusEvent>((event, emit) async {
      emit(DeleteStatusLoading());
      try {
        final response = await socialServiceRepository.deleteStatus(
          statusId: event.statusId!,
        );
        response.fold(
          (error) => emit(DeleteStatusError(error: error)),
          (isDeleted) => emit(DeleteStatusSuccess(isDeleted: isDeleted)),
        );
      } on GraphQLError catch (e) {
        emit(DeleteStatusError(error: e.message));
      }
    });
    on<MuteStatusEvent>((event, emit) async {
      emit(MuteStatusLoading());
      try {
        final response = await socialServiceRepository.muteStatus(
          idToMute: event.idToMute,
        );
        response.fold(
          (error) => emit(MuteStatusError(error: error)),
          (res) => emit(MuteStatusSuccess(result: res)),
        );
      } on GraphQLError catch (e) {
        emit(MuteStatusError(error: e.message));
      }
    });
    on<UnmuteStatusEvent>((event, emit) async {
      emit(UnmuteStatusLoading());
      try {
        final response = await socialServiceRepository.unmuteStatus(
          idToUnmute: event.idToUnmute,
        );
        response.fold(
          (error) => emit(UnmuteStatusError(error: error)),
          (res) => emit(UnmuteStatusSuccess(unmuted: res)),
        );
      } on GraphQLError catch (e) {
        emit(UnmuteStatusError(error: e.message));
      }
    });
    on<ReportStatusEvent>((event, emit) async {
      emit(ReportStatusLoading());
      try {
        final response = await socialServiceRepository.reportStatus(
            reportReason: event.reportReason, statusId: event.statusId);
        response.fold(
          (error) => emit(ReportStatusError(error: error)),
          (res) => emit(ReportStatusSuccess(result: res)),
        );
      } on GraphQLError catch (e) {
        emit(ReportStatusError(error: e.message));
      }
    });
    on<GetAllStatusEvent>((event, emit) async {
      emit(GetAllStatusLoading());
      try {
        final response = await socialServiceRepository.getAllStatus(
          pageLimit: event.pageLimit!,
          pageNumber: event.pageNumber!,
        );
        response.fold(
          (error) => emit(GetAllStatusError(error: error)),
          (status) => emit(GetAllStatusSuccess(status: status)),
        );
      } on GraphQLError catch (e) {
        emit(GetAllStatusError(error: e.message));
      }
    });
    on<GetStatusFeedEvent>((event, emit) async {
      emit(GetStatusFeedLoading());
      try {
        final response = await socialServiceRepository.getStatusFeed(
          pageLimit: event.pageLimit!,
          pageNumber: event.pageNumber!,
        );
        response.fold(
          (error) => emit(GetStatusFeedError(error: error)),
          (status) => emit(GetStatusFeedSuccess(status: status)),
        );
      } on GraphQLError catch (e) {
        emit(GetStatusFeedError(error: e.message));
      }
    });
    on<GetStatusEvent>((event, emit) async {
      emit(GetStatusLoading());
      try {
        final response = await socialServiceRepository.getStatus(
          statusId: event.statusId!,
        );
        response.fold(
          (error) => emit(GetStatusError(error: error)),
          (status) => emit(GetStatusSuccess(status: status)),
        );
      } on GraphQLError catch (e) {
        emit(GetStatusError(error: e.message));
      }
    });
    on<SuggestUserEvent>((event, emit) async {
      emit(SuggestUserLoading());
      try {
        final response = await socialServiceRepository.suggestUser();
        response.fold(
          (error) => emit(SuggestUserError(error: error)),
          (users) => emit(SuggestUserSuccess(users: users)),
        );
      } on GraphQLError catch (e) {
        emit(SuggestUserError(error: e.message));
      }
    });
    on<SearchProfileEvent>((event, emit) async {
      emit(SearchProfileLoading());
      try {
        final response = await socialServiceRepository.searchProfile(
          pageLimit: event.pageLimit!,
          pageNumber: event.pageNumber!,
          name: event.name!,
        );
        response.fold(
          (error) => emit(SearchProfileError(error: error)),
          (users) => emit(SearchProfileSuccess(users: users)),
        );
      } on GraphQLError catch (e) {
        emit(SearchProfileError(error: e.message));
      }
    });
    on<GetLikedPostsEvent>((event, emit) async {
      emit(GetLikedPostsLoading());
      try {
        final response = await socialServiceRepository.getLikedPosts(
            pageLimit: event.pageLimit!,
            pageNumber: event.pageNumber!,
            authId: event.authId);
        response.fold(
          (error) => emit(GetLikedPostsError(error: error)),
          (posts) => emit(GetLikedPostsSuccess(posts: posts)),
        );
      } on GraphQLError catch (e) {
        emit(GetLikedPostsError(error: e.message));
      }
    });
    on<GetVotedPostsEvent>((event, emit) async {
      emit(GetVotedPostsLoading());
      try {
        print("pageLimit ${event.pageLimit}");
         print("pageNumber ${event.pageNumber}");
          print("vote tyoe ${event.voteType}");
        final response = await socialServiceRepository.getVotedPosts(
          pageLimit: event.pageLimit!,
          pageNumber: event.pageNumber!,
          voteType: event.voteType!,
          authId: ""
        );
        response.fold(
          (error) => emit(GetVotedPostsError(error: error)),
          (posts) => emit(
              GetVotedPostsSuccess(posts: posts, voteType: event.voteType)),
        );
      } on GraphQLError catch (e) {
        emit(GetVotedPostsError(error: e.message));
      }
    });
    on<UploadPostMediaEvent>((event, emit) async {
      emit(UploadMediaLoading());
      List<Map<String, dynamic>> mediaIds = [];
      List<String> imageUrl = [];

      try {
        //GET SIGNED URLS FOR ALL FILES
        Console.log('event.media length', event.media.length);
        for (UploadFileDto media in event.media) {
          final response = await userRepository.getSignedURl(file: media.file);
          response.fold(
            (error) => emit(UploadMediaError(error: error)),
            (meta) => mediaIds.add(meta),
          );
        }

        Console.log('media.id length', mediaIds.length);

        var tempMap = <String, dynamic>{};

        var tempArr = [];

        for (var element in event.media) {
          tempMap[element.id] = element.file;
          Console.log('element in media', element);
        }
        Console.log('temp map', tempMap);
        Console.log('temp map length', tempMap.length);

        tempMap.forEach((key, value) {
          tempArr.add({
            'id': key,
            'file': value,
          });
        });

        Console.log('temp arr length', tempArr.length);

        Console.log('temp arr', tempArr);

        //merge mediaIds and tempArr to form a giant object
        var newlist = mediaIds.toSet().toList().mapIndexed((index, element) {
          Console.log('map index i', index);
          Console.log('map index el', element);
          return {
            ...element,
            ...tempArr.toSet().toList()[index],
          };
        });

        Console.log('temp arr length', newlist.length);
        Console.log('newlist first', newlist.first);
        Console.log('newlist ', newlist);

        for (var data in newlist.toSet().toList()) {
          Console.log('data in newlist', data);
          final response = await userRepository.uploadPhoto(
            url: data['signedUrl'],
            file: data['file'],
          );
          response.fold(
            (error) => emit(UploadMediaError(error: error)),
            (meta) => {
              for (var data in newlist) {imageUrl.add(data['imageUrl'])}
            },
          );
        }

        Console.log('imageUrl list', imageUrl);
        Console.log('imageUrl first', imageUrl.first);

        if (imageUrl.isNotEmpty) {
          emit(UploadMediaSuccess(data: imageUrl.toSet().toList()));
        } else {
          emit(UploadMediaError(error: 'No media uploaded'));
        }
      } on GraphQLError catch (e) {
        emit(UploadMediaError(error: e.message));
      }
    });
    on<MediaUploadEvent>((event, emit) async {
      emit(MediaUploadLoading());
      String imageUrl = '';
      String signedUrl = '';
      try {
        //GET SIGNED URL
        final response = await userRepository.getSignedURl(file: event.media);

        response.fold(
          (error) => emit(MediaUploadError(error: error)),
          (data) {
            signedUrl = data['signedUrl'];
            imageUrl = data['imageUrl'];
          },
        );

        //UPLOAD FILE & GET IMAGE URL
        if (signedUrl.isNotEmpty) {
          final uploadRes = await userRepository.uploadPhoto(
            url: signedUrl,
            file: event.media,
          );

          uploadRes.fold(
            (error) => emit(MediaUploadError(error: error)),
            (user) => emit(MediaUploadSuccess(image: imageUrl)),
          );
        }
      } on GraphQLError catch (e) {
        emit(UploadMediaError(error: e.message));
      }
    });
  }
}
