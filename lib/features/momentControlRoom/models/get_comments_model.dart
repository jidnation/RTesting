import 'dart:convert';

MomentCommentModel momentCommentModelFromJson(String str) =>
    MomentCommentModel.fromJson(json.decode(str));

class MomentCommentModel {
  MomentCommentModel({
    this.typename,
    this.getMomentComments,
  });

  final String? typename;
  final List<GetMomentComment>? getMomentComments;

  factory MomentCommentModel.fromJson(Map<String, dynamic> json) =>
      MomentCommentModel(
        typename: json["__typename"],
        getMomentComments: json["getMomentComments"] == null
            ? null
            : List<GetMomentComment>.from(json["getMomentComments"]
                .map((x) => GetMomentComment.fromJson(x))),
      );
}

class GetMomentComment {
  GetMomentComment({
    this.typename,
    this.content,
    this.commentId,
    this.createdAt,
    this.commentSlug,
    this.imageMediaItems,
    this.videoMediaItem,
    this.audioMediaItem,
    this.nLikes,
    this.nComments,
    this.isLiked,
    this.commentOwnerProfile,
    this.postOwnerProfile,
  });

  final String? typename;
  final String? content;
  final String? commentId;
  final String? createdAt;
  final String? commentSlug;
  final List<String>? imageMediaItems;
  final String? videoMediaItem;
  final String? audioMediaItem;
  int? nLikes;
  int? nComments;
  String? isLiked;
  final CommentOwnerProfile? commentOwnerProfile;
  final String? postOwnerProfile;

  factory GetMomentComment.fromJson(Map<String, dynamic> json) =>
      GetMomentComment(
        typename: json["__typename"] ?? "",
        content: json["content"] ?? "",
        commentId: json["commentId"] ?? "",
        createdAt: json["created_at"] ?? "",
        commentSlug: json["commentSlug"] ?? "",
        imageMediaItems: json["imageMediaItems"] == null
            ? null
            : List<String>.from(json["imageMediaItems"].map((x) => x)),
        videoMediaItem: json["videoMediaItem"] ?? "",
        audioMediaItem: json["audioMediaItem"] ?? "",
        nLikes: json["nLikes"] ?? 0,
        nComments: json["nComments"] ?? 0,
        isLiked: json["isLiked"],
        commentOwnerProfile: json["commentOwnerProfile"] == null
            ? null
            : CommentOwnerProfile.fromJson(json["commentOwnerProfile"]),
        postOwnerProfile:
            json["postOwnerProfile"] == null ? null : json["postOwnerProfile"],
      );
}

class CommentOwnerProfile {
  CommentOwnerProfile({
    this.typename,
    this.username,
    this.firstName,
    this.location,
    this.lastName,
    this.profilePicture,
  });

  final String? typename;
  final String? username;
  final String? firstName;
  final String? location;
  final String? lastName;
  final String? profilePicture;

  factory CommentOwnerProfile.fromJson(Map<String, dynamic> json) =>
      CommentOwnerProfile(
        typename: json["__typename"] ?? "",
        username: json["username"] ?? "",
        location: json["location"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        profilePicture: json["profilePicture"] ?? "",
      );
}
