// const createMoment = """
// mutation(\$authId: String, \$caption: String, \$momentId: String, \$hashTags: [String], \$created_at: DateTime,\$isLiked: Boolean,\$mentionList: [String], \$momentSlug: String,\$nComments: int, \$nLikes: int, \$sound: String, \$videoMediaItem: String) {
//     createUser (name: \$name, email: \$email, job_title: \$job_title)
//   }
// """;

const createMoment = r'''
mutation($caption: String!, $hashTags: [String], $mentionList: [String], $sound: String, $videoMediaItem: String!) {
    createMoment (momentBody: {caption : $caption, videoMediaItem: $videoMediaItem, sound: $sound, mentionList: $mentionList, hashTags: $hashTags}){
    authId
    }
  }
''';
