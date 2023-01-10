import 'package:reach_me/core/models/user.dart';

class Chat {
  Chat({
    this.id,
    this.senderId,
    this.receiverId,
    this.content,
    this.contentType,
    this.threadId,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
  });
  //late final Null _id;
  String? id;
  String? senderId;
  String? receiverId;
  String? contentType;
  //  List<dynamic> receivers;
  String? content;
  String? threadId;
  String? sentAt;
  String? messageMode;
  DateTime? createdAt;
  DateTime? updatedAt;

  Chat.fromJson(Map<String, dynamic> json) {
    // _id = null;
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    // receivers = List.castFrom<dynamic, dynamic>(json['receivers']);
    contentType = json['contentType'];
    content = json['content'];
    threadId = json['threadId'];
    sentAt = json['sentAt'];
    messageMode = json['messageMode'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updated_at']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    //  _data['_id'] = _id;
    _data['id'] = id;
    _data['senderId'] = senderId;
    _data['receiverId'] = receiverId;
    //  _data['receivers'] = receivers;
    _data['contentType'] = contentType;
    _data['content'] = content;
    _data['threadId'] = threadId;
    _data['sentAt'] = sentAt;
    _data['created_at'] =
        createdAt != null ? createdAt!.toIso8601String() : null;
    _data['updated_at'] =
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
