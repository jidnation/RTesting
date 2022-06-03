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
