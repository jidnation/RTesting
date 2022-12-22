//used
const createMoment = r'''
mutation($caption: String!, $hashTags: [String], $mentionList: [String], $sound: String, $videoMediaItem: String!) {
    createMoment (momentBody: {caption : $caption, videoMediaItem: $videoMediaItem, sound: $sound, mentionList: $mentionList, hashTags: $hashTags}){
    authId
    }
  }
''';

const deleteMoment = r'''
mutation($momentId: String!) {
    deleteMoment (momentId: $momentId){
    authId
    }
  }
''';

const deleteMomentComment = r'''
mutation($commentId: String!) {
    deleteMomentComment (commentId: $commentId)
  }
''';

const deleteMomentCommentReply = r'''
mutation($momentId: String!, $replyId: String!) {
    deleteMomentCommentReply(momentId: $momentId, replyId: $replyId)
  }
''';

const likeMoment = r'''
mutation($momentId: String!) {
    likeMoment (momentId: $momentId){
    authId
  }
  }
''';

const likeMomentReply = r'''
mutation($momentId: String!, $commentId: String!, $replyId: String!) {
    likeMomentReply(momentId: $momentId, commentId: $commentId, replyId: $replyId){
    authId
  }
''';

const likeMomentComment = r'''
mutation($momentId: String!, $commentId: String!) {
    likeMomentComment (momentId: $momentId, commentId: $commentId){
    authId
  }
  }
''';

const unlikeMomentComment = r'''
mutation($momentId: String!, $likeId: String!) {
    unlikeMomentComment (momentId: $momentId, likeId: $likeId)
''';

const unlikeMomentReply = r'''
mutation($replyId: String!, $likeId: String!) {
    unlikeMomentComment (replyId: $replyId, likeId: $likeId)
''';

const unlikeMoment = r'''
mutation($momentId: String!) {
    unlikeMoment (momentId: $momentId)
    }
''';

const editMomentContent = r'''
mutation($momentId: String!, $caption: String!, $sound: String, $hashTags: [String], $mentionList: [String]) {
    editMomentContent(momentId: $momentId, contentInput: {caption : $caption, sound: $sound, mentionList: $mentionList, hashTags: $hashTags}){
    authId
    }
  }
''';

const replyMomentComment = r'''
mutation($momentId: String!, $commentId: String!, $content: String!) {
    replyMomentComment(momentId: $momentId, content: $content, content: $commentId){
    authId
    }
  }
''';
// {content : $content, audioMediaItem: $sound, momentOwnerId: $momentOwnerId, imageMediaItems: $imageList, videoMediaItem: $videoUrl}
// mutation($momentId: String!, $content: String,$momentOwnerId: String, $sound: String, $videoUrl: String, $imageList: [String]) {
const createMomentComment = r'''
mutation($commentBody: MomentCommentInputDto!) {
    createMomentComment(commentBody: $commentBody){
    authId
    }
  }
''';

const reachUser = r'''
  mutation($userIdToReach: String!){
    reachUser(userIdToReach: $userIdToReach){
    isReaching
  }  
''';

//used
const String getMomentFeed = r''' 
query ($pageLimit: Int!, $pageNumber: Int!, $authIdToGet: String) {
  getMomentFeed(page_limit: $pageLimit, page_number: $pageNumber, authIdToGet : $authIdToGet){
created_at,
    updated_at,
    feedOwnerProfile{
    bio,
      authId,
      firstName,
      lastName,
      location,
      username,
      profilePicture,
      profileSlug
    },
   moment
    {
    momentId,
    caption,
    authId,
      mentionList,
      hashTags,
      created_at,
      
    isLiked,
      nLikes,
      nComments,
      momentSlug,
      sound,
    videoMediaItem,
      momentOwnerProfile{
        authId,
        bio,
        firstName,
        lastName,
        location,
        profileSlug,
        profilePicture,
        username
      }
  },
    reachingRelationship
  
    }
  }
''';

const String getAllMoment = r''' 
query ($pageLimit: Int!, $pageNumber: Int!, $authIdToGet: String) {
  getAllMoment(page_limit: $pageLimit, page_number: $pageNumber, authIdToGet : $authIdToGet){
    momentId,
    caption,
    authId,
      mentionList,
      hashTags,
      created_at,
    isLiked,
      nLikes,
      nComments,
      momentSlug,
      sound,
    videoMediaItem,
      momentOwnerProfile{
        authId,
        bio,
        firstName,
        lastName,
        location,
        profileSlug,
        profilePicture,
        username
      }
  }
  }
''';

const String getMoment = r''' 
query ($momentId: String!) {
  getMoment(momentId: $momentId){
    momentId,
    caption,
    authId,
    mentionList,
    hashTags,
    created_at,
    isLiked,
    nLikes,
    nComments,
    momentSlug,
    sound,
    videoMediaItem,
      momentOwnerProfile{
        authId,
        bio,
        firstName,
        lastName,
        location,
        profileSlug,
        profilePicture,
        username
      }  
    }
  }
''';

const String getMomentLikes = r''' 
query ($momentId: String!) {
  getMomentLikes(momentId: $momentId){
       authId,
    created_at,
    momentId,
    profile{
      authId,
      firstName,
      lastName,
      username,
      bio,
      verified,
      location,
      profileSlug,
      profilePicture
    }
    }
  }
''';

const String getMomentComments = r''' 
query ($momentId: String!, $pageNumber: Int!, $pageLimit: Int!) {
  getMomentComments(momentId: $momentId, page_limit: $pageLimit, page_number: $pageNumber){
     content,
    commentId,
    created_at,
    commentSlug,
    imageMediaItems,
    videoMediaItem,
    audioMediaItem,
    nLikes,
    nComments,
    isLiked,
    commentOwnerProfile{
      username,
      firstName,
      lastName,
      location,
      profilePicture
    },
    postOwnerProfile{
      authId,
      firstName,lastName,username,profilePicture, location
    }
    }
  }
''';

const String getLikedMoment = r''' 
query ($authIdToGet: String, $pageNumber: Int!, $pageLimit: Int!) {
  getMomentComments(authIdToGet: $authIdToGet, page_limit: $pageLimit, page_number: $pageNumber){
     content,
    commentId,
    created_at,
    commentSlug,
    imageMediaItems,
    videoMediaItem,
    audioMediaItem,
    nLikes,
    nComments,
    isLiked,
    momentOwnerProfile{
      authId,
      firstName,lastName,username,profilePicture
    }
    }
  }
''';

const String getMomentCommentReplies = r''' 
query ($momentId: String!,$commentId: String!, $pageNumber: Int!, $pageLimit: Int!) {
  getMomentComments(momentId: $momentId,commentId: $commentId, page_limit: $pageLimit, page_number: $pageNumber){
     authId,
    commentId,
    replyId,
    momentId,
    profile{
      username,
      firstName,
      lastName,
      profilePicture
    }
    }
  }
''';

const String getMomentComment = r''' 
query ($commentId: String!) {
  getMomentComment(commentId: $commentId){
     content,
    commentId,
    created_at,
    commentSlug,
    imageMediaItems,
    videoMediaItem,
    audioMediaItem,
    nLikes,
    nComments,
    isLiked,
    commentOwnerProfile{
      username,
      firstName,
      lastName,
      profilePicture
    },
    postOwnerProfile{
      authId,
      firstName,lastName,username,profilePicture
    }
    }
  }
''';

const String getMomentCommentLikes = r''' 
query ($commentId: String!) {
  getMomentCommentLikes(commentId: $commentId){
    commentId,
    momentId,
    created_at,
    likeId,
    profile{
      username,
      firstName,
      lastName,
      profilePicture
    },
    postOwnerProfile{
      authId,
      firstName,lastName,username,profilePicture
    }
    }
  }
''';

const String getMomentReplyLikes = r''' 
query ($replyId: String!) {
  getMomentCommentLikes(commentId: $commentId){
    commentId,
    replyId,
    momentId,
    created_at,
    likeId,
    profile{
      username,
      firstName,
      lastName,
      profilePicture
    },
    }
  }
''';

///
/// 23 in total
/// 4 used
///
