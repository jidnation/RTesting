class PostModel {
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
  DateTime? createdAt;
  PostProfileModel? profile;

  PostModel({
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
    this.createdAt,
    this.profile,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
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
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        profile: json["profile"] != null
            ? PostProfileModel.fromJson(json["profile"])
            : null,
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
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "profile": profile == null ? null : profile!.toJson(),
      };
}

class PostLikeModel {
  String? postId;
  String? authId;
  String? likeId;

  PostLikeModel({
    this.postId,
    this.authId,
    this.likeId,
  });

  factory PostLikeModel.fromJson(Map<String, dynamic> json) => PostLikeModel(
        postId: json["postId"],
        authId: json["authId"],
        likeId: json["likeId"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "likeId": likeId,
      };
}

class PostVoteModel {
  String? postId;
  String? authId;
  String? voteId;
  String? voteType;

  PostVoteModel({
    this.postId,
    this.authId,
    this.voteId,
    this.voteType,
  });

  factory PostVoteModel.fromJson(Map<String, dynamic> json) => PostVoteModel(
        postId: json["postId"],
        authId: json["authId"],
        voteId: json["voteId"],
        voteType: json["voteType"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "voteId": voteId,
        "voteType": voteType,
      };
}

class PostFeedModel {
  String? firstName;
  String? feedOwnerId;
  String? lastName;
  String? location;
  String? profilePicture;
  String? profileSlug;
  String? username;
  String? postId;
  PostModel? post;
  String? postOwnerId;
  bool? isLiked;
  bool? reachingRelationship;
  bool? verified;
  DateTime? createdAt;

  PostFeedModel({
    this.firstName,
    this.feedOwnerId,
    this.lastName,
    this.location,
    this.profilePicture,
    this.profileSlug,
    this.postOwnerId,
    this.username,
    this.postId,
    this.verified,
    this.post,
    this.createdAt,
    this.isLiked,
    this.reachingRelationship,
  });

  factory PostFeedModel.fromJson(Map<String, dynamic> json) => PostFeedModel(
        location: json["location"],
        firstName: json["firstName"],
        feedOwnerId: json["feedOwnerId"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        postOwnerId: json["postOwnerId"],
        username: json["username"],
        postId: json["postId"],
        verified: json["verified"],
        post: json["post"] == null ? null : PostModel.fromJson(json["post"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        isLiked: json["isLiked"],
        reachingRelationship: json["reachingRelationship"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "firstName": firstName,
        "feedOwnerId": feedOwnerId,
        "lastName": lastName,
        "profilePicture": profilePicture,
        "profileSlug": profileSlug,
        "postOwnerId": postOwnerId,
        "username": username,
        "postId": postId,
        "post": post == null ? null : post!.toJson(),
        "verified": verified,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "isLiked": isLiked,
        "reachingRelationship": reachingRelationship,
      };
}

class PostProfileModel {
  String? firstName;
  String? lastName;
  String? location;
  String? profilePicture;
  String? profileSlug;
  bool? verified;
  String? username;

  PostProfileModel({
    this.firstName,
    this.lastName,
    this.location,
    this.profilePicture,
    this.profileSlug,
    this.username,
    this.verified,
  });

  factory PostProfileModel.fromJson(Map<String, dynamic> json) =>
      PostProfileModel(
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
