import 'dart:convert';

PostFeedModel postFeedModelFromJson(String str) =>
    PostFeedModel.fromJson(json.decode(str));

GetAllPostsModel getAllPostsModelFromJson(String str) => GetAllPostsModel.fromJson(json.decode(str));


class GetAllPostsModel {
  GetAllPostsModel({
    this.typename,
     this.getAllPosts,
  });

  final List<Post>? getAllPosts;
  final String? typename;

  factory GetAllPostsModel.fromJson(Map<String, dynamic> json) => GetAllPostsModel(
    typename: json["__typename"],
    getAllPosts: List<Post>.from(json["getAllPosts"].map((x) => Post.fromJson(x))),
  );
}

class GetVotedPosts {
  GetVotedPosts({
    this.typename,
    this.getVotedPosts,
  });

  final List<GetPostFeed>? getVotedPosts;
  final String? typename;

  factory GetVotedPosts.fromJson(Map<String, dynamic> json) => GetVotedPosts(
    typename: json["__typename"],
    getVotedPosts: List<GetPostFeed>.from(json["getVotedPosts"].map((x) => GetPostFeed.fromJson(x))),
  );
}

class GetLikedPosts {
  GetLikedPosts({
    this.typename,
     this.getLikedPosts,
  });

  final List<GetPostFeed>? getLikedPosts;
  final String? typename;

  factory GetLikedPosts.fromJson(Map<String, dynamic> json) => GetLikedPosts(
    typename: json["__typename"],
    getLikedPosts: List<GetPostFeed>.from(json["getLikedPosts"].map((x) => GetPostFeed.fromJson(x))),
  );

}

class GetAllSavedPosts {
  GetAllSavedPosts({
    this.getAllSavedPosts,
    this.typename,
  });

  final List<GetAllSavedPost>? getAllSavedPosts;
  final String? typename;

  factory GetAllSavedPosts.fromJson(Map<String, dynamic> json) => GetAllSavedPosts(
    typename: json["__typename"],
    getAllSavedPosts: List<GetAllSavedPost>.from(json["getAllSavedPosts"].map((x) => GetAllSavedPost.fromJson(x))),
  );
}

class GetAllSavedPost {
  GetAllSavedPost({
    this.createdAt,
    this.updatedAt,
    this.savedPostId,
    this.post,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? savedPostId;
  final Post? post;

  factory GetAllSavedPost.fromJson(Map<String, dynamic> json) => GetAllSavedPost(
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    savedPostId: json["savedPostId"],
    post: Post.fromJson(json["post"]),
  );
}


class PostFeedModel {
  PostFeedModel({
    this.typename,
    this.getPostFeed,
  });

  final String? typename;
  final List<GetPostFeed>? getPostFeed;

  factory PostFeedModel.fromJson(Map<String, dynamic> json) => PostFeedModel(
        typename: json["__typename"],
        getPostFeed: List<GetPostFeed>.from(
            json["getPostFeed"].map((x) => GetPostFeed.fromJson(x))),
      );
}

class GetPostFeed {
  GetPostFeed({
    this.reachingRelationship,
    this.createdAt,
    this.updatedAt,
    this.feedOwnerProfile,
    this.voterProfile,
    this.post,
  });

  final bool? reachingRelationship;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ErProfile? feedOwnerProfile;
  final ErProfile? voterProfile;
  final Post? post;

  factory GetPostFeed.fromJson(Map<String, dynamic> json) => GetPostFeed(
        reachingRelationship: json["reachingRelationship"] ?? false,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        feedOwnerProfile: json["feedOwnerProfile"] != null
            ? ErProfile.fromJson(json["feedOwnerProfile"])
            : null,
        voterProfile: json["voterProfile"] == null
            ? null
            : ErProfile.fromJson(json["voterProfile"]),
        post: Post.fromJson(json["post"]),
      );
}

class ErProfile {
  ErProfile({
    this.authId,
    this.firstName,
    this.lastName,
    this.username,
    this.bio,
    this.verified,
    this.location,
    this.profilePicture,
    this.profileSlug,
  });

  final String? authId;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? bio;
  final bool? verified;
  final String? location;
  final String? profilePicture;
  final String? profileSlug;

  factory ErProfile.fromJson(Map<String, dynamic> json) => ErProfile(
        authId: json["authId"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        username: json["username"] ?? "",
        bio: json["bio"] ?? "",
        verified: json["verified"] ?? false,
        location: json["location"] ?? "",
        profilePicture: json["profilePicture"] ?? "",
        profileSlug: json["profileSlug"] ?? "",
      );
}

class Post {
  Post({
    this.authId,
    this.postId,
    this.content,
    this.imageMediaItems,
    this.videoMediaItem,
    this.audioMediaItem,
    this.nUpvotes,
    this.nLikes,
    this.nComments,
    this.nDownvotes,
    this.location,
    this.postRating,
    this.postSlug,
    this.edited,
    this.commentOption,
    this.mentionList,
    this.hashTags,
    this.isRepost,
    this.isVoted,
    this.repostedPostId,
    this.repostedPost,
    this.repostedPostOwnerId,
    this.repostedPostOwnerProfile,
    this.postOwnerProfile,
    this.isLiked,
    this.createdAt,
    this.updatedAt,
  });

  final String? authId;
  final String? postId;
  final String? content;
  final List<String>? imageMediaItems;
  final String? videoMediaItem;
  final String? audioMediaItem;
  int? nUpvotes;
  int? nLikes;
  int? nComments;
  int? nDownvotes;
  final String? location;
  final String? postRating;
  final Post? repostedPost;
  final String? postSlug;
  final bool? edited;
  final String? commentOption;
  final List<String>? mentionList;
  final List<String>? hashTags;
  bool? isRepost;
  String? isVoted;
  final String? repostedPostId;
  final String? repostedPostOwnerId;
  final ErProfile? repostedPostOwnerProfile;
  final ErProfile? postOwnerProfile;
  bool? isLiked;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        repostedPost: json["repostedPost"] != null
            ? Post.fromJson(json["repostedPost"])
            : null,
        authId: json["authId"],
        postId: json["postId"],
        content: json["content"] ?? "",
        imageMediaItems: json["imageMediaItems"] == null
            ? null
            : List<String>.from(json["imageMediaItems"].map((x) => x)),
        videoMediaItem: json["videoMediaItem"] ?? "",
        audioMediaItem: json["audioMediaItem"] ?? "",
        nUpvotes: json["nUpvotes"] ?? 0,
        nLikes: json["nLikes"] ?? 0,
        nComments: json["nComments"] ?? 0,
        nDownvotes: json["nDownvotes"] ?? 0,
        location: json["location"] ?? "",
        postRating: json["postRating"] ?? "",
        postSlug: json["postSlug"] ?? "",
        edited: json["edited"] ?? false,
        commentOption: json["commentOption"] ?? "",
        mentionList: List<String>.from(json["mentionList"].map((x) => x)),
        hashTags: json["hashTags"] == null
            ? null
            : List<String>.from(json["hashTags"].map((x) => x)),
        isRepost: json["isRepost"] ?? false,
        repostedPostId: json["repostedPostId"] ?? "",
        repostedPostOwnerId: json["repostedPostOwnerId"] ?? "",
        repostedPostOwnerProfile: json["repostedPostOwnerProfile"] == null
            ? null
            : ErProfile.fromJson(json["repostedPostOwnerProfile"]),
        postOwnerProfile: json["postOwnerProfile"] == null
            ? null
            : ErProfile.fromJson(json["postOwnerProfile"]),
        isLiked: json["isLiked"] ?? false,
        isVoted: json["isVoted"] ?? 'false',
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );
}
