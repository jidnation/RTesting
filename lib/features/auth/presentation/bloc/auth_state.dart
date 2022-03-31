part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  AuthLoaded({this.message});
  final String? message;
}

class AuthEmailVerified extends AuthState {
  AuthEmailVerified({this.message});
  final String? message;
}

class AuthRegisterLoaded extends AuthState {
  AuthRegisterLoaded();
}

class AuthSendResetPasswordEmail extends AuthState {
  AuthSendResetPasswordEmail({this.message});
  final String? message;
}

class VerifyResetPinSuccess extends AuthState {
  VerifyResetPinSuccess({this.token});
  final String? token;
}

class AuthResetPasswordLoaded extends AuthState {
  AuthResetPasswordLoaded({this.message});
  final String? message;
}

class AuthResendOTPLoaded extends AuthState {
  AuthResendOTPLoaded({this.message});
  final String? message;
}

class PinChanged extends AuthState {
  PinChanged({this.message});
  final String? message;
}

class PinVerified extends AuthState {
  PinVerified({this.message});
  final String? message;
}

class PinInvalid extends AuthState {
  PinInvalid({this.error});
  final String? error;
}

class AuthError extends AuthState {
  AuthError({this.error});
  final String? error;
}

class Authenticated extends AuthState {
  Authenticated({this.message});
  final String? message;
}

class Unathenticated extends AuthState {}
