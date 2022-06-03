part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetUserProfileEvent extends UserEvent {
  final String? email;
  GetUserProfileEvent({required this.email});
}

class GetRecipientProfileEvent extends UserEvent {
  final String? email;
  GetRecipientProfileEvent({required this.email});
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

class FetchAllUsersByNameEvent extends UserEvent {
  final String? query;
  final int? limit, pageNumber;
  FetchAllUsersByNameEvent({
    required this.limit,
    required this.pageNumber,
    required this.query,
  });
}

class ReachUserEvent extends UserEvent {
  final String? userIdToReach;
  ReachUserEvent({required this.userIdToReach});
}

class StarUserEvent extends UserEvent {
  final String? userIdToStar;
  StarUserEvent({required this.userIdToStar});
}

class GetReachRelationshipEvent extends UserEvent {
  final String? userIdToReach;
  GetReachRelationshipEvent({required this.userIdToReach});
}

class DelReachRelationshipEvent extends UserEvent {
  final String? userIdToDelete;
  DelReachRelationshipEvent({required this.userIdToDelete});
}

class GetStarRelationshipEvent extends UserEvent {
  final String? userIdToStar;
  GetStarRelationshipEvent({required this.userIdToStar});
}

class DelStarRelationshipEvent extends UserEvent {
  final String? starIdToDelete;
  DelStarRelationshipEvent({required this.starIdToDelete});
}

class FetchUserReachersEvent extends UserEvent {}

class FetchUserReachingsEvent extends UserEvent {}

class FetchUserStarredEvent extends UserEvent {}
