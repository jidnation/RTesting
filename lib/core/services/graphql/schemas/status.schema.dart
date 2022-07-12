class StatusSchema {
  StatusSchema._();

  static String get schema {
    return r'''
            authId
            created_at
            data {
                audioMedia
                background
                imageMedia
                content
                alignment
                font
                caption
                videoMedia
            }
            profile {
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
        ''';
  }
}

class StatusFeedSchema {
  StatusFeedSchema._();

  static String get schema {
    return r'''
            _id
            status {
              ''' +
        StatusFeedResponse.schema +
        '''
            }
        ''';
  }
}

class StatusFeedResponse {
  StatusFeedResponse._();

  static String get schema {
    return r'''
            authId
            created_at
            firstName
            lastName
            location
            profilePicture
            profileSlug
            username
            reacherId
            status {
              ''' +
        StatusSchema.schema +
        '''
            }
            statusId
            status_creator_profile {
               ''' +
        StatusProfileSchema.schema +
        '''
            }
        ''';
  }
}
