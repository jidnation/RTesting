part of 'ss_bloc.dart';

@immutable
abstract class SocialServiceEvent {}

class CreatePostEvent extends SocialServiceEvent {
  final String? audioMediaItem;
  final String? videoMediaItem;
  final List<String>? imageMediaItem, mentionList;
  final String? commentOption;
  final String? content, location, postRating;
  CreatePostEvent(
      {this.audioMediaItem,
      this.videoMediaItem,
      this.imageMediaItem,
      this.commentOption,
      this.content,
      this.location,
      this.mentionList,
      this.postRating});
}

class EditContentEvent extends SocialServiceEvent {
  final String? postId;
  final String? content;
  EditContentEvent({
    required this.postId,
    required this.content,
  });
}

// class UploadPostMediaEvent extends SocialServiceEvent {
//   final List<UploadFileDto> media;
//   UploadPostMediaEvent({required this.media});
// }

class MediaUploadEvent extends SocialServiceEvent {
  final File media;
  MediaUploadEvent({required this.media});
}

class DeletePostEvent extends SocialServiceEvent {
  final String? postId;
  DeletePostEvent({required this.postId});
}

class LikePostEvent extends SocialServiceEvent {
  final String? postId;
  LikePostEvent({required this.postId});
}

class UnlikePostEvent extends SocialServiceEvent {
  final String? postId;
  UnlikePostEvent({required this.postId});
}

class CommentOnPostEvent extends SocialServiceEvent {
  final String? postId;
  final String? content, location;
  final String? audioMediaItem;
  final String? videoMediaItem;
  final List<String>? imageMediaItems;
  final String? userId;
  final String? postOwnerId;

  CommentOnPostEvent({
    required this.postId,
    this.content,
    this.location,
    this.audioMediaItem,
    this.videoMediaItem,
    this.imageMediaItems,
    this.postOwnerId,
    required this.userId,
  });
}

class DeletePostCommentEvent extends SocialServiceEvent {
  final String? commentId;
  DeletePostCommentEvent({required this.commentId});
}

class ReplyCommentOnPostEvent extends SocialServiceEvent {
  final String postId;
  final String? content;
  final String commentId;
  final String commentOwnerId;
  final String postOwnerId;
  final String? audioMediaItem;
  final String? videoMediaItem;
  final List<String>? imageMediaItems;

  ReplyCommentOnPostEvent({
    required this.postId,
    this.content,
    required this.commentId,
    required this.postOwnerId,
    required this.commentOwnerId,
    this.audioMediaItem,
    this.videoMediaItem,
    this.imageMediaItems,
  });
}

class GetCommentRepliesEvent extends SocialServiceEvent {
  final String postId;
  final String commentId;
  final int? pageNumber, pageLimit;

  GetCommentRepliesEvent(
      {required this.postId,
      required this.commentId,
      this.pageNumber,
      this.pageLimit});
}

class DeleteCommentReplyEvent extends SocialServiceEvent {
  final String postId;
  final String replyId;

  DeleteCommentReplyEvent({
    required this.postId,
    required this.replyId,
  });
}

class LikeCommentReplyEvent extends SocialServiceEvent {
  final String postId;
  final String replyId;
  final String commentId;

  LikeCommentReplyEvent({
    required this.postId,
    required this.replyId,
    required this.commentId,
  });
}

class UnlikeCommentReplyEvent extends SocialServiceEvent {
  final String replyId;

  UnlikeCommentReplyEvent({
    required this.replyId,
  });
}

class VotePostEvent extends SocialServiceEvent {
  final String? voteType;
  final String? postId;
  VotePostEvent({
    required this.voteType,
    required this.postId,
  });
}

class DeletePostVoteEvent extends SocialServiceEvent {
  final String? voteId;
  DeletePostVoteEvent({required this.voteId});
}

class LikeCommentOnPostEvent extends SocialServiceEvent {
  final String? postId;
  final String? commentId;
  LikeCommentOnPostEvent({
    required this.postId,
    required this.commentId,
  });
}

class UnlikeCommentOnPostEvent extends SocialServiceEvent {
  final String? commentId, likeId;
  UnlikeCommentOnPostEvent({
    required this.commentId,
    required this.likeId,
    String? postId,
  });
}

class CheckCommentLikeEvent extends SocialServiceEvent {
  final String? commentLikeId;
  CheckCommentLikeEvent({required this.commentLikeId});
}

class CheckPostLikeEvent extends SocialServiceEvent {
  final String? postId;
  CheckPostLikeEvent({required this.postId});
}

class CheckPostVoteEvent extends SocialServiceEvent {
  final String? postId;
  CheckPostVoteEvent({required this.postId});
}

class GetAllCommentLikesEvent extends SocialServiceEvent {
  final String? commentId;
  GetAllCommentLikesEvent({required this.commentId});
}

class GetAllCommentsOnPostEvent extends SocialServiceEvent {
  final String? postId;
  final int? pageLimit;
  final int? pageNumber;
  GetAllCommentsOnPostEvent({
    required this.postId,
    required this.pageLimit,
    required this.pageNumber,
  });
}

class GetPersonalCommentsEvent extends SocialServiceEvent {
  final String? authId;
  final int? pageLimit;
  final int? pageNumber;
  GetPersonalCommentsEvent({
    this.authId,
    required this.pageLimit,
    required this.pageNumber,
  });
}

class GetLikesOnPostEvent extends SocialServiceEvent {
  final String? postId;
  GetLikesOnPostEvent({required this.postId});
}

class GetVotesOnPostEvent extends SocialServiceEvent {
  final String? postId;
  final String? voteType;
  GetVotesOnPostEvent({required this.postId, required this.voteType});
}

class GetPostEvent extends SocialServiceEvent {
  final String? postId;
  GetPostEvent({required this.postId});
}

class SavePostEvent extends SocialServiceEvent {
  SavePostEvent({required this.postId});
  final String? postId;
}

class DeleteSavedPostEvent extends SocialServiceEvent {
  DeleteSavedPostEvent({required this.postId});
  final String? postId;
}

class GetSingleCommentOnPostEvent extends SocialServiceEvent {
  final String? commentId;
  GetSingleCommentOnPostEvent({required this.commentId});
}

class GetPostFeedEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  GetPostFeedEvent({
    required this.pageLimit,
    required this.pageNumber,
  });
}

class GetAllSavedPostsEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  GetAllSavedPostsEvent({
    required this.pageLimit,
    required this.pageNumber,
  });
}

class GetAllPostsEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  final String? authId;
  GetAllPostsEvent({
    required this.pageLimit,
    required this.pageNumber,
    this.authId,
  });
}

class GetAllStatusEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  GetAllStatusEvent({
    required this.pageLimit,
    required this.pageNumber,
  });
}

class GetStatusFeedEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  GetStatusFeedEvent({
    required this.pageLimit,
    required this.pageNumber,
  });
}

class GetStatusEvent extends SocialServiceEvent {
  final String? statusId;
  GetStatusEvent({required this.statusId});
}

class DeleteStatusEvent extends SocialServiceEvent {
  final String? statusId;
  DeleteStatusEvent({required this.statusId});
}

class MuteStatusEvent extends SocialServiceEvent {
  final String idToMute;
  MuteStatusEvent({required this.idToMute});
}

class UnmuteStatusEvent extends SocialServiceEvent {
  final String idToUnmute;
  UnmuteStatusEvent({required this.idToUnmute});
}

class ReportStatusEvent extends SocialServiceEvent {
  final String reportReason;
  final String statusId;
  ReportStatusEvent({
    required this.reportReason,
    required this.statusId,
  });
}

class CreateRepostEvent extends SocialServiceEvent {
  final CreateRepostInput input;
  CreateRepostEvent({
    required this.input,
  });
}

class CreateStatusEvent extends SocialServiceEvent {
  final CreateStatusDto? createStatusDto;
  CreateStatusEvent({required this.createStatusDto});
}

class SearchProfileEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  final String? name;
  SearchProfileEvent({
    required this.pageLimit,
    required this.pageNumber,
    this.name,
  });
}

class GetLikedPostsEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  final String? authId;

  GetLikedPostsEvent({
    required this.pageLimit,
    required this.pageNumber,
    this.authId,
  });
}

class GetVotedPostsEvent extends SocialServiceEvent {
  final int? pageLimit;
  final int? pageNumber;
  final String? voteType;
  final String? authId;

  GetVotedPostsEvent(
      {required this.pageLimit,
      required this.pageNumber,
      required this.voteType,
      this.authId});
}

class SuggestUserEvent extends SocialServiceEvent {}

// class ReachUserEvent extends
