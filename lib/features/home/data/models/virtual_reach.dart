import 'package:reach_me/core/models/user.dart';

class VirtualReach {
  String? reachingId;
  String? reacherId;
  User? reacher;
  User? reaching;

  VirtualReach({
    this.reacher,
    this.reacherId,
    this.reaching,
    this.reachingId,
  });

  factory VirtualReach.fromJson(Map<String, dynamic> json) => VirtualReach(
        reacher:
            json["reacher"] != null ? User.fromJson(json["reacher"]) : null,
        reaching:
            json["reaching"] != null ? User.fromJson(json["reaching"]) : null,
        reachingId: json["reachingId"],
        reacherId: json["reacherId"],
      );

  Map<String, dynamic> toJson() => {
        "reacher": reacher == null ? null : reacher!.toJson(),
        "reaching": reaching == null ? null : reaching!.toJson(),
        "reachingId": reachingId,
        "reacherId": reacherId,
      };
}

class VirtualStar {
  String? starredId;
  String? userId;
  User? user;
  User? starred;

  VirtualStar({
    this.user,
    this.userId,
    this.starred,
    this.starredId,
  });

  factory VirtualStar.fromJson(Map<String, dynamic> json) => VirtualStar(
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        starred:
            json["starred"] != null ? User.fromJson(json["starred"]) : null,
        starredId: json["starredId"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user!.toJson(),
        "starred": starred == null ? null : starred!.toJson(),
        "starredId": starredId,
        "userId": userId,
      };
}
