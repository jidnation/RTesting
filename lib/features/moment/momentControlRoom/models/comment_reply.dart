import 'dart:convert';

import '../../../timeline/models/post_feed.dart';

CommentReplyModel commentReplyModelFromJson(String str) =>
    CommentReplyModel.fromJson(json.decode(str));

class CommentReplyModel {
  CommentReplyModel({
    this.typename,
    this.getMomentCommentReplies,
  });

  final List<GetMomentCommentReply>? getMomentCommentReplies;
  final String? typename;

  factory CommentReplyModel.fromJson(Map<String, dynamic> json) =>
      CommentReplyModel(
        typename: json["__typename"],
        getMomentCommentReplies: List<GetMomentCommentReply>.from(
            json["getMomentCommentReplies"]
                .map((x) => GetMomentCommentReply.fromJson(x))),
      );
}

class GetMomentCommentReply {
  GetMomentCommentReply({
    this.replyId,
    this.content,
    this.authId,
    this.momentId,
    this.commentId,
    this.imageMediaItems,
    this.videoMediaItem,
    this.audioMediaItem,
    this.nLikes,
    this.replySlug,
    this.replyOwnerProfile,
    this.momentOwnerProfile,
    this.commentOwnerProfile,
    this.isLiked,
    this.createdAt,
  });

  final String? replyId;
  final String? content;
  final String? authId;
  final String? momentId;
  final String? commentId;
  final List<String>? imageMediaItems;
  final String? videoMediaItem;
  final String? audioMediaItem;
  final int? nLikes;
  final String? replySlug;
  final ErProfile? replyOwnerProfile;
  final ErProfile? momentOwnerProfile;
  final ErProfile? commentOwnerProfile;
  final bool? isLiked;
  final DateTime? createdAt;

  factory GetMomentCommentReply.fromJson(Map<String, dynamic> json) =>
      GetMomentCommentReply(
        replyId: json["replyId"] ?? "",
        content: json["content"] ?? "",
        authId: json["authId"] ?? "",
        momentId: json["momentId"] ?? "",
        commentId: json["commentId"] ?? "",
        imageMediaItems: json["imageMediaItems"] != null
            ? List<String>.from(json["imageMediaItems"].map((x) => x))
            : null,
        videoMediaItem: json["videoMediaItem"] ?? "",
        audioMediaItem: json["audioMediaItem"] ?? "",
        nLikes: json["nLikes"] ?? 0,
        replySlug: json["replySlug"] ?? "",
        replyOwnerProfile: json["replyOwnerProfile"] != null
            ? ErProfile.fromJson(json["replyOwnerProfile"])
            : null,
        momentOwnerProfile: json["momentOwnerProfile"] != null
            ? ErProfile.fromJson(json["momentOwnerProfile"])
            : null,
        commentOwnerProfile: json["commentOwnerProfile"] != null
            ? ErProfile.fromJson(json["commentOwnerProfile"])
            : null,
        isLiked: json["isLiked"] ?? false,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
      );
}
