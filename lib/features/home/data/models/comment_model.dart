class CommentModel {
  String? postId;
  String? authId;
  String? commentId;
  String? commentSlug;
  String? content;
  int? nComments;
  int? nLikes;
  List<String>? imageMediaItems;
  String? audioMediaItem;
  DateTime? createdAt;
  CommentProfileModel? commentOwnerProfile;
  CommentProfileModel? postOwnerProfile;
  List<CommentLikeModel>? like;
  bool? isLiked;

  CommentModel({
    this.postId,
    this.authId,
    this.commentId,
    this.commentSlug,
    this.content,
    this.nComments,
    this.nLikes,
    this.imageMediaItems,
    this.audioMediaItem,
    this.commentOwnerProfile,
    this.postOwnerProfile,
    this.createdAt,
    this.like,
    this.isLiked,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        postId: json["postId"],
        authId: json["authId"],
        commentId: json["commentId"],
        commentSlug: json["commentSlug"],
        content: json["content"],
        nComments: json["nComments"],
        nLikes: json["nLikes"],
        isLiked: json["isLiked"],
        imageMediaItems: json["imageMediaItems"] == null
            ? null
            : List<String>.from(json["imageMediaItems"].map((x) => x)),
        audioMediaItem: json["audioMediaItem"],
        createdAt: DateTime.parse(json["created_at"]),
        commentOwnerProfile: json["commentOwnerProfile"] != null
            ? CommentProfileModel.fromJson(json["commentOwnerProfile"])
            : null,
        postOwnerProfile: json["postOwnerProfile"] != null
            ? CommentProfileModel.fromJson(json["postOwnerProfile"])
            : null,
        // like: json["like"] == null
        //   ? null
        //   : List<CommentLikeModel>.from(
        //       json["like"].map((x) => CommentLikeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "commentId": commentId,
        "commentSlug": commentSlug,
        "content": content,
        "nComments": nComments,
        "audioMediaItem": audioMediaItem,
        "isLiked": isLiked,
        "imageMediaItem": imageMediaItems == null
            ? null
            : List<dynamic>.from(imageMediaItems!.map((x) => x)),
        "nLikes": nLikes,
        "created_at": createdAt!.toIso8601String(),
        "commentOwnerProfile":
            commentOwnerProfile == null ? null : commentOwnerProfile!.toJson(),
        "postOwnerProfile":
            postOwnerProfile == null ? null : postOwnerProfile!.toJson(),
        //  "like": like == null
        //     ? null
        //    : List<CommentLikeModel>.from(like!.map((x) => x.toJson())),
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

  @override
  String toString() {
    return 'CommentLike ("likeId": $likeId, "authId": $authId, "postId": $postId)';
  }
}
