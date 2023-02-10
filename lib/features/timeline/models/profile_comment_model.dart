import 'dart:convert';

GetMyCommentsModel getMyCommentsModelFromJson(String str) =>
    GetMyCommentsModel.fromJson(json.decode(str));

class GetMyCommentsModel {
  GetMyCommentsModel({
    this.typename,
    this.getPersonalComments,
  });

  final List<GetPersonalComment>? getPersonalComments;
  final String? typename;

  factory GetMyCommentsModel.fromJson(Map<String, dynamic> json) =>
      GetMyCommentsModel(
        typename: json["__typename"],
        getPersonalComments: List<GetPersonalComment>.from(
            json["getPersonalComments"]
                .map((x) => GetPersonalComment.fromJson(x))),
      );
}

class GetPersonalComment {
  GetPersonalComment({
    this.postId,
    this.commentId,
    this.content,
    this.videoMediaItem,
    this.audioMediaItem,
    this.nReplies,
    this.nLikes,
    this.imageMediaItems,
    this.createdAt,
    this.isLiked,
    this.commentOwnerProfile,
    this.postOwnerProfile,
  });

  final String? postId;
  final String? commentId;
  final String? content;
  final String? videoMediaItem;
  final String? audioMediaItem;
  final int? nReplies;
  final int? nLikes;
  final List<String>? imageMediaItems;
  final DateTime? createdAt;
  final String? isLiked;
  final CommentOwnerProfile? commentOwnerProfile;
  final CommentOwnerProfile? postOwnerProfile;

  factory GetPersonalComment.fromJson(Map<String, dynamic> json) =>
      GetPersonalComment(
        postId: json["postId"] ?? "",
        commentId: json["commentId"] ?? "",
        content: json["content"] ?? "",
        videoMediaItem: json["videoMediaItem"] ?? "",
        audioMediaItem: json["audioMediaItem"] ?? "",
        nReplies: json["nReplies"] ?? 0,
        nLikes: json["nLikes"] ?? 0,
        imageMediaItems: json["imageMediaItems"] != null
            ? List<String>.from(json["imageMediaItems"].map((x) => x))
            : [],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        isLiked: json["isLiked"] ?? false,
        commentOwnerProfile: json["commentOwnerProfile"] != null
            ? CommentOwnerProfile.fromJson(json["commentOwnerProfile"])
            : null,
        postOwnerProfile: json["postOwnerProfile"] != null
            ? CommentOwnerProfile.fromJson(json["postOwnerProfile"])
            : null,
      );
}

class CommentOwnerProfile {
  CommentOwnerProfile({
    this.authId,
    this.firstName,
    this.lastName,
    this.username,
    this.bio,
    this.verified,
    this.location,
    this.profileSlug,
    this.profilePicture,
  });

  final String? authId;
  final String? firstName;
  final String? username;
  final String? lastName;
  final String? bio;
  final bool? verified;
  final String? location;
  final String? profileSlug;
  final String? profilePicture;

  factory CommentOwnerProfile.fromJson(Map<String, dynamic> json) =>
      CommentOwnerProfile(
        authId: json["authId"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        username: json["username"] ?? "",
        bio: json["bio"] ?? "",
        verified: json["verified"] ?? false,
        location: json["location"] ?? "",
        profileSlug: json["profileSlug"] ?? "",
        profilePicture: json["profilePicture"] ?? "",
      );
}
