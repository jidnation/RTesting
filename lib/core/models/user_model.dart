import 'dart:io';
class UserModel {
  UserModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.username,
    this.interests,
    this.createdAt,
    this.updatedAt,
    this.avatar,
  });

  String? id;
  String? username;
  String? email;
  String? phoneNumber;
  List<String>? interests;
  String? createdAt;
  String? updatedAt;
  File? avatar;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? '',
        email: json["email"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        interests: List<String>.from(json["interests"].map((x) => x)),
        username: json["username"] ?? "",
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? "",
        "email": email ?? "",
        "phoneNumber": phoneNumber ?? "",
        "interests": List<dynamic>.from(interests!.map((x) => x)),
        "username": username ?? "",
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
