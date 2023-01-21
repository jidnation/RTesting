import 'dart:convert';

import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';

class Chat {
  Chat(
      {
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
      this.quotedData});
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

  String? messageMode;
  String? quotedData;

  Chat.fromJson(Map<String, dynamic> json) {
    // _id = null;
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    // receivers = List.castFrom<dynamic, dynamic>(json['receivers']);
    type = json['contentType'];
    value = json['content'];
    threadId = json['threadId'];
    sentAt = json['sentAt'];
    messageMode = json['messageMode'];
    quotedData = json['quotedData'];
    createdAt = json['created_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['created_at']))
        : null;
    updatedAt = json['updated_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['updated_at']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    //  _data['_id'] = _id;
    _data['id'] = id;
    _data['senderId'] = senderId;
    _data['receiverId'] = receiverId;
    //  _data['receivers'] = receivers;
    _data['contentType'] = type;
    _data['content'] = value;
    _data['threadId'] = threadId;
    _data['sentAt'] = sentAt;
    _data['messageMode'] = messageMode;
    _data['quotedData'] = quotedData;
    _data['created_at'] =
        createdAt != null ? createdAt!.toIso8601String() : null;
    _data['updated_at'] =
        updatedAt != null ? updatedAt!.toIso8601String() : null;
    return _data;
  }

  bool? get quotedFromPost {
    if (quotedData == null) return null;
    if (jsonDecode(quotedData!)['status'] == null) {
      return true;
    } else {
      return false;
    }
  }

  StatusFeedModel? get quotedStatus {
    if (quotedData == null) return null;
    if (!(quotedFromPost ?? false)) {
      return StatusFeedModel.fromJson(jsonDecode(quotedData!));
    }
    return null;
  }

  PostFeedModel? get quotedPost {
    if (quotedData == null) return null;
    if (quotedFromPost ?? false) {
      return PostFeedModel.fromJson(jsonDecode(quotedData!));
    }
    return null;
  }

  String? get quotedType {
    if (quotedData == null) return null;
    if (quotedFromPost ?? false) {
      if ((quotedPost?.post?.content ?? '').isNotEmpty) return 'text';
      if ((quotedPost?.post?.isOnlyImages ?? false) &&
          (quotedPost?.post?.imageMediaItems?.length ?? 0) == 1) return 'image';
      if (quotedPost?.post?.isOnlyAudio ?? false) return 'audio';
      if (quotedPost?.post?.isOnlyVideo ?? false) return 'video';
      if ((quotedPost?.post?.isOnlyImages ?? false) &&
          (quotedPost?.post?.imageMediaItems?.length ?? 0) > 1) return 'images';
    } else {
      return quotedStatus?.status?.type;
    }
    return null;
  }

  String? get quotedContent {
    if (quotedData == null) return null;
    if (quotedFromPost ?? false) {
      return quotedType == 'text'
          ? quotedPost?.post?.content ?? ''
          : 'Media attachment(s)';
    } else {
      return quotedType == 'text'
          ? quotedStatus?.status?.statusData?.content ?? ''
          : 'Media attachment';
    }
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
    this.private,
  });
  String? id;
  List<String>? participants;
  List<ChatUser>? participantsInfo;
  Chat? tailMessage;
  String? createdAt;
  String? updatedAt;
  bool? private;

  ChatsThread.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List.castFrom<dynamic, String>(json['participants']);
    tailMessage = Chat.fromJson(json['tailMessage']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    private = json['private'];
    participantsInfo = json['participantsProfile'] == null || (json['participantsProfile'] as List).contains(null)
        ? null
        : List<ChatUser>.from(
            json['participantsProfile'].map((item) => ChatUser.fromJson( item)));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['participants'] = participants;
    _data['tailMessage'] = tailMessage!.toJson();
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['private'] = private;
    _data['participantsProfile'] =
        participantsInfo?.map((item) => item.toJson()).toList();
    return _data;
  }
}

enum MessageMode { quoted, direct }
