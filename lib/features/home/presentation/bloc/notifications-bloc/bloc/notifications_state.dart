part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState{}

class GetNotificationsSuccess extends NotificationsState {
  final List<NotificationsModel> notifications;

  GetNotificationsSuccess({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class GetNotificationsLoading extends NotificationsState {}

class GetNotificationsError extends NotificationsState {
  final String error;
  GetNotificationsError({required this.error});
  @override
  List<Object> get props => [error];
}
