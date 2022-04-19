class ChatSchema {
  ChatSchema._();

  static String get schema {
    return r'''
      _id 
      id 
      senderId 
      receiverId
      receivers 
      type 
      value 
      threadId 
      sentAt 
      createdAt 
      updatedAt 
          ''';
  }
}

class ChatThreadSchema {
  ChatThreadSchema._();

  static String get schema {
    return r'''
      id 
      participants 
      tailMessage {
        _id 
        id 
        senderId 
        receiverId
        receivers 
        type 
        value 
        threadId 
        sentAt 
        createdAt 
        updatedAt 
      }
      createdAt
      updatedAt
          ''';
  }
}

class ChatSubSchema {
  ChatSubSchema._();

  static String get schema {
    return r'''
      id 
      senderId 
      receiverId
      type 
      value 
      threadId 
      sentAt 
          ''';
  }
}