

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
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
    on<GetRecipientProfileEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getUserProfile(
          email: event.email!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (user) {
            // globals.recipientUser = user;
            emit(RecipientUserData(user: user));
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
    on<ReachUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.reachUser(
          userId: event.userIdToReach!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (usersList) => emit(UserLoaded()),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<StarUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.starUser(
          userId: event.userIdToStar!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (usersList) => emit(UserLoaded()),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<GetReachRelationshipEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getReachRelationship(
          userId: event.userIdToReach!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (isReaching) =>
              emit(GetReachRelationshipSuccess(isReaching: isReaching)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<DelReachRelationshipEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.deleteReachRelationship(
          userId: event.userIdToDelete!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (isReachingDel) =>
              emit(DelReachRelationshipSuccess(isReachingDel: isReachingDel)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<GetStarRelationshipEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getStarRelationship(
          userId: event.userIdToStar!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (isStarring) =>
              emit(GetStarRelationshipSuccess(isStarring: isStarring)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<DelStarRelationshipEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.deleteStarRelationship(
          userId: event.starIdToDelete!,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (isStarringDel) =>
              emit(DelStarRelationshipSuccess(isStarringDel: isStarringDel)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<FetchUserReachersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getReachers();
        response.fold(
          (error) => emit(UserError(error: error)),
          (reachers) => emit(FetchUserReachersSuccess(reachers: reachers)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<FetchUserReachingsEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getReachings();
        response.fold(
          (error) => emit(UserError(error: error)),
          (reachings) => emit(FetchUserReachingsSuccess(reachings: reachings)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<FetchUserStarredEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getStarred();
        response.fold(
          (error) => emit(UserError(error: error)),
          (starredUsers) =>
              emit(FetchUserStarredSuccess(starredUsers: starredUsers)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
  }
}
