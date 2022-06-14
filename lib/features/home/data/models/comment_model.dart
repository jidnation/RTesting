class CommentModel {
  String? postId;
  String? authId;
  String? commentId;
  String? commentSlug;
  String? content;
  int? nComments;
  int? nLikes;
  DateTime? createdAt;
  CommentProfileModel? commentProfile;

  CommentModel({
    this.postId,
    this.authId,
    this.commentId,
    this.commentSlug,
    this.content,
    this.nComments,
    this.nLikes,
    this.commentProfile,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        postId: json["postId"],
        authId: json["authId"],
        commentId: json["commentId"],
        commentSlug: json["commentSlug"],
        content: json["content"],
        nComments: json["nComments"],
        nLikes: json["nLikes"],
        createdAt: DateTime.parse(json["created_at"]),
        commentProfile: json["profile"] != null
            ? CommentProfileModel.fromJson(json["profile"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "commentId": commentId,
        "commentSlug": commentSlug,
        "content": content,
        "nComments": nComments,
        "nLikes": nLikes,
        "created_at": createdAt!.toIso8601String(),
        "profile": commentProfile == null ? null : commentProfile!.toJson(),
      };
}

class CommentProfileModel {
  String? firstName;
  String? lastName;
  String? location;
  String? profilePicture;
  String? profileSlug;
  bool? verified;
  String? username;

  CommentProfileModel({
    this.firstName,
    this.lastName,
    this.location,
    this.profilePicture,
    this.profileSlug,
    this.username,
    this.verified,
  });

  factory CommentProfileModel.fromJson(Map<String, dynamic> json) =>
      CommentProfileModel(
        location: json["location"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        verified: json["verified"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "firstName": firstName,
        "lastName": lastName,
        "profilePicture": profilePicture,
        "profileSlug": profileSlug,
        "verified": verified,
        "username": username,
      };
}

class CommentLikeModel {
  String? postId;
  String? authId;
  String? likeId;
  String? commentId;

  CommentLikeModel({
    this.postId,
    this.authId,
    this.likeId,
    this.commentId,
  });

  factory CommentLikeModel.fromJson(Map<String, dynamic> json) =>
      CommentLikeModel(
        postId: json["postId"],
        authId: json["authId"],
        likeId: json["likeId"],
        commentId: json["commentId"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "likeId": likeId,
        "commentId": commentId,
      };
}
