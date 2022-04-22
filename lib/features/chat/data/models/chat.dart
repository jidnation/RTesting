import 'package:reach_me/core/models/user.dart';

class Chat {
  Chat({
    // this._id,
    this.id,
    this.senderId,
    this.receiverId,
    // this.receivers,
    this.type,
    this.value,
    this.threadId,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
  });
  //late final Null _id;
  String? id;
  String? senderId;
  String? receiverId;
  //  List<dynamic> receivers;
  String? type;
  String? value;
  String? threadId;
  String? sentAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  Chat.fromJson(Map<String, dynamic> json) {
    // _id = null;
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    // receivers = List.castFrom<dynamic, dynamic>(json['receivers']);
    type = json['type'];
    value = json['value'];
    threadId = json['threadId'];
    sentAt = json['sentAt'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    //  _data['_id'] = _id;
    _data['id'] = id;
    _data['senderId'] = senderId;
    _data['receiverId'] = receiverId;
    //  _data['receivers'] = receivers;
    _data['type'] = type;
    _data['value'] = value;
    _data['threadId'] = threadId;
    _data['sentAt'] = sentAt;
    _data['createdAt'] =
        createdAt != null ? createdAt!.toIso8601String() : null;
    _data['updatedAt'] =
        updatedAt != null ? updatedAt!.toIso8601String() : null;
    return _data;
  }
}

class ChatsThread {
  ChatsThread({
    this.id,
    this.participants,
    this.tailMessage,
    this.createdAt,
    this.updatedAt,
    this.participantsInfo,
  });
  String? id;
  List<String>? participants;
  List<ChatUser>? participantsInfo;
  Chat? tailMessage;
  String? createdAt;
  String? updatedAt;

  ChatsThread.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List.castFrom<dynamic, String>(json['participants']);
    tailMessage = Chat.fromJson(json['tailMessage']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    participantsInfo = List<ChatUser>.from(
        json['participantsInfo'].map((item) => ChatUser.fromJson(item)));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['participants'] = participants;
    _data['tailMessage'] = tailMessage!.toJson();
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['participantsInfo'] =
        participantsInfo?.map((item) => item.toJson()).toList();
    return _data;
  }
}
