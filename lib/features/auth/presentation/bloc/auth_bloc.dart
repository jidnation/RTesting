import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository? _authRepository = AuthRepository();
  AuthBloc() : super(AuthInitial()) {
    on<RegisterUserEvent>(((event, emit) async {
      emit(AuthLoading());
      try {
        print(event.phoneNumber);
        final result = await _authRepository!.createAccount(
          email: event.email,
          firstName: event.firstName,
          lastName: event.lastName,
          password: event.password,
          phoneNumber: event.phoneNumber,
        );
        result.fold(
          (error) => emit(AuthError(error: error)),
          (user) => emit(AuthRegisterLoaded()),
        );
      } on GraphQLError catch (e) {
        emit(AuthError(error: e.message));
      }
    }));
    on<EmailVerificationEvent>(((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _authRepository!
            .verifyAccount(email: event.email, pin: event.pin);
        result.fold(
          (error) => emit(PinInvalid(error: error)),
          (success) => emit(AuthEmailVerified(
              message: 'Your account has been verified successfully')),
        );
      } on GraphQLError catch (e) {
        emit(PinInvalid(error: e.message));
      }
    }));
    on<LoginUserEvent>(((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _authRepository!
            .login(email: event.email, password: event.password);
        result.fold(
          (error) => emit(AuthError(error: error)),
          (user) {
            globals.user = user;
            globals.token = user.token;
            emit(Authenticated(message: 'User logged in successfully'));
          },
        );
      } on GraphQLError catch (e) {
        emit(AuthError(error: e.message));
      }
    }));
    on<RequestPasswordResetEvent>(((event, emit) async {
      emit(AuthLoading());
      try {
        final result =
            await _authRepository!.initiatePasswordReset(email: event.email);
        result.fold(
          (error) => emit(AuthError(error: error)),
          (value) {
            if (!value) {
              emit(AuthError(error: 'No user found with this email'));
            } else {
              emit(AuthSendResetPasswordEmail(
                  message: 'Password reset link sent to your email'));
            }
          },
        );
      } on GraphQLError catch (e) {
        emit(AuthError(error: e.message));
      }
    }));
    on<VerifyPasswordResetPinEvent>(((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _authRepository!
            .verifyPasswordResetPin(email: event.email, pin: event.pin);
        result.fold(
          (error) => emit(PinInvalid(error: error)),
          (token) => emit(VerifyResetPinSuccess(token: token)),
        );
      } on GraphQLError catch (e) {
        emit(PinInvalid(error: e.message));
      }
    }));
    on<ResetPasswordEvent>(((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _authRepository!.resetPasswordWithToken(
          password: event.password,
          token: event.token,
        );

        result.fold(
          (error) => emit(AuthError(error: error)),
          (value) {
            if (!value) {
              emit(
                AuthError(error: 'An error occured while resetting password'),
              );
            } else {
              emit(AuthLoaded(
                  message:
                      'Your password has been reset successfully, please login.'));
            }
          },
        );
      } on GraphQLError catch (e) {
        emit(AuthError(error: e.message));
      }
    }));
  }
}
