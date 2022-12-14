const createMoment = r'''
mutation($caption: String!, $hashTags: [String], $mentionList: [String], $sound: String, $videoMediaItem: String!) {
    createMoment (momentBody: {caption : $caption, videoMediaItem: $videoMediaItem, sound: $sound, mentionList: $mentionList, hashTags: $hashTags}){
    authId
    }
  }
''';

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
