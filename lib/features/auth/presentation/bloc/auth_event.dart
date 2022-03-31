part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  RegisterUserEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });
}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}

class EmailVerificationEvent extends AuthEvent {
  final String? email;
  final int pin;
  EmailVerificationEvent({required this.email, required this.pin});
}

class RequestPasswordResetEvent extends AuthEvent {
  final String email;
  RequestPasswordResetEvent({required this.email});
}

class VerifyPasswordResetPinEvent extends AuthEvent {
  final String? email;
  final int? pin;
  VerifyPasswordResetPinEvent({required this.email, required this.pin});
}

class ResetPasswordEvent extends AuthEvent {
  final String? token;
  final String? password;
  ResetPasswordEvent({required this.token, required this.password});
}

class ResendOTPTokenEvent extends AuthEvent {}

class BiometricAuthEvent extends AuthEvent {}

class SetPinEvent extends AuthEvent {}

class UpdatePinEvent extends AuthEvent {}

class VerifyPinEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
