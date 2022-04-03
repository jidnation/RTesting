part of 'user_bloc.dart';


@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserUploadingImage extends UserState {}

class UserLoaded extends UserState {
  UserLoaded({this.message});
  final String? message;
}

class UserData extends UserState {
  UserData({this.user});
  final User? user;
}

class UserError extends UserState {
  UserError({this.error});
  final String? error;
}

