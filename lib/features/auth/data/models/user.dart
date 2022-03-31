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
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "token": token,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
        "is_active": isActive,
        "last_login": lastLogin,
      };
}
