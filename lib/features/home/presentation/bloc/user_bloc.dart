// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/models/user.dart';
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
            Console.log('user data bloc', user.toJson());
            Console.log('user data globals bloc', globals.user!.toJson());
            emit(UserData(user: user));
          },
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<UpdateUserProfileEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.updateUserProfile(
          bio: event.bio,
          gender: event.gender,
          dateOfBirth: event.dateOfBirth,
          location: event.location,
          showContact: event.showContact,
          showLocation: event.showLocation,
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
    on<SetDOBEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.setDOB(
          dateOfBirth: event.dateOfBirth,
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
    on<SetUsernameEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.setUsername(
          username: event.username,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (user) {
            globals.user = user;
            emit(UsernameChangeSuccess(user: user));
          },
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<FetchAllUsersByNameEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getAllUsersByName(
          limit: event.limit!,
          pageNumber: event.pageNumber!,
          query: event.query!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (usersList) {
            globals.userList = usersList;
            emit(FetchUsersSuccess(user: usersList));
          },
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<UploadUserProfilePictureEvent>((event, emit) async {
      emit(UserUploadingImage());
      String imageUrl = '';
      try {
        //UPLOAD FILE & GET IMAGE URL
        final response = await userRepository.uploadPhoto(
          file: event.file,
        );
        response.fold(
          (error) => emit(UserUploadError(error: error)),
          (imgUrl) => imageUrl = imgUrl,
        );
        //SAVE TO
        final userRes = await userRepository.setImage(
          imageUrl: imageUrl,
          type: 'profilePicture',
        );
        userRes.fold(
          (error) => emit(UserUploadError(error: error)),
          (user) {
            globals.user = user;
            emit(UserUploadProfilePictureSuccess(user: user));
          },
        );
      } on GraphQLError catch (e) {
        emit(UserUploadError(error: e.message));
      }
    });
  }
}
