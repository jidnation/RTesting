part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetUserProfileEvent extends UserEvent {
  final String? email;
  GetUserProfileEvent({required this.email});
}

class UpdateUserProfileEvent extends UserEvent {
  final String? dateOfBirth;
  final String? bio;
  final String? gender;
  final String? location;
  final bool? showContact;
  final bool? showLocation;
  UpdateUserProfileEvent({
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.location,
    this.showContact,
    this.showLocation,
  });
}

class SetUsernameEvent extends UserEvent {
  final String username;

  SetUsernameEvent({required this.username});
}

class SetDOBEvent extends UserEvent {
  final String dateOfBirth;

  SetDOBEvent({required this.dateOfBirth});
}

class UploadUserProfilePictureEvent extends UserEvent {
  final XFile file;
  UploadUserProfilePictureEvent({required this.file});
}

class UploadUserCoverPhotoEvent extends UserEvent {
  final XFile file;
  UploadUserCoverPhotoEvent({required this.file});
}
