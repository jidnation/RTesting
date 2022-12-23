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
            postOwnerProfile {''' +
        PostProfileSchema.schema +
        ''' }
         repostedPost {''' +
        RepostedPostSchema.schema +
        ''' }
              repostedPostId
              repostedPostOwnerId
              repostedPostOwnerProfile {''' +
        PostProfileSchema.schema +
        ''' }
            updated_at
            videoMediaItem
        ''';
  }
}

class RepostedPostSchema {
  RepostedPostSchema._();

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
            postOwnerProfile {''' +
        PostProfileSchema.schema +
        ''' }
              repostedPostId
              repostedPostOwnerId
              repostedPostOwnerProfile {''' +
        PostProfileSchema.schema +
        ''' }
            updated_at
            videoMediaItem
        ''';
  }
}

// repostedPost {''' +
//         PostSchema.schema +
//         ''' }

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
            created_at
            post {
              ''' +
        PostSchema.schema +
        '''
            }
          savedPostId
          updated_at
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
            imageMediaItems
            audioMediaItem
            isLiked
            postOwnerProfile {
              ''' +
        CommentProfileSchema.schema +
        '''
            }
            commentOwnerProfile {
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
              feedOwnerProfile {''' +
        PostProfileSchema.schema +
        ''' }
              post {''' +
        PostSchema.schema +
        ''' }
              reachingRelationship
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
        CommentProfileSchema.schema +
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
