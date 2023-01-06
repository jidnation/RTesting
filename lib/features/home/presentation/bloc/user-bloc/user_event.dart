part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetUserProfileEvent extends UserEvent {
  final String email;
  GetUserProfileEvent({required this.email});
}

class DeleteAccountEvent extends UserEvent {
  DeleteAccountEvent();
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
  final File file;
  UploadUserProfilePictureEvent({required this.file});
}

class UploadUserCoverPhotoEvent extends UserEvent {
  final File file;
  UploadUserCoverPhotoEvent({required this.file});
}

class UpdateUserLastSeenEvent extends UserEvent {
  final String userId;
  UpdateUserLastSeenEvent({required this.userId});
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
  final String? type;
  GetReachRelationshipEvent({required this.userIdToReach, required this.type});
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

class FetchUserReachersEvent extends UserEvent {
  final int pageLimit, pageNumber;
  final String? authId;
  FetchUserReachersEvent({
    required this.pageLimit,
    required this.pageNumber,
    this.authId,
  });
}

class FetchUserReachingsEvent extends UserEvent {
  final int pageLimit, pageNumber;
  final String? authId;
  FetchUserReachingsEvent({
    required this.pageLimit,
    required this.pageNumber,
    this.authId,
  });
}

class FetchUserStarredEvent extends UserEvent {
  final int pageLimit, pageNumber;
  final String? authId;
  FetchUserStarredEvent({
    required this.pageLimit,
    required this.pageNumber,
    this.authId,
  });
}

class GetUserLocationEvent extends UserEvent {
  final String lat, lng;
  GetUserLocationEvent({required this.lat, required this.lng});
}

class BlockUserEvent extends UserEvent {
  final String idToBlock;
  BlockUserEvent({required this.idToBlock});
}

class UnBlockUserEvent extends UserEvent {
  final String idToUnblock;
  UnBlockUserEvent({required this.idToUnblock});
}

class GetBlockedListEvent extends UserEvent { 
  GetBlockedListEvent();
}

class InitiateLiveStreamEvent extends UserEvent {
  final String startedAt;

  InitiateLiveStreamEvent({required this.startedAt});
}

class JoinStreamEvent extends UserEvent {
  final String channelName;
  JoinStreamEvent({required this.channelName});
}
