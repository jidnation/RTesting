part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserUploadingImage extends UserState {}

class UserUploadingCoverImage extends UserState {}

class UserUploadProfilePictureSuccess extends UserState {
  UserUploadProfilePictureSuccess({this.user});
  final User? user;
}

class DeleteAccountSuccess extends UserState {
  DeleteAccountSuccess({this.deleted});
  final bool? deleted;
}

class DeleteAccountError extends UserState {
  DeleteAccountError({this.error});
  final String? error;
}

class DeleteAccountLoading extends UserState {
  DeleteAccountLoading();
}

class UserUploadCoverPictureSuccess extends UserState {
  UserUploadCoverPictureSuccess({this.user});
  final User? user;
}

class UsernameChangeSuccess extends UserState {
  UsernameChangeSuccess({this.user});
  final User? user;
}

class UserUploadError extends UserState {
  UserUploadError({this.error});
  final String? error;
}

class UserLoaded extends UserState {
  UserLoaded({this.message});
  final String? message;
}

class UserData extends UserState {
  UserData({this.user});
  final User? user;
}

class RecipientUserData extends UserState {
  RecipientUserData({this.user});
  final User? user;
}

class FetchUsersSuccess extends UserState {
  FetchUsersSuccess({this.user});
  final List<User>? user;
}

class GetReachRelationshipSuccess extends UserState {
  GetReachRelationshipSuccess({this.isReaching});
  final bool? isReaching;
}

class StarUserSuccess extends UserState {
  StarUserSuccess({this.star});
  final StarModel? star;
}

class DelReachRelationshipSuccess extends UserState {
  DelReachRelationshipSuccess({this.isReachingDel});
  final bool? isReachingDel;
}

class GetStarRelationshipSuccess extends UserState {
  GetStarRelationshipSuccess({this.isStarring});
  final bool? isStarring;
}

class DelStarRelationshipSuccess extends UserState {
  DelStarRelationshipSuccess({this.isStarringDel});
  final bool? isStarringDel;
}

class FetchUserReachersSuccess extends UserState {
  FetchUserReachersSuccess({this.reachers});
  final List<VirtualReach>? reachers;
}

class FetchUserReachingsSuccess extends UserState {
  FetchUserReachingsSuccess({this.reachings});
  final List<VirtualReach>? reachings;
}

class FetchUserStarredSuccess extends UserState {
  FetchUserStarredSuccess({this.starredUsers});
  final List<VirtualStar>? starredUsers;
}

class UserError extends UserState {
  UserError({this.error});
  final String? error;
}

class GetUserLocationLoading extends UserState {}

class GetUserLocationSuccess extends UserState {
  GetUserLocationSuccess({this.location});
  final String? location;
}

class GetUserLocationError extends UserState {
  GetUserLocationError({this.error});
  final String? error;
}

class UpdateUserLastSeenLoading extends UserState {}

class UpdateUserLastSeenSuccess extends UserState {
  UpdateUserLastSeenSuccess({this.isUpdated});
  final bool? isUpdated;
}

class UpdateUserLastSeenError extends UserState {
  UpdateUserLastSeenError({this.error});
  final String? error;
}

class BlockUserSuccess extends UserState {
  BlockUserSuccess({this.blockedUser});
  final Block? blockedUser;
}

class UnBlockUserSuccess extends UserState {
  UnBlockUserSuccess({this.unblockUser});
  final bool? unblockUser;
}

class GetBlockedListSuccess extends UserState {
  GetBlockedListSuccess({this.blockedList});
  final List<Block>? blockedList;
}
