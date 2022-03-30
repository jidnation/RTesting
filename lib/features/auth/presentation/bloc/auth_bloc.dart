import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository? _authRepository = AuthRepository(); 
  AuthBloc() : super(AuthInitial()) {
    on<RegisterUserEvent>(((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _authRepository!.createAccount(
          email: event.email,
          firstName: event.firstName,
          lastName: event.lastName,
          password: event.password,
          phoneNumber: event.phoneNumber,
        );
        result.fold(
          (l) => emit(AuthError(error: l)),
          (r) => emit(AuthLoaded(message: r.id)),
        );
      } on GraphQLError catch (e) {
        emit(AuthError(error: e.message));
      }
    }));
  }
}
