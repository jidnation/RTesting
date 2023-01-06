class GetRecentlyAddedWord {
  GetRecentlyAddedWord({
    this.abbr,
    this.authId,
    this.meaning,
    this.createdAt,
    this.language,
    this.word,
    this.wordId,
    this.wordOwnerProfile,
  });

  String? abbr;
  String? authId;
  String? meaning;
  String? createdAt;
  String? language;
  String? word;
  String? wordId;
  WordOwnerProfile? wordOwnerProfile;

  factory GetRecentlyAddedWord.fromJson(Map<String, dynamic> json) =>
      GetRecentlyAddedWord(
        abbr: json["abbr"] ?? 'NULL',
        authId: json["authId"] ?? 'NULL',
        meaning: json["meaning"] ?? 'NULL',
        createdAt: json["created_at"] ?? 'NULL',
        language: json["language"] ?? 'NULL',
        word: json["word"] ?? 'NULL',
        wordId: json["wordId"] ?? 'NULL',
        wordOwnerProfile: WordOwnerProfile.fromJson(json["wordOwnerProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "abbr": abbr,
        "authId": authId,
        "meaning": meaning,
        "created_at": createdAt,
        "language": language,
        "word": word,
        "wordId": wordId,
        "wordOwnerProfile": wordOwnerProfile!.toJson(),
      };
}

class WordOwnerProfile {
  WordOwnerProfile({
    this.verified,
    this.lastName,
    this.authId,
    this.firstName,
    this.location,
    this.profileSlug,
    this.profilePicture,
    this.username,
    this.bio,
  });

  bool? verified;
  String? lastName;
  String? authId;
  String? firstName;
  dynamic location;
  String? profileSlug;
  dynamic profilePicture;
  String? username;
  dynamic bio;

  factory WordOwnerProfile.fromJson(Map<String, dynamic> json) =>
      WordOwnerProfile(
        verified: json["verified"] ?? false,
        lastName: json["lastName"] ?? 'NULL',
        authId: json["authId"] ?? 'NULL',
        firstName: json["firstName"] ?? 'NULL',
        location: json["location"],
        profileSlug: json["profileSlug"] ?? 'NULL',
        profilePicture: json["profilePicture"],
        username: json["username"] ?? 'NULL',
        bio: json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "lastName": lastName,
        "authId": authId,
        "firstName": firstName,
        "location": location,
        "profileSlug": profileSlug,
        "profilePicture": profilePicture,
        "username": username,
        "bio": bio,
      };
}
