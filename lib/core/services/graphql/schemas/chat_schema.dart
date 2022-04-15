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
      _id 
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
