class User {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? token;
  String? updatedAt;
  String? createdAt;
  String? id;
  bool? isActive;
  String? lastLogin;
  String? userId;
  String? bio;
  DateTime? dateofBirth;
  String? displayPicture;
  String? gender;
  String? location;
  String? profilePicture;
  String? profileSlug;
  bool? showContact;
  bool? showLocation;
  String? userQR;
  String? username;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.token,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.isActive,
    this.lastLogin,
    this.userId,
    this.bio,
    this.dateofBirth,
    this.displayPicture,
    this.gender,
    this.location,
    this.profilePicture,
    this.profileSlug,
    this.showContact,
    this.showLocation,
    this.userQR,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        token: json["token"],
        updatedAt: json["updatedAt"],
        createdAt: json["createdAt"],
        id: json["id"],
        isActive: json["isActive"],
        lastLogin: json["lastLogin"],
        userId: json["userId"],
        bio: json["bio"],
        dateofBirth: DateTime.parse(json["dateofBirth"] ?? "2022-04-02 14:48:19.114636") ,
        displayPicture: json["displayPicture"],
        gender: json["gender"],
        location: json["location"],
        profilePicture: json["profilePicture"],
        profileSlug: json["profileSlug"],
        showContact: json["showContact"],
        showLocation: json["showLocation"],
        userQR: json["userQR"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "token": token,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
        "id": id,
        "is_active": isActive,
        "lastLogin": lastLogin,
        "userId": userId,
        "bio": bio,
        "dateOfBirth": dateofBirth!.toIso8601String(),
        "displayPicture": displayPicture,
        "gender": gender,
        "location": location,
        "profilePicture": profilePicture,
        "profileSlug": profileSlug,
        "showContact": showContact,
        "showLocation": showLocation,
        "userQR": userQR,
        "username": username,
      };
}
