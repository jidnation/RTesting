class UserSchema {
  UserSchema._();

  static String get schema {
    return r'''
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

class ReacherProfileSchema {
  ReacherProfileSchema._();

  static String get schema {
    return r'''
            profilePicture
            profileSlug
            location
            authId
            username
            firstName
            lastName
        ''';
  }
}

class ProfileIndexSchema {
  ProfileIndexSchema._();

  static String get schema {
    return r'''
            authId
            firstName
            lastName
            profilePicture
            profileSlug
            username
            verified
        ''';
  }
}
