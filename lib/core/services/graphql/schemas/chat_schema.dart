// class ChatSchema {
//   ChatSchema._();
//
//   static String get schema {
//     return r'''
//       _id
//       id
//       senderId
//       receiverId
//       receivers
//       type
//       value
//       threadId
//       sentAt
//       createdAt
//       updatedAt
//           ''';
//   }
// }
class ChatSchema {
  ChatSchema._();

  static String get schema {
    return r'''
      id 
      senderId 
      receiverId
      contentType 
      content 
      threadId 
      sentAt
      messageMode
      created_at 
      updated_at 
          ''';
  }
}

class ChatThreadSchema {
  ChatThreadSchema._();

  static String get schema {
    return r'''
      id 
      participants 
      participantsInfo {
        firstName
        lastName
        profilePicture
        id
        username
      }
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

// class ChatSubSchema {
//   ChatSubSchema._();

//   static String get schema {
//     return r'''
//       id
//       senderId
//       receiverId
//       type
//       value
//       threadId
//       sentAt
//           ''';
//   }
// }
