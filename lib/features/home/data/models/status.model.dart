class StatusModel {
  String? type;
  StatusProfileModel? profileModel;
  String? authId;
  String? statusId;
  DateTime? createdAt;
  StatusDataModel? statusData;

  StatusModel({
    this.type,
    this.profileModel,
    this.authId,
    this.createdAt,
    this.statusId,
    this.statusData,
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
        profileModel: json['profile'] != null
            ? StatusProfileModel.fromJson(json["profile"])
            : null,
        statusId: json["statusId"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": statusData!.toJson(),
        "profile": profileModel!.toJson(),
        "authId": authId,
        "created_at": createdAt!.toIso8601String(),
        "statusId": statusId,
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
  String? typeName;

  StatusDataModel({
    this.alignment,
    this.audioMedia,
    this.background,
    this.caption,
    this.content,
    this.font,
    this.imageMedia,
    this.videoMedia,
    this.typeName,
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
        typeName: json["__typename"],
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
        "__typename": typeName,
      };
}

class StatusProfileModel {
  String? firstName;
  String? lastName;
  String? location;
  String? profilePicture;
  String? profileSlug;
  bool? verified;
  String? username;

  StatusProfileModel({
    this.firstName,
    this.lastName,
    this.location,
    this.profilePicture,
    this.profileSlug,
    this.username,
    this.verified,
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
