class StarModel {
  String? starredId;
  String? authId;
  DateTime? createdAt;
  StarProfileModel? user;
  StarProfileModel? starred;

  StarModel({
    this.starredId,
    this.authId,
    this.createdAt,
    this.user,
    this.starred,
  });

  factory StarModel.fromJson(Map<String, dynamic> json) => StarModel(
        starredId: json["starredId"],
        authId: json["authId"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        user: json["user"] != null
            ? StarProfileModel.fromJson(json["user"])
            : null,
        starred: json["starred"] != null
            ? StarProfileModel.fromJson(json["starred"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "starredId": starredId,
        "authId": authId,
        "created_at": createdAt,
        "user": user!.toJson(),
        "starred": starred!.toJson(),
      };
}

class StarProfileModel {
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? profileSlug;
  String? starred;
  String? username;

  StarProfileModel({
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.profileSlug,
    this.starred,
    this.username,
  });

  factory StarProfileModel.fromJson(Map<String, dynamic> json) =>
      StarProfileModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        starred: json["starred"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "profilePicture": profilePicture,
        "profileSlug": profileSlug,
        "starred": starred!,
        "username": username,
      };
}
