class PostSchema {
  PostSchema._();

  static String get schema {
    return r'''
            audioMediaItem
            commentOption
            content
            created_at
            edited
            hashTags
            imageMediaItems
            isLiked
            isRepost
            isVoted
            location
            mentionList
            nComments
            nLikes
            nDownvotes
            nUpvotes
            postId
            postRating
            postSlug
            profile {
              ''' +
        PostProfileSchema.schema +
        '''
            }
            updated_at
            videoMediaItem
        ''';
  }
}

// repostedPost {''' +
//         PostSchema.schema +
//         ''' }
// repostedPostId
// repostedPostOwnerId
// repostedPostOwnerProfile {''' +
//         PostProfileSchema.schema +
//         ''' }

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
            postOwner {
              ''' +
        CommentProfileSchema.schema +
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
            authId
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
              created_at
              isLiked
              isRepost
              isVoted
              post {''' +
        PostSchema.schema +
        ''' }
              postOwnerProfile {''' +
        PostProfileSchema.schema +
        ''' }
              reachingRelationship
              repostedPost {''' +
        PostSchema.schema +
        ''' }
              repostedPostId
              repostedPostOwnerId
              repostedPostOwnerProfile {''' +
        PostProfileSchema.schema +
        ''' }
              updated_at
              voterProfile {''' +
        PostProfileSchema.schema +
        ''' }
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
