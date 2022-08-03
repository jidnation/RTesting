class User {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? token;
  String? id;
  // String? authId;
  String? bio;
  DateTime? dateofBirth;
  String? coverPicture;
  String? gender;
  String? location;
  String? profilePicture;
  String? profileSlug;
  bool? showContact;
  bool? showLocation;
  String? username;
  bool? verified;
  int? nReachers;
  int? nReaching;
  int? nStaring;
  ReachingRelationship? reaching;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.token,
    this.id,
    // this.authId,
    this.bio,
    this.dateofBirth,
    this.coverPicture,
    this.gender,
    this.location,
    this.profilePicture,
    this.profileSlug,
    this.showContact,
    this.showLocation,
    this.username,
    this.verified,
    this.nReachers,
    this.nReaching,
    this.nStaring,
    this.reaching,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        //id: json["_id"],
        id: json["authId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        token: json["token"],
        bio: json["bio"],
        dateofBirth: json["dateOfBirth"] != null
            ? DateTime.tryParse(json["dateOfBirth"])
            : null,
        coverPicture: json["coverPicture"],
        gender: json["gender"],
        location: json["location"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        showContact: json["showContact"],
        showLocation: json["showLocation"],
        nReachers: json["nReachers"],
        nReaching: json["nReaching"],
        nStaring: json["nStaring"],
        username: json["username"],
        verified: json["verified"],
        reaching: json["reaching"] != null
            ? ReachingRelationship.fromJson(json["reaching"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "token": token,
        "authId": id,
        // "authId": authId,
        "bio": bio,
        "dateOfBirth":
            dateofBirth != null ? dateofBirth!.toIso8601String() : null,
        "coverPicture": coverPicture,
        "gender": gender,
        "location": location,
        "profilePicture": profilePicture,
        "profileSlug": profileSlug,
        "showContact": showContact,
        "showLocation": showLocation,
        "nReachers": nReachers,
        "nReaching": nReaching,
        "nStaring": nStaring,
        "username": username,
        "verified": verified,
        "reaching": reaching!.toJson(),
      };
}

class ChatUser {
  ChatUser({this.firstName, this.id, this.lastName, this.profilePicture});
  String? id;
  String? firstName;
  String? lastName;
  String? profilePicture;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "profilePicture": profilePicture,
      };
}

class ReachingRelationship {
  ReachingRelationship({
    this.reacherId,
    this.reachingId,
  });
  String? reacherId;
  String? reachingId;

  factory ReachingRelationship.fromJson(Map<String, dynamic> json) =>
      ReachingRelationship(
        reacherId: json["reacherId"],
        reachingId: json["reachingId"],
      );

  Map<String, dynamic> toJson() => {
        "reacherId": reacherId,
        "reachingId": reachingId,
      };
}
