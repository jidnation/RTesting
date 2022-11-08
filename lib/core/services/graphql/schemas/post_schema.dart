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
            nDownvotes
            nUpvotes
            postId
            postSlug
            videoMediaItem
            like {
              ''' +
        PostLikeSchema.schema +
        '''}
          vote {
              ''' +
        PostVoteSchema.schema +
        '''}
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
            like {
              ''' +
        PostLikeSchema.schema +
        '''
            }
            vote {
              ''' +
        PostVoteSchema.schema +
        '''
            }
            postId
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
            like {
              ''' +
        CommentLikeSchema.schema +
        '''
            }
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
            username
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
            like {
              ''' +
        PostLikeSchema.schema +
        '''}
            vote {
              ''' +
        PostVoteSchema.schema +
        '''}
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

class PostLikeSchema {
  PostLikeSchema._();

  static String get schema {
    return r'''
            authId
            created_at
            postId
            profile {
              ''' +
        PostProfileSchema.schema +
        '''
            }
        ''';
  }
}

class CommentLikeSchema {
  CommentLikeSchema._();

  static String get schema {
    return r'''
            authId
            created_at
            postId
            commentId
            profile {
              ''' +
        PostProfileSchema.schema +
        '''
            }
        ''';
  }
}

class PostVoteSchema {
  PostVoteSchema._();

  static String get schema {
    return r'''
            authId
            created_at
            postId
            voteType
        ''';
  }
}
