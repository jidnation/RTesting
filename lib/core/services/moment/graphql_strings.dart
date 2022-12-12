const createMoment = r'''
mutation($caption: String!, $hashTags: [String], $mentionList: [String], $sound: String, $videoMediaItem: String!) {
    createMoment (momentBody: {caption : $caption, videoMediaItem: $videoMediaItem, sound: $sound, mentionList: $mentionList, hashTags: $hashTags}){
    authId
    }
  }
''';
