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

class LoginUserEvent extends AuthEvent {}

class EmailVerificationEvent extends AuthEvent {}

class RequestPasswordResetEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {}

class ResendOTPTokenEvent extends AuthEvent {}

class BiometricAuthEvent extends AuthEvent {}

class SetPinEvent extends AuthEvent {}

class UpdatePinEvent extends AuthEvent {}

class VerifyPinEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
