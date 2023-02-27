import 'dart:convert';

MomentFeedModel momentFeedModelFromJson(String str) =>
    MomentFeedModel.fromJson(json.decode(str));

class MomentFeedModel {
  MomentFeedModel({
    this.typename,
    this.getMomentFeed,
  });

  final String? typename;
  List<GetMomentFeed>? getMomentFeed;

  factory MomentFeedModel.fromJson(Map<String, dynamic> json) =>
      MomentFeedModel(
        typename: json[" __typename"],
        getMomentFeed: List<GetMomentFeed>.from(
            json["getMomentFeed"].map((x) => GetMomentFeed.fromJson(x))),
      );
}

class GetMomentFeed {
  GetMomentFeed({
    this.createdAt,
    this.updatedAt,
    this.feedOwnerProfile,
    this.moment,
    this.reachingRelationship,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OwnerProfile? feedOwnerProfile;
  Moment? moment;
  final bool? reachingRelationship;

  factory GetMomentFeed.fromJson(Map<String, dynamic> json) => GetMomentFeed(
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        feedOwnerProfile: json["feedOwnerProfile"] != null
            ? OwnerProfile.fromJson(json["feedOwnerProfile"])
            : null,
        moment: json["moment"] != null ? Moment.fromJson(json["moment"]) : null,
        reachingRelationship: json["reachingRelationship"] ?? false,
      );
}

class OwnerProfile {
  OwnerProfile({
    this.bio,
    this.authId,
    this.firstName,
    this.lastName,
    this.location,
    this.username,
    this.profilePicture,
    this.profileSlug,
  });

  final dynamic bio;
  final String? authId;
  final String? firstName;
  final String? lastName;
  final dynamic location;
  final String? username;
  final String? profilePicture;
  final String? profileSlug;

  factory OwnerProfile.fromJson(Map<String, dynamic> json) => OwnerProfile(
        bio: json["bio"] ?? "",
        authId: json["authId"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        location: json["location"] ?? "",
        username: json["username"] ?? "",
        profilePicture: json["profilePicture"] ?? "",
        profileSlug: json["profileSlug"] ?? "",
      );
}

class Moment {
  Moment({
    this.momentId,
    this.caption,
    this.authId,
    this.mentionList,
    this.hashTags,
    this.createdAt,
    this.isLiked,
    this.nLikes,
    this.nComments,
    this.momentSlug,
    this.sound,
    this.musicName,
    this.videoMediaItem,
    this.momentOwnerProfile,
  });

  String? momentId;
  String? caption;
  String? authId;
  List<String>? mentionList;
  List<String>? hashTags;
  DateTime? createdAt;
  bool? isLiked;
  int? nLikes;
  int? nComments;
  String? momentSlug;
  String? sound;
  String? musicName;
  String? videoMediaItem;
  final OwnerProfile? momentOwnerProfile;

  factory Moment.fromJson(Map<String, dynamic> json) => Moment(
        momentId: json["momentId"].toString(),
        caption: json["caption"] ?? '',
        authId: json["authId"] ?? '',
        mentionList: json["mentionList"] != null
            ? List<String>.from(json["mentionList"].map((x) => x))
            : null,
        hashTags: json["hashTags"] != null
            ? List<String>.from(json["hashTags"].map((x) => x))
            : null,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        isLiked: json["isLiked"] ?? "",
        nLikes: json["nLikes"] ?? "",
        nComments: json["nComments"] ?? "",
        momentSlug: json["momentSlug"] ?? "",
        sound: json["sound"] ?? "",
        musicName: json["musicName"] ?? "",
        videoMediaItem: json["videoMediaItem"] ?? "",
        momentOwnerProfile: json["momentOwnerProfile"] != null
            ? OwnerProfile.fromJson(json["momentOwnerProfile"])
            : null,
      );
}
