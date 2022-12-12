class StatusModel {
  String? type;
  StatusProfileModel? profileModel;
  String? authId;
  String? statusId;
  DateTime? createdAt;
  StatusDataModel? statusData;
  String? statusSlug;
  bool? isMuted;

  StatusModel({
    this.type,
    this.profileModel,
    this.authId,
    this.createdAt,
    this.statusId,
    this.statusData,
    this.statusSlug,
    this.isMuted,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        type: json["type"],
        authId: json["authId"],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json["created_at"])
            : null,
        statusData: json['data'] != null
            ? StatusDataModel.fromJson(json["data"])
            : null,
        profileModel: json['statusOwnerProfile'] != null
            ? StatusProfileModel.fromJson(json["statusOwnerProfile"])
            : null,
        statusId: json["statusId"],
        isMuted: json["isMuted"],
        statusSlug: json["statusSlug"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": statusData!.toJson(),
        "profile": profileModel!.toJson(),
        "authId": authId,
        "created_at": createdAt!.toIso8601String(),
        "statusId": statusId,
        "isMuted": isMuted,
        "statusSlug": statusSlug,
      };
}

class StatusDataModel {
  String? alignment;
  String? audioMedia;
  String? background;
  String? caption;
  String? content;
  String? font;
  String? imageMedia;
  String? videoMedia;

  StatusDataModel({
    this.alignment,
    this.audioMedia,
    this.background,
    this.caption,
    this.content,
    this.font,
    this.imageMedia,
    this.videoMedia,
  });

  factory StatusDataModel.fromJson(Map<String, dynamic> json) =>
      StatusDataModel(
        alignment: json["alignment"],
        audioMedia: json["audioMedia"],
        background: json["background"],
        caption: json["caption"],
        content: json["content"],
        font: json["font"],
        imageMedia: json["imageMedia"],
        videoMedia: json["videoMedia"],
      );

  Map<String, dynamic> toJson() => {
        "alignment": alignment,
        "audioMedia": audioMedia,
        "background": background,
        "caption": caption,
        "content": content,
        "font": font,
        "imageMedia": imageMedia,
        "videoMedia": videoMedia,
      };
}

class StatusProfileModel {
  String? firstName;
  String? lastName;
  String? location;
  String? profilePicture;
  String? profileSlug;
  String? username;
  bool? verified;
  String? authId;
  String? bio;

  StatusProfileModel({
    this.firstName,
    this.lastName,
    this.location,
    this.profilePicture,
    this.profileSlug,
    this.username,
    this.verified,
    this.authId,
    this.bio,
  });

  factory StatusProfileModel.fromJson(Map<String, dynamic> json) =>
      StatusProfileModel(
        location: json["location"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        verified: json["verified"],
        username: json["username"],
        authId: json["authId"],
        bio: json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "firstName": firstName,
        "lastName": lastName,
        "profilePicture": profilePicture,
        "profileSlug": profileSlug,
        "verified": verified,
        "username": username,
        "bio": bio,
        "authId": authId,
      };
}

// class StatusFeedModel {
//   String? id;
//   List<StatusFeedResponseModel>? status;

//   StatusFeedModel({this.id, this.status});

//   factory StatusFeedModel.fromJson(Map<String, dynamic> json) =>
//       StatusFeedModel(
//         id: json["_id"],
//         status: json["status"] != null
//             ? (json["status"] as List)
//                 .map((i) => StatusFeedResponseModel.fromJson(i))
//                 .toList()
//             : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "status":
//             status != null ? status!.map((i) => i.toJson()).toList() : null,
//       };
// }

class StatusFeedModel {
  DateTime? createdAt;
  StatusProfileModel? feedOwnerProfile;
  bool? reachingRelationship;
  StatusModel? status;
  StatusProfileModel? statusOwnerProfile;
  String? username;

  StatusFeedModel({
    this.createdAt,
    this.feedOwnerProfile,
    this.reachingRelationship,
    this.status,
    this.statusOwnerProfile,
    this.username,
  });

  factory StatusFeedModel.fromJson(Map<String, dynamic> json) =>
      StatusFeedModel(
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        feedOwnerProfile: json["feedOwnerProfile"] != null
            ? StatusProfileModel.fromJson(json["feedOnwerProfile"])
            : null,
        reachingRelationship: json["reachingRelationship"],
        status: json["status"] != null
            ? StatusModel.fromJson(json["status"])
            : null,
        statusOwnerProfile: json["statusOwnerProfile"] != null
            ? StatusProfileModel.fromJson(json["statusOwnerProfile"])
            : null,
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt!.toIso8601String(),
        "feedOwnerProfile": feedOwnerProfile!.toJson(),
        "reachingRelationship": reachingRelationship,
        "status": status!.toJson(),
        "statusOwnerProfile": statusOwnerProfile!.toJson(),
        "username": username,
      };
}

class StatusFeedResponseModel {
  String? id;
  List<StatusFeedModel>? status;

  StatusFeedResponseModel({
    this.id,
    this.status,
  });


  factory StatusFeedResponseModel.fromJson(Map<String, dynamic> json) =>
      StatusFeedResponseModel(
        id: json["_id"],
        status: json["status"] != null
            ? (json["status"] as List)
                .map((i) => StatusFeedModel.fromJson(i))
                .toList()
            : null,
      );


  Map<String, dynamic> tojson() => {
    "_id":id,
    "status": status != null ? status!.map((e) => e.toJson()).toList() : null,
  };
}

// class StatusFeedResponseModel {
//   String? firstName;
//   String? lastName;
//   String? location;
//   String? profilePicture;
//   String? profileSlug;
//   String? reacherId;
//   StatusModel? status;
//   String? statusId;
//   StatusProfileModel? statusCreatorModel;
//   bool? verified;
//   String? username;
//   DateTime? createdAt;
//   String? authId;

//   StatusFeedResponseModel({
//     this.firstName,
//     this.lastName,
//     this.location,
//     this.profilePicture,
//     this.profileSlug,
//     this.username,
//     this.verified,
//     this.reacherId,
//     this.status,
//     this.statusCreatorModel,
//     this.statusId,
//     this.authId,
//     this.createdAt,
//   });

//   factory StatusFeedResponseModel.fromJson(Map<String, dynamic> json) =>
//       StatusFeedResponseModel(
//         location: json["location"],
//         firstName: json["firstName"],
//         lastName: json["lastName"],
//         profilePicture: json["profilePicture"],
//         profileSlug: json["profileSlug"],
//         verified: json["verified"],
//         username: json["username"],
//         reacherId: json["reacherId"],
//         status: json["status"] != null
//             ? StatusModel.fromJson(json["status"])
//             : null,
//         statusCreatorModel: json['status_creator_profile'] != null
//             ? StatusProfileModel.fromJson(json["status_creator_profile"])
//             : null,
//         statusId: json["statusId"],
//         authId: json["authId"],
//         createdAt: json['created_at'] != null
//             ? DateTime.parse(json["created_at"])
//             : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "location": location,
//         "firstName": firstName,
//         "lastName": lastName,
//         "profilePicture": profilePicture,
//         "profileSlug": profileSlug,
//         "verified": verified,
//         "username": username,
//         "reacherId": reacherId,
//         "status": status!.toJson(),
//         "status_creator_profile": statusCreatorModel!.toJson(),
//         "statusId": statusId,
//         "authId": authId,
//         "created_at": createdAt!.toIso8601String(),
//       };
// }

class MutedStatusModel {
  String? authId;
  String? mutedAuthId;

  MutedStatusModel({
    this.authId,
    this.mutedAuthId,
  });

  factory MutedStatusModel.fromJson(Map<String, dynamic> json) =>
      MutedStatusModel(
        authId: json["authId"],
        mutedAuthId: json["mutedAuthId"],
      );

  Map<String, dynamic> toJson() => {
        "authId": authId,
        "mutedAuthId": mutedAuthId,
      };
}

class ReportStatusModel {
  String? authId;
  String? reason;
  String? statusId;

  ReportStatusModel({
    this.authId,
    this.reason,
    this.statusId,
  });

  factory ReportStatusModel.fromJson(Map<String, dynamic> json) =>
      ReportStatusModel(
        authId: json["authId"],
        reason: json["reason"],
        statusId: json["statusId"],
      );

  Map<String, dynamic> toJson() => {
        "authId": authId,
        "reason": reason,
        "statusId": statusId,
      };
}
