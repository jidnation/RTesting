part of 'ss_bloc.dart';

@immutable
abstract class SocialServiceEvent {}

class CreatePostEvent extends SocialServiceEvent {
  final String? audioMediaItem;
  final String? videoMediaItem;
  final List<String>? imageMediaItem;
  final String? commentOption;
  final String? content;
  CreatePostEvent({
    this.audioMediaItem,
    this.videoMediaItem,
    this.imageMediaItem,
    this.commentOption,
    this.content,
  });
}

class EditContentEvent extends SocialServiceEvent {
  final String? postId;
  final String? content;
  EditContentEvent({
    required this.postId,
    required this.content,
  });
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
  final String? content;
  final String? userId;
  CommentOnPostEvent({
    required this.postId,
    required this.content,
    required this.userId,
  });
}

class DeletePostCommentEvent extends SocialServiceEvent {
  final String? commentId;
  DeletePostCommentEvent({required this.commentId});
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
  final String? commentLikeId;
  UnlikeCommentOnPostEvent({required this.commentLikeId});
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
  //final String? authId;
  final int? pageLimit;
  final int? pageNumber;
  GetPersonalCommentsEvent({
    //required this.authId,
    required this.pageLimit,
    required this.pageNumber,
  });
}

class GetLikesOnPostEvent extends SocialServiceEvent {
  final String? postId;
  GetLikesOnPostEvent({required this.postId});
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
  final String? postId;
  GetSingleCommentOnPostEvent({required this.postId});
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
  GetAllPostsEvent({
    required this.pageLimit,
    required this.pageNumber,
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

class CreateStatusEvent extends SocialServiceEvent {
  final CreateStatusDto? createStatusDto;
  CreateStatusEvent({required this.createStatusDto});
}
