class StatusDataSchema {
  StatusDataSchema._();

  static String get schema {
    return r'''
        audioMedia
        background
        imageMedia
        content
        alignment
        font
        caption
        videoMedia
        ''';
  }
}

class StatusSchema {
  StatusSchema._();

  static String get schema {
    return r'''
            authId
            created_at
            data {
               ''' + 
               StatusDataSchema.schema +
               '''
            }
            isMuted
            statusSlug
            statusOwnerProfile {
              ''' +
        StatusProfileSchema.schema +
        '''
            }
            statusId
            type
        ''';
  }
}

class StatusProfileSchema {
  StatusProfileSchema._();

  static String get schema {
    return r'''
            firstName
            lastName
            location
            profilePicture
            profileSlug
            username
            authId
            bio
            verified
        ''';
  }
}

class StatusFeedResponseSchema {
  StatusFeedResponseSchema._();

  static String get schema {
    return r'''
            _id
            status {
              ''' +
        StatusFeedSchema.schema +
        '''
            }
        ''';
  }
}

class StatusFeedSchema {
  StatusFeedSchema._();

  static String get schema {
    return r'''
            created_at
             feedOwnerProfile {
              ''' +
        StatusProfileSchema.schema +
        '''
             }
             reachingRelationship
            status {
              ''' +
        StatusSchema.schema +
        '''
            }
            statusOwnerProfile {
               ''' +
        StatusProfileSchema.schema +
        '''
            }
          username
        ''';
  }
}
