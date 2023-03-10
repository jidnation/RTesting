part of 'ss_bloc.dart';

abstract class SocialServiceState extends Equatable {
  @override
  List<Object> get props => [];
}

class SocialServiceInitial extends SocialServiceState {}

class CreatePostLoading extends SocialServiceState {}

class CreatePostSuccess extends SocialServiceState {
  final PostModel? post;
  CreatePostSuccess({this.post});
}

class CreatePostError extends SocialServiceState {
  final String error;
  CreatePostError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreateRepostLoading extends SocialServiceState {}

class CreateRepostSuccess extends SocialServiceState {
  final PostModel? post;
  CreateRepostSuccess({this.post});
}

class CreateRepostError extends SocialServiceState {
  final String error;
  CreateRepostError({required this.error});
  @override
  List<Object> get props => [error];
}

class EditContentLoading extends SocialServiceState {}

class EditContentSuccess extends SocialServiceState {
  final PostModel? post;
  EditContentSuccess({this.post});
}

class EditContentError extends SocialServiceState {
  final String error;
  EditContentError({required this.error});
  @override
  List<Object> get props => [error];
}

class DeletePostLoading extends SocialServiceState {}

class DeletePostSuccess extends SocialServiceState {
  final bool? post;
  DeletePostSuccess({this.post});
}

class DeletePostError extends SocialServiceState {
  final String error;
  DeletePostError({required this.error});
  @override
  List<Object> get props => [error];
}

class LikePostLoading extends SocialServiceState {}

class LikePostSuccess extends SocialServiceState {
  final PostLikeModel? isLiked;
  final String? postId;
  LikePostSuccess({this.isLiked, this.postId});
}

class LikePostError extends SocialServiceState {
  final String error;
  final String postId;
  LikePostError({required this.error, required this.postId});
  @override
  List<Object> get props => [error];
}

class UnlikePostLoading extends SocialServiceState {}

class UnlikePostSuccess extends SocialServiceState {
  final bool? isUnliked;
  final String? postId;
  UnlikePostSuccess({this.isUnliked, this.postId});
}

class UnlikePostError extends SocialServiceState {
  final String error;
  final String postId;
  UnlikePostError({required this.error, required this.postId});
  @override
  List<Object> get props => [error];
}

class CommentOnPostLoading extends SocialServiceState {}

class CommentOnPostSuccess extends SocialServiceState {
  final CommentModel? commentModel;
  CommentOnPostSuccess({this.commentModel});
}

class CommentOnPostError extends SocialServiceState {
  final String error;
  CommentOnPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class DeletePostCommentLoading extends SocialServiceState {}

class DeletePostCommentSuccess extends SocialServiceState {
  final CommentModel? commentModel;
  DeletePostCommentSuccess({this.commentModel});
}

class DeletePostCommentError extends SocialServiceState {
  final String error;
  DeletePostCommentError({required this.error});
  @override
  List<Object> get props => [error];
}

class VotePostLoading extends SocialServiceState {}

class VotePostSuccess extends SocialServiceState {
  final bool? isVoted;
  VotePostSuccess({this.isVoted});
}

class VotePostError extends SocialServiceState {
  final String error;
  // final String
  VotePostError({required this.error});
  @override
  List<Object> get props => [error];
}

class UploadMediaLoading extends SocialServiceState {}

class UploadMediaSuccess extends SocialServiceState {
  final List<dynamic>? data;
  UploadMediaSuccess({this.data});
}

class UploadMediaError extends SocialServiceState {
  final String error;
  UploadMediaError({required this.error});
  @override
  List<Object> get props => [error];
}

class MediaUploadLoading extends SocialServiceState {}

class MediaUploadSuccess extends SocialServiceState {
  final String? image;
  MediaUploadSuccess({this.image});
}

class MediaUploadError extends SocialServiceState {
  final String error;
  MediaUploadError({required this.error});
  @override
  List<Object> get props => [error];
}

class DeletePostVoteLoading extends SocialServiceState {}

class DeletePostVoteSuccess extends SocialServiceState {
  final bool? data;
  DeletePostVoteSuccess({this.data});
}

class DeletePostVoteError extends SocialServiceState {
  final String error;
  DeletePostVoteError({required this.error});
  @override
  List<Object> get props => [error];
}

class LikeCommentOnPostLoading extends SocialServiceState {}

class LikeCommentOnPostSuccess extends SocialServiceState {
  final CommentLikeModel? commentLikeModel;
  LikeCommentOnPostSuccess({this.commentLikeModel});
}

class LikeCommentOnPostError extends SocialServiceState {
  final String error;
  final String commentId;
  LikeCommentOnPostError({required this.error, required this.commentId});
  @override
  List<Object> get props => [error];
}

class UnlikeCommentOnPostLoading extends SocialServiceState {}

class UnlikeCommentOnPostSuccess extends SocialServiceState {
  final String? unlikeComment;
  UnlikeCommentOnPostSuccess({this.unlikeComment});
}

class UnlikeCommentOnPostError extends SocialServiceState {
  final String error;
  final String commentId;
  UnlikeCommentOnPostError({required this.error, required this.commentId});
  @override
  List<Object> get props => [error];
}

class ReplyCommentOnPostLoading extends SocialServiceState {}

class ReplyCommentOnPostSuccess extends SocialServiceState {
  final CommentReplyModel? commentReply;
  ReplyCommentOnPostSuccess({this.commentReply});
}

class ReplyCommentOnPostError extends SocialServiceState {
  final String error;
  ReplyCommentOnPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetCommentRepliesLoading extends SocialServiceState {}

class GetCommentRepliesSuccess extends SocialServiceState {
  final List<CommentReplyModel>? replies;
  GetCommentRepliesSuccess({this.replies});
}

class GetCommentRepliesError extends SocialServiceState {
  final String error;
  GetCommentRepliesError({required this.error});
  @override
  List<Object> get props => [error];
}

class DeleteCommentReplyLoading extends SocialServiceState {}

class DeleteCommentReplySuccess extends SocialServiceState {
  DeleteCommentReplySuccess();
}

class DeleteCommentReplyError extends SocialServiceState {
  final String error;
  DeleteCommentReplyError({required this.error});
  @override
  List<Object> get props => [error];
}

class LikeCommentReplyLoading extends SocialServiceState {}

class LikeCommentReplySuccess extends SocialServiceState {
  final CommentReplyLikeModel? like;
  LikeCommentReplySuccess({this.like});
}

class LikeCommentReplyError extends SocialServiceState {
  final String error;
  LikeCommentReplyError({required this.error});
  @override
  List<Object> get props => [error];
}

class UnlikeCommentReplyLoading extends SocialServiceState {}

class UnlikeCommentReplySuccess extends SocialServiceState {
  UnlikeCommentReplySuccess();
}

class UnlikeCommentReplyError extends SocialServiceState {
  final String error;
  UnlikeCommentReplyError({required this.error});
  @override
  List<Object> get props => [error];
}

class CheckCommentLikeLoading extends SocialServiceState {}

class CheckCommentLikeSuccess extends SocialServiceState {
  final bool? checkCommentLike;
  CheckCommentLikeSuccess({this.checkCommentLike});
}

class CheckCommentLikeError extends SocialServiceState {
  final String error;
  CheckCommentLikeError({required this.error});
  @override
  List<Object> get props => [error];
}

class CheckPostLikeLoading extends SocialServiceState {}

class CheckPostLikeSuccess extends SocialServiceState {
  final bool? checkPostLike;
  CheckPostLikeSuccess({this.checkPostLike});
}

class CheckPostLikeError extends SocialServiceState {
  final String error;
  CheckPostLikeError({required this.error});
  @override
  List<Object> get props => [error];
}

class CheckPostVoteLoading extends SocialServiceState {}

class CheckPostVoteSuccess extends SocialServiceState {
  final String? data;
  CheckPostVoteSuccess({this.data});
}

class CheckPostVoteError extends SocialServiceState {
  final String error;
  CheckPostVoteError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetAllCommentLikesLoading extends SocialServiceState {}

class GetAllCommentLikesSuccess extends SocialServiceState {
  final List<CommentLikeModel>? data;
  GetAllCommentLikesSuccess({this.data});
}

class GetAllCommentLikesError extends SocialServiceState {
  final String error;
  GetAllCommentLikesError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetAllCommentsOnPostLoading extends SocialServiceState {}

class GetAllCommentsOnPostSuccess extends SocialServiceState {
  final List<CommentModel>? data;
  GetAllCommentsOnPostSuccess({this.data});
}

class GetAllCommentsOnPostError extends SocialServiceState {
  final String error;
  GetAllCommentsOnPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetPersonalCommentsLoading extends SocialServiceState {}

class GetPersonalCommentsSuccess extends SocialServiceState {
  final List<CommentModel>? data;
  GetPersonalCommentsSuccess({this.data});
}

class GetPersonalCommentsError extends SocialServiceState {
  final String error;
  GetPersonalCommentsError({required this.error});
  @override
  List<Object> get props => [error];
}

class DeleteSavedPostLoading extends SocialServiceState {}

class DeleteSavedPostSuccess extends SocialServiceState {
  final bool? isDeleted;
  DeleteSavedPostSuccess({this.isDeleted});
}

class DeleteSavedPostError extends SocialServiceState {
  final String error;
  DeleteSavedPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetAllSavedPostsLoading extends SocialServiceState {}

class GetAllSavedPostsSuccess extends SocialServiceState {
  final List<SavePostModel>? data;
  GetAllSavedPostsSuccess({this.data});
}

class GetAllSavedPostsError extends SocialServiceState {
  final String error;
  GetAllSavedPostsError({required this.error});
  @override
  List<Object> get props => [error];
}

class SavePostLoading extends SocialServiceState {}

class SavePostSuccess extends SocialServiceState {
  final SavePostModel? data;
  SavePostSuccess({this.data});
}

class SavePostError extends SocialServiceState {
  final String error;
  SavePostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetLikesOnPostLoading extends SocialServiceState {}

class GetLikesOnPostSuccess extends SocialServiceState {
  final List<VirtualPostLikeModel>? data;
  GetLikesOnPostSuccess({this.data});
}

class GetLikesOnPostError extends SocialServiceState {
  final String error;
  GetLikesOnPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetVotesOnPostLoading extends SocialServiceState {}

class GetVotesOnPostSuccess extends SocialServiceState {
  final List<VirtualPostVoteModel>? data;
  GetVotesOnPostSuccess({this.data});
}

class GetVotesOnPostError extends SocialServiceState {
  final String error;
  GetVotesOnPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetPostLoading extends SocialServiceState {}

class GetPostSuccess extends SocialServiceState {
  final PostModel? data;
  GetPostSuccess({this.data});
}

class GetPostError extends SocialServiceState {
  final String error;
  GetPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetSingleCommentOnPostLoading extends SocialServiceState {}

class GetSingleCommentOnPostSuccess extends SocialServiceState {
  final CommentModel? data;
  GetSingleCommentOnPostSuccess({this.data});
}

class GetSingleCommentOnPostError extends SocialServiceState {
  final String error;
  GetSingleCommentOnPostError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetPostFeedLoading extends SocialServiceState {}

class GetPostFeedSuccess extends SocialServiceState {
  final List<PostFeedModel>? posts;
  GetPostFeedSuccess({this.posts});
}

class GetPostFeedError extends SocialServiceState {
  final String error;
  GetPostFeedError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetAllPostsLoading extends SocialServiceState {}

class GetAllPostsSuccess extends SocialServiceState {
  final List<PostModel>? posts;
  GetAllPostsSuccess({this.posts});
}

class GetAllPostsError extends SocialServiceState {
  final String error;
  GetAllPostsError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetAllStatusLoading extends SocialServiceState {}

class GetAllStatusSuccess extends SocialServiceState {
  final List<StatusModel>? status;
  GetAllStatusSuccess({this.status});
}

class GetAllStatusError extends SocialServiceState {
  final String error;
  GetAllStatusError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetStatusFeedLoading extends SocialServiceState {}

class GetStatusFeedSuccess extends SocialServiceState {
  final List<StatusFeedResponseModel>? status;
  GetStatusFeedSuccess({this.status});
}

class GetStatusFeedError extends SocialServiceState {
  final String error;
  GetStatusFeedError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetStatusLoading extends SocialServiceState {}

class GetStatusSuccess extends SocialServiceState {
  final StatusModel? status;
  GetStatusSuccess({this.status});
}

class GetStatusError extends SocialServiceState {
  final String error;
  GetStatusError({required this.error});
  @override
  List<Object> get props => [error];
}

class DeleteStatusLoading extends SocialServiceState {}

class DeleteStatusSuccess extends SocialServiceState {
  final bool? isDeleted;
  DeleteStatusSuccess({this.isDeleted});
}

class DeleteStatusError extends SocialServiceState {
  final String error;
  DeleteStatusError({required this.error});
  @override
  List<Object> get props => [error];
}

class MuteStatusLoading extends SocialServiceState {}

class MuteStatusSuccess extends SocialServiceState {
  final MutedStatusModel? result;
  MuteStatusSuccess({this.result});
}

class MuteStatusError extends SocialServiceState {
  final String error;
  MuteStatusError({required this.error});
  @override
  List<Object> get props => [error];
}

class UnmuteStatusLoading extends SocialServiceState {}

class UnmuteStatusSuccess extends SocialServiceState {
  final bool? unmuted;
  UnmuteStatusSuccess({this.unmuted});
}

class UnmuteStatusError extends SocialServiceState {
  final String error;
  UnmuteStatusError({required this.error});
  @override
  List<Object> get props => [error];
}

class ReportStatusLoading extends SocialServiceState {}

class ReportStatusSuccess extends SocialServiceState {
  final ReportStatusModel? result;
  ReportStatusSuccess({this.result});
}

class ReportStatusError extends SocialServiceState {
  final String error;
  ReportStatusError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreateStatusLoading extends SocialServiceState {}

class CreateStatusSuccess extends SocialServiceState {
  final StatusModel? status;
  CreateStatusSuccess({this.status});
}

class CreateStatusError extends SocialServiceState {
  final String error;
  CreateStatusError({required this.error});
  @override
  List<Object> get props => [error];
}

class SearchProfileLoading extends SocialServiceState {}

class SearchProfileSuccess extends SocialServiceState {
  final List<ProfileIndexModel>? users;
  SearchProfileSuccess({this.users});
}

class SearchProfileError extends SocialServiceState {
  final String error;
  SearchProfileError({required this.error});
  @override
  List<Object> get props => [error];
}

class SuggestUserLoading extends SocialServiceState {}

class SuggestUserSuccess extends SocialServiceState {
  final List<User>? users;
  SuggestUserSuccess({this.users});
}

class SuggestUserError extends SocialServiceState {
  final String error;
  SuggestUserError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetLikedPostsLoading extends SocialServiceState {}

class GetLikedPostsSuccess extends SocialServiceState {
  final List<PostFeedModel>? posts;
  GetLikedPostsSuccess({this.posts});
  @override
  List<Object> get props => [posts!];
}

class GetLikedPostsError extends SocialServiceState {
  final String error;
  GetLikedPostsError({required this.error});
  @override
  List<Object> get props => [error];
}

class GetVotedPostsLoading extends SocialServiceState {}

class GetVotedPostsSuccess extends SocialServiceState {
  final List<PostFeedModel>? posts;
  final String? voteType;
  GetVotedPostsSuccess({this.posts, this.voteType});
  @override
  List<Object> get props => [posts!];
}

class GetVotedPostsError extends SocialServiceState {
  final String error;
  GetVotedPostsError({required this.error});
  @override
  List<Object> get props => [error];
}

class DownloadPostLoading extends SocialServiceState {}

class DownloadPostSuccess extends SocialServiceState {
  final Uint8List? image;

  DownloadPostSuccess({required this.image});
  @override
  List<Object> get props => [image!];
}

class DownloadPostError extends SocialServiceState {
  final String error;
  DownloadPostError({required this.error});
  @override
  List<Object> get props => [error];
}

