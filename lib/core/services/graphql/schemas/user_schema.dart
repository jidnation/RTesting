class UserSchema {
  UserSchema._();

  static String get schema {
    return r'''
            _id
            bio
            dateOfBirth
            coverPicture
            gender
            location
            phone
            profilePicture
            profileSlug
            showContact
            showLocation
            authId
            username
            nReachers
            nReaching
            nStaring
            verified
            email
            firstName
            lastName
        ''';
  }
}
