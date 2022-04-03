// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/auth/data/models/user.dart';
import 'package:reach_me/features/home/data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository = UserRepository();
  UserBloc() : super(UserInitial()) {
    on<GetUserProfileEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getUserProfile(
          email: event.email!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (user) {
            globals.user = user;
            emit(UserData(user: user));
          },
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
  }
}
