import 'package:http/http.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';

class CommentModel {
  String? postId;
  String? authId;
  String? commentId;
  String? commentSlug;
  String? content;
  int? nReplies;
  int? nLikes;
  List<String>? imageMediaItems;
  String? audioMediaItem;
  String? videoMediaItem;
  DateTime? createdAt;
  CommentProfileModel? commentOwnerProfile;
  CommentProfileModel? postOwnerProfile;
  List<CommentLikeModel>? like;
  String? isLiked;
  int? nreply;

  CommentModel({
    this.postId,
    this.authId,
    this.commentId,
    this.commentSlug,
    this.content,
    this.nReplies,
    this.nLikes,
    this.imageMediaItems,
    this.audioMediaItem,
    this.videoMediaItem,
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
        nReplies: json["nReplies"],
        nLikes: json["nLikes"],
        isLiked: json["isLiked"],
        imageMediaItems: json["imageMediaItems"] == null
            ? null
            : List<String>.from(json["imageMediaItems"].map((x) => x)),
        audioMediaItem: json["audioMediaItem"],
        videoMediaItem: json["videoMediaItem"],
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
        "nReplies": nReplies,
        "audioMediaItem": audioMediaItem,
        "videoMediaItem": videoMediaItem,
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

  PostFeedModel toPostFeedModel() => PostFeedModel(
      username: commentOwnerProfile?.username,
      profilePicture: commentOwnerProfile?.profilePicture,
      postOwnerId: commentOwnerProfile?.authId,
      verified: commentOwnerProfile?.verified,
      location: commentOwnerProfile?.location,
      postId: postId,
      post: PostModel(
          edited: false,
          postId: commentId,

          imageMediaItems: imageMediaItems,
          videoMediaItem: videoMediaItem,
          location: commentOwnerProfile?.location,
          content: content,
          createdAt: createdAt,
          audioMediaItem: audioMediaItem),
      createdAt: createdAt);
}

class CommentReplyModel {
  String? replyId;
  String? postId;
  String? authId;
  String? commentId;
  String? replySlug;
  String? content;
  int? nLikes;
  List<String>? imageMediaItems;
  String? audioMediaItem;
  String? videoMediaItem;
  DateTime? createdAt;
  CommentProfileModel? commentOwnerProfile;
  CommentProfileModel? postOwnerProfile;
  CommentProfileModel? replyOwnerProfile;
  bool? isLiked;

  CommentReplyModel({
    this.replyId,
    this.authId,
    this.postId,
    this.commentId,
    this.replySlug,
    this.content,
    this.nLikes,
    this.imageMediaItems,
    this.audioMediaItem,
    this.videoMediaItem,
    this.commentOwnerProfile,
    this.postOwnerProfile,
    this.replyOwnerProfile,
    this.createdAt,
    this.isLiked,
  });
  factory CommentReplyModel.fromJson(Map<String, dynamic> json) =>
      CommentReplyModel(
        replyId: json["replyId"],
        postId: json["postId"],
        authId: json["authId"],
        commentId: json["commentId"],
        replySlug: json["replySlug"],
        content: json["content"],
        nLikes: json["nLikes"],
        isLiked: json["isLiked"],
        imageMediaItems: json["imageMediaItems"] == null
            ? null
            : List<String>.from(json["imageMediaItems"].map((x) => x)),
        audioMediaItem: json["audioMediaItem"],
        videoMediaItem: json["videoMediaItem"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        commentOwnerProfile: json["commentOwnerProfile"] != null
            ? CommentProfileModel.fromJson(json["commentOwnerProfile"])
            : null,
        postOwnerProfile: json["postOwnerProfile"] != null
            ? CommentProfileModel.fromJson(json["postOwnerProfile"])
            : null,
        replyOwnerProfile: json["postOwnerProfile"] != null
            ? CommentProfileModel.fromJson(json["postOwnerProfile"])
            : null,
      );
  Map<String, dynamic> toJson() => {
        "replyId": replyId,
        "postId": postId,
        "authId": authId,
        "commentId": commentId,
        "replySlug": replySlug,
        "content": content,
        "audioMediaItem": audioMediaItem,
        "videoMediaItem": videoMediaItem,
        "isLiked": isLiked,
        "imageMediaItem": imageMediaItems == null
            ? null
            : List<dynamic>.from(imageMediaItems!.map((x) => x)),
        "nLikes": nLikes,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "commentOwnerProfile":
            commentOwnerProfile == null ? null : commentOwnerProfile!.toJson(),
        "postOwnerProfile":
            postOwnerProfile == null ? null : postOwnerProfile!.toJson(),
        "replyOwnerProfile":
            postOwnerProfile == null ? null : postOwnerProfile!.toJson(),
      };

  CommentModel toCommentModel() => CommentModel(
      imageMediaItems: imageMediaItems,
      videoMediaItem: videoMediaItem,
      audioMediaItem: audioMediaItem,
      authId: authId,
      postOwnerProfile: postOwnerProfile,
      commentOwnerProfile: commentOwnerProfile,
      commentId: commentId,
      createdAt: createdAt,
      content: content);
}

class CommentProfileModel {
  String? authId;
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
    this.authId
  });

  factory CommentProfileModel.fromJson(Map<String, dynamic> json) =>
      CommentProfileModel(
        authId: json["authId"],
        location: json["location"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        verified: json["verified"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "authId": authId,
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
  CommentProfileModel? profile;
  DateTime? createdAt;

  CommentLikeModel({
    this.postId,
    this.authId,
    this.likeId,
    this.commentId,
    this.profile,
    this.createdAt,
  });

  factory CommentLikeModel.fromJson(Map<String, dynamic> json) =>
      CommentLikeModel(
          postId: json["postId"],
          authId: json["authId"],
          likeId: json["likeId"],
          commentId: json["commentId"],
          createdAt: DateTime.parse(json["created_at"]),
          profile: json["profile"] != null
              ? CommentProfileModel.fromJson(json["profile"])
              : null);

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "likeId": likeId,
        "commentId": commentId,
        "profile": profile == null ? null : profile!.toJson(),
        "created_at": createdAt!.toIso8601String(),
      };

  @override
  String toString() {
    return 'CommentLike ("likeId": $likeId, "authId": $authId, "postId": $postId)';
  }
}

class CommentReplyLikeModel {
  String? replyId;
  String? authId;
  String? likeId;
  String? commentId;
  CommentProfileModel? profile;
  DateTime? createdAt;

  CommentReplyLikeModel({
    this.replyId,
    this.authId,
    this.likeId,
    this.commentId,
    this.profile,
    this.createdAt,
  });

  factory CommentReplyLikeModel.fromJson(Map<String, dynamic> json) =>
      CommentReplyLikeModel(
          replyId: json["replyId"],
          authId: json["authId"],
          likeId: json["likeId"],
          commentId: json["commentId"],
          createdAt: DateTime.parse(json["created_at"]),
          profile: json["profile"] != null
              ? CommentProfileModel.fromJson(json["profile"])
              : null);

  Map<String, dynamic> toJson() => {
        "replyId": replyId,
        "authId": authId,
        "likeId": likeId,
        "commentId": commentId,
        "profile": profile == null ? null : profile!.toJson(),
        "created_at": createdAt!.toIso8601String(),
      };

  @override
  String toString() {
    return 'CommentLike ("likeId": $likeId, "authId": $authId, "postId": $replyId)';
  }
}
