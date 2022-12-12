class LoginResponse {
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

  LoginResponse({
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
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        token: json["token"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        isActive: json["isActive"],
        lastLogin: json["lastLogin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "token": token,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "isActive": isActive,
        "lastLogin": lastLogin,
      };
}

class PayLoadWithToken {
  String? token;

  PayLoadWithToken({this.token});

  factory PayLoadWithToken.fromJson(Map<String, dynamic> json) =>
      PayLoadWithToken(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
