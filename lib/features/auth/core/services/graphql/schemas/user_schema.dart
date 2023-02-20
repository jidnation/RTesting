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
            lastSeen
            authId
            username
            nReachers
            nReaching
            nStaring
            nBlocked
            verified
            email
            firstName
            lastName
            reaching {
              reacherId
              reachingId
            }
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

class MiniProfileSchema {
  MiniProfileSchema._();

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
            bio
        ''';
  }
}
