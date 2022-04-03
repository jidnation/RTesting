part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetUserProfileEvent extends UserEvent {
  final String? email;
  GetUserProfileEvent({required this.email});
}

class UploadUserProfilePictureEvent extends UserEvent {}
