class PostSchema {
  PostSchema._();

  static String get schema {
    return r'''
            audioMediaItem
            authId
            commentOption
            content
            edited
            hashTags
            created_at
            imageMediaItems
            location
            mentionList
            nComments
            nLikes
            nShares
            postId
            postSlug
            videoMediaItem
            profile {
              ''' +
        PostProfileSchema.schema +
        '''
            }
        ''';
  }
}
class SavePostSchema {
  SavePostSchema._();

  static String get schema {
    return r'''
            audioMediaItem
            authId
            content
            imageMediaItems
            postId
            savedPostId
            videoMediaItem
            profile {
              ''' +
        PostProfileSchema.schema +
        '''
            }
        ''';
  }
}

class CommentSchema {
  CommentSchema._();

  static String get schema {
    return r'''
            commentId 
            authId
            commentSlug
            content
            created_at
            nComments
            nLikes
            postId
            profile {
              ''' +
        CommentProfileSchema.schema +
        '''
            }
        ''';
  }
}

class PostProfileSchema {
  PostProfileSchema._();

  static String get schema {
    return r'''
            firstName
            lastName
            location
            profilePicture
            profileSlug
            verified
        ''';
  }
}

class CommentProfileSchema {
  CommentProfileSchema._();

  static String get schema {
    return r'''
            firstName
            lastName
            location
            profilePicture
            profileSlug
            username
            verified
        ''';
  }
}

class PostFeedSchema {
  PostFeedSchema._();

  static String get schema {
    return r'''
            feedOwnerId
            created_at
            firstName
            lastName
            location
            postId
            profilePicture
            profileSlug
            username
            isLiked
            verified
            reachingRelationship
            postOwnerId
        ''';
  }
}

class StarUserSchema {
  StarUserSchema._();

  static String get schema {
    return r'''
            authId
            created_at
            starredId
            starred {''' +
        StarProfileSchema.schema +
        ''' }
            user {''' +
        StarProfileSchema.schema +
        ''' }     
        ''';
  }
}

class StarProfileSchema {
  StarProfileSchema._();

  static String get schema {
    return r'''
            firstName
            lastName
            profilePicture
            profileSlug
            username
        ''';
  }
}
