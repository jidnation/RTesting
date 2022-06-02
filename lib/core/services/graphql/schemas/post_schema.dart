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
            imageMediaItems
            location
            mentionList
            nComments
            nDownvotes
            nLikes
            nShares
            nUpvotes
            postId
            postSlug
            videoMediaItem
          
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
            nComments
            nLikes
            postId
        ''';
  }
}
