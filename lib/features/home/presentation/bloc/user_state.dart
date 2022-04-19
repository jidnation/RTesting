part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserUploadingImage extends UserState {}

class UserUploadProfilePictureSuccess extends UserState {
  UserUploadProfilePictureSuccess({this.user});
  final User? user;
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
