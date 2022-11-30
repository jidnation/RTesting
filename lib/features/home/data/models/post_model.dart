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
  List<PostLikeModel>? like;
  List<PostVoteModel>? vote;

  bool? isLiked;
  String? isVoted;
  bool? isRepost;
  String? postRating;
  DateTime? updatedAt;
  PostModel? repostedPost;
  String? repostedPostId;
  String? repostedPostOwnerId;
  PostProfileModel? repostedPostOwnerProfile;
  PostProfileModel? postOwnerProfile;

  PostModel(
      {this.audioMediaItem,
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
      this.like,
      this.vote,
      this.isLiked,
      this.isVoted,
      this.isRepost,
      this.postRating,
      this.updatedAt,
      this.repostedPost,
      this.repostedPostId,
      this.repostedPostOwnerId,
      this.repostedPostOwnerProfile,
      this.postOwnerProfile});

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
      postRating: json["postRating"],
      location: json["location"],
      audioMediaItem: json["audioMediaItem"],
      authId: json["postOwnerProfile"]?["authId"],
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
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      like: json["like"] == null
          ? null
          : List<PostLikeModel>.from(
              json["like"].map((x) => PostLikeModel.fromJson(x))),
      vote: json["vote"] == null
          ? null
          : List<PostVoteModel>.from(
              json["vote"].map((x) => PostVoteModel.fromJson(x))),
      isLiked: json["isLiked"],
      isVoted: json["isVoted"],
      isRepost: json["isRepost"],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      repostedPost: json["repostedPost"] == null
          ? null
          : PostModel.fromJson(json["repostedPost"]),
      repostedPostId: json["repostedPostId"],
      repostedPostOwnerId: json["repostedPostOwnerId"],
      repostedPostOwnerProfile: json["repostedPostOwnerProfile"] == null
          ? null
          : PostProfileModel.fromJson(json["repostedPostOwnerProfile"]),
      postOwnerProfile: json["postOwnerProfile"] == null
          ? null
          : PostProfileModel.fromJson(json["postOwnerProfile"]));

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
        "postOwnerProfile":
            postOwnerProfile == null ? null : postOwnerProfile!.toJson(),
        "like": like == null
            ? null
            : List<PostLikeModel>.from(like!.map((x) => x.toJson())),
        "vote": vote == null
            ? null
            : List<PostVoteModel>.from(vote!.map((x) => x.toJson())),
        "isLiked": isLiked,
        "isVoted": isVoted,
        "isRepost": isRepost,
        "postRating": postRating,
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "repostedPost": repostedPost == null ? null : repostedPost!.toJson(),
        "repostedPostId": repostedPostId,
        "repostedPostOwnerId": repostedPostOwnerId,
        "repostedPostOwnerProfile": repostedPostOwnerProfile == null
            ? null
            : repostedPostOwnerProfile!.toJson(),
      };
}

class SavePostModel {
  String? audioMediaItem;
  String? authId;
  String? content;
  List<String>? imageMediaItems;
  String? postId;
  String? savedPostId;
  String? videoMediaItem;
  // DateTime? createdAt;
  PostProfileModel? profile;
  List<PostLikeModel>? like;
  List<PostVoteModel>? vote;

  SavePostModel({
    this.audioMediaItem,
    this.authId,
    this.content,
    this.imageMediaItems,
    this.postId,
    this.savedPostId,
    this.videoMediaItem,
    //this.createdAt,
    this.profile,
    this.like,
    this.vote,
  });

  factory SavePostModel.fromJson(Map<String, dynamic> json) => SavePostModel(
        audioMediaItem: json["audioMediaItem"],
        authId: json["authId"],
        content: json["content"],
        imageMediaItems: json["imageMediaItems"] == null
            ? null
            : List<String>.from(json["imageMediaItems"].map((x) => x)),
        postId: json["postId"],
        savedPostId: json["savedPostId"],
        videoMediaItem: json["videoMediaItem"],
        // createdAt: json["createdAt"] == null
        //     ? null
        //     : DateTime.parse(json["createdAt"]),
        profile: json["profile"] != null
            ? PostProfileModel.fromJson(json["profile"])
            : null,
        like: json["like"] == null
            ? null
            : List<PostLikeModel>.from(
                json["like"].map((x) => PostLikeModel.fromJson(x))),
        vote: json["vote"] == null
            ? null
            : List<PostVoteModel>.from(
                json["vote"].map((x) => PostVoteModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "audioMediaItem": audioMediaItem,
        "authId": authId,
        "content": content,
        "imageMediaItems": imageMediaItems == null
            ? null
            : List<dynamic>.from(imageMediaItems!.map((x) => x)),
        "postId": postId,
        "savedPostId": savedPostId,
        "videoMediaItem": videoMediaItem,
        //"createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "profile": profile == null ? null : profile!.toJson(),
        "like": like == null
            ? null
            : List<PostLikeModel>.from(like!.map((x) => x.toJson())),
        "vote": vote == null
            ? null
            : List<PostVoteModel>.from(vote!.map((x) => x.toJson())),
      };

  PostModel toPostModel() => PostModel(
      imageMediaItems: imageMediaItems,
      videoMediaItem: videoMediaItem,
      audioMediaItem: audioMediaItem);
}

class PostLikeModel {
  String? postId;
  String? authId;
  // String? likeId;
  PostProfileModel? profile;
  DateTime? createdAt;

  PostLikeModel({
    this.postId,
    this.authId,
    // this.likeId,
    this.createdAt,
    this.profile,
  });

  factory PostLikeModel.fromJson(Map<String, dynamic> json) => PostLikeModel(
        postId: json["postId"],
        authId: json["authId"],
        // likeId: json["likeId"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        profile: json["profile"] != null
            ? PostProfileModel.fromJson(json["profile"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        //"likeId": likeId,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "profile": profile == null ? null : profile!.toJson(),
      };
}

class PostVoteModel {
  String? postId;
  String? authId;
  //String? voteId;
  DateTime? createdAt;
  String? voteType;

  PostVoteModel({
    this.postId,
    this.authId,
    //this.voteId,
    this.voteType,
    this.createdAt,
  });

  factory PostVoteModel.fromJson(Map<String, dynamic> json) => PostVoteModel(
        postId: json["postId"],
        authId: json["authId"],
        //voteId: json["voteId"],
        voteType: json["voteType"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        //"voteId": voteId,
        "voteType": voteType,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
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
  List<PostLikeModel>? like;
  List<PostVoteModel>? vote;
  bool? reachingRelationship;
  bool? verified;
  DateTime? createdAt;

  DateTime? updatedAt;
  PostProfileModel? voterProfile;

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
    this.like,
    this.vote,
    this.reachingRelationship,
    this.updatedAt,
    this.voterProfile,
  });

  factory PostFeedModel.fromJson(Map<String, dynamic> json) {
    return PostFeedModel(
      location: json["post"]["location"],
      // feedOwnerId: json["feedOwnerProfile"]["authId"],
      firstName: json["post"]["postOwnerProfile"]?["firstName"],
      lastName: json["post"]["postOwnerProfile"]?["lastName"],
      profilePicture: json["post"]["postOwnerProfile"]?["profilePicture"],
      profileSlug: json["post"]["postOwnerProfile"]?["profileSlug"],
      postOwnerId: json["post"]["postOwnerProfile"]?["authId"],
      username: json["post"]["postOwnerProfile"]?["username"],
      verified: json["post"]["postOwnerProfile"]?["verified"],
      postId: json["post"]["postId"],
      post: json["post"] == null ? null : PostModel.fromJson(json["post"]),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      reachingRelationship: json["reachingRelationship"],
      like: json["isLiked"] ?? false ? [PostLikeModel()] : [],
      vote: json["isVoted"] == null
          ? []
          : [PostVoteModel(voteType: json["isVoted"])],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      voterProfile: json["voterProfile"] == null
          ? null
          : PostProfileModel.fromJson(json["voterProfile"]),
    );
  }

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
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "reachingRelationship": reachingRelationship,
        "like": like == null ? null : List.from(like!.map((x) => x.toJson())),
        // "vote": vote == null ? null : List.from(vote!.map((x) => x.toJson())),
        // "isLiked": isLiked,
        // "isVoted": isVoted,
        // "isRepost": isRepost,
        "updated_at": updatedAt,
        // "repostedPost": repostedPost,
        // "repostedPostId": repostedPostId,
        // "repostedPostOwnerId": repostedPostOwnerId,
        "voterProfile": voterProfile,
        // "repostedPostOwnerProfile": repostedPostOwnerProfile,
        // "postOwnerProfile": postOwnerProfile
      };
}

class PostProfileModel {
  String? authId;
  String? firstName;
  String? lastName;
  String? location;
  String? profilePicture;
  String? profileSlug;
  bool? verified;
  String? username;

  PostProfileModel({
    this.authId,
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

class ProfileIndexModel {
  String? authId;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? profileSlug;
  bool? verified;
  String? username;

  ProfileIndexModel({
    this.authId,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.profileSlug,
    this.username,
    this.verified,
  });

  factory ProfileIndexModel.fromJson(Map<String, dynamic> json) =>
      ProfileIndexModel(
        authId: json["authId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        verified: json["verified"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "authId": authId,
        "firstName": firstName,
        "lastName": lastName,
        "profilePicture": profilePicture,
        "profileSlug": profileSlug,
        "verified": verified,
        "username": username,
      };
}
