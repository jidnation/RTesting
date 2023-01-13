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
      threadId
      senderId 
      messageMode
      contentType 
      content
      sentAt
      quotedData
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
      tailMessage {
               ''' +
        ChatSchema.schema +
        '''
            }
      private
      participantsProfile{
      ''' +
        ChatUserProfileSchema.schema +
        '''
      }
          ''';
  }
}

class ChatUserProfileSchema {
  ChatUserProfileSchema._();

  static String get schema {
    return r'''
            authId
            firstName
            lastName
            location
            profilePicture
            profileSlug
            username
            verified
            bio
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
