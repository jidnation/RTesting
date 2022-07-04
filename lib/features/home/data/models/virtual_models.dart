import 'package:reach_me/core/models/user.dart';

class VirtualReach {
  String? reachingId;
  String? reacherId;
  User? reacher;
  User? reaching;

  VirtualReach({
    this.reacher,
    this.reacherId,
    this.reaching,
    this.reachingId,
  });

  factory VirtualReach.fromJson(Map<String, dynamic> json) => VirtualReach(
        reacher:
            json["reacher"] != null ? User.fromJson(json["reacher"]) : null,
        reaching:
            json["reaching"] != null ? User.fromJson(json["reaching"]) : null,
        reachingId: json["reachingId"],
        reacherId: json["reacherId"],
      );

  Map<String, dynamic> toJson() => {
        "reacher": reacher == null ? null : reacher!.toJson(),
        "reaching": reaching == null ? null : reaching!.toJson(),
        "reachingId": reachingId,
        "reacherId": reacherId,
      };
}

class VirtualStar {
  String? authId;
  String? starredId;
  User? user;
  User? starred;

  VirtualStar({
    this.user,
    this.authId,
    this.starred,
    this.starredId,
  });

  factory VirtualStar.fromJson(Map<String, dynamic> json) => VirtualStar(
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        starred:
            json["starred"] != null ? User.fromJson(json["starred"]) : null,
        starredId: json["starredId"],
        authId: json["authId"],
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user!.toJson(),
        "starred": starred == null ? null : starred!.toJson(),
        "starredId": starredId,
        "authId": authId,
      };
}

class VirtualCommentModel {
  String? postId;
  String? authId;
  String? commentId;
  String? commentSlug;
  String? content;
  int? nComments;
  int? nLikes;
  User? profile;

  VirtualCommentModel({
    this.postId,
    this.authId,
    this.commentId,
    this.commentSlug,
    this.content,
    this.nComments,
    this.nLikes,
    this.profile,
  });

  factory VirtualCommentModel.fromJson(Map<String, dynamic> json) =>
      VirtualCommentModel(
        postId: json["postId"],
        authId: json["authId"],
        commentId: json["commentId"],
        commentSlug: json["commentSlug"],
        content: json["content"],
        nComments: json["nComments"],
        nLikes: json["nLikes"],
        profile:
            json["profile"] != null ? User.fromJson(json["profile"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "commentId": commentId,
        "commentSlug": commentSlug,
        "content": content,
        "nComments": nComments,
        "nLikes": nLikes,
        "profile": profile == null ? null : profile!.toJson(),
      };
}

class VirtualPostLikeModel {
  String? postId;
  String? authId;
  String? likeId;
  User? profile;

  VirtualPostLikeModel({
    this.postId,
    this.authId,
    this.likeId,
    this.profile,
  });

  factory VirtualPostLikeModel.fromJson(Map<String, dynamic> json) =>
      VirtualPostLikeModel(
        postId: json["postId"],
        authId: json["authId"],
        likeId: json["likeId"],
        profile:
            json["profile"] != null ? User.fromJson(json["profile"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "likeId": likeId,
        "profile": profile == null ? null : profile!.toJson(),
      };
}

class VirtualPostModel {
  String? audioMediaItem;
  String? authId;
  String? commentOption;
  String? content;
  bool? edited;
  List<String>? hashTags;
  List<String>? imageMediaItems;
  String? location;
  List<String>? mentionList;
  int? nComments;
  int? nDownvotes;
  int? nLikes;
  int? nShares;
  int? nUpvotes;
  String? postId;
  String? postSlug;
  String? videoMediaItem;
  User? profile;

  VirtualPostModel({
    this.profile,
    this.audioMediaItem,
    this.authId,
    this.commentOption,
    this.content,
    this.edited,
    this.hashTags,
    this.imageMediaItems,
    this.location,
    this.mentionList,
    this.nComments,
    this.nDownvotes,
    this.nLikes,
    this.nShares,
    this.nUpvotes,
    this.postId,
    this.postSlug,
    this.videoMediaItem,
  });

  factory VirtualPostModel.fromJson(Map<String, dynamic> json) =>
      VirtualPostModel(
        location: json["location"],
        audioMediaItem: json["audioMediaItem"],
        authId: json["authId"],
        commentOption: json["commentOption"],
        content: json["content"],
        edited: json["edited"],
        hashTags: json["hashTags"] == null
            ? null
            : List<String>.from(json["hashTags"].map((x) => x)),
        imageMediaItems: json["imageMediaItems"] == null
            ? null
            : List<String>.from(json["imageMediaItems"].map((x) => x)),
        mentionList: json["mentionList"] == null
            ? null
            : List<String>.from(json["mentionList"].map((x) => x)),
        nComments: json["nComments"],
        nDownvotes: json["nDownvotes"],
        nLikes: json["nLikes"],
        nShares: json["nShares"],
        nUpvotes: json["nUpvotes"],
        postId: json["postId"],
        postSlug: json["postSlug"],
        videoMediaItem: json["videoMediaItem"],
        profile:
            json["profile"] != null ? User.fromJson(json["profile"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "audioMediaItem": audioMediaItem,
        "authId": authId,
        "commentOption": commentOption,
        "content": content,
        "edited": edited,
        "hashTags": hashTags == null
            ? null
            : List<dynamic>.from(hashTags!.map((x) => x)),
        "imageMediaItems": imageMediaItems == null
            ? null
            : List<dynamic>.from(imageMediaItems!.map((x) => x)),
        "mentionList": mentionList == null
            ? null
            : List<dynamic>.from(mentionList!.map((x) => x)),
        "nComments": nComments,
        "nDownvotes": nDownvotes,
        "nLikes": nLikes,
        "nShares": nShares,
        "nUpvotes": nUpvotes,
        "postId": postId,
        "postSlug": postSlug,
        "videoMediaItem": videoMediaItem,
        "profile": profile == null ? null : profile!.toJson(),
      };
}
