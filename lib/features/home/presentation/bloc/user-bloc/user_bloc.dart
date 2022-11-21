import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/home/data/models/star_model.dart';
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
          email: event.email,
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
    on<DeleteAccountEvent>((event, emit) async {
      emit(DeleteAccountLoading());
      try {
        final response = await userRepository.deleteAccount();
        response.fold(
          (error) => emit(DeleteAccountError(error: error)),
          (deleted) {
            emit(DeleteAccountSuccess(deleted: deleted));
          },
        );
      } on GraphQLError catch (e) {
        emit(DeleteAccountError(error: e.message));
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
            //globals.userList = usersList;
            emit(FetchUsersSuccess(user: usersList));
          },
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    // on<UploadUserProfilePictureEvent>((event, emit) async {
    //   emit(UserUploadingImage());
    //   String imageUrl = '';
    //   try {
    //     //UPLOAD FILE & GET IMAGE URL
    //     final response = await userRepository.uploadPhoto(
    //       file: event.file,
    //     );

    //     response.fold(
    //       (error) => emit(UserUploadError(error: error)),
    //       (imgUrl) => imageUrl = imgUrl,
    //     );
    //     //SAVE TO

    //     if (imageUrl.isNotEmpty) {
    //       final userRes = await userRepository.setImage(
    //         imageUrl: imageUrl,
    //         type: 'profilePicture',
    //       );

    //       userRes.fold(
    //         (error) => emit(UserUploadError(error: error)),
    //         (user) {
    //           globals.user = user;
    //           emit(UserUploadProfilePictureSuccess(user: user));
    //         },
    //       );
    //     }
    //   } on GraphQLError catch (e) {
    //     emit(UserUploadError(error: e.message));
    //   }
    // });
    on<UploadUserCoverPhotoEvent>((event, emit) async {
      emit(UserUploadingCoverImage());
      String imageUrl = '';
      String signedUrl = '';
      try {
        //GET SIGNED URL
        final response = await userRepository.getSignedURl(file: event.file);

        response.fold(
          (error) => emit(UserUploadError(error: error)),
          (data) {
            signedUrl = data['signedUrl'];
            imageUrl = data['imageUrl'];
          },
        );

        //UPLOAD FILE & GET IMAGE URL
        if (signedUrl.isNotEmpty) {
          final uploadRes = await userRepository.uploadPhoto(
            url: signedUrl,
            file: event.file,
          );

          uploadRes.fold(
            (error) => emit(UserUploadError(error: error)),
            (user) {},
          );

          final userRes = await userRepository.setImage(
            imageUrl: imageUrl,
            type: 'coverPicture',
          );

          userRes.fold(
            (error) => emit(UserUploadError(error: error)),
            (user) {
              globals.user = user;
              emit(UserUploadCoverPictureSuccess(user: user));
            },
          );
        }
      } on GraphQLError catch (e) {
        emit(UserUploadError(error: e.message));
      }
    });

    on<UploadUserProfilePictureEvent>((event, emit) async {
      emit(UserUploadingImage());
      String imageUrl = '';
      String signedUrl = '';
      try {
        //GET SIGNED URL
        final response = await userRepository.getSignedURl(file: event.file);

        response.fold(
          (error) => emit(UserUploadError(error: error)),
          (data) {
            signedUrl = data['signedUrl'];
            imageUrl = data['imageUrl'];
          },
        );

        //UPLOAD FILE & GET IMAGE URL
        if (signedUrl.isNotEmpty) {
          final uploadRes = await userRepository.uploadPhoto(
            url: signedUrl,
            file: event.file,
          );

          uploadRes.fold(
            (error) => emit(UserUploadError(error: error)),
            (user) {},
          );

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
        }
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
          (star) => emit(StarUserSuccess(star: star)),
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
          type: event.type!,
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
        final response = await userRepository.getReachers(
          pageLimit: event.pageLimit,
          pageNumber: event.pageNumber,
          authId: event.authId,
        );
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
        final response = await userRepository.getReachings(
          pageLimit: event.pageLimit,
          pageNumber: event.pageNumber,
          authId: event.authId,
        );
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
        final response = await userRepository.getStarred(
          pageLimit: event.pageLimit,
          pageNumber: event.pageNumber,
          authId: event.authId,
        );
        response.fold(
          (error) => emit(UserError(error: error)),
          (starredUsers) =>
              emit(FetchUserStarredSuccess(starredUsers: starredUsers)),
        );
      } on GraphQLError catch (e) {
        emit(UserError(error: e.message));
      }
    });
    on<GetUserLocationEvent>((event, emit) async {
      emit(GetUserLocationLoading());
      try {
        final response = await userRepository.reverseGeocode(
          lat: event.lat,
          lng: event.lng,
        );
        response.fold(
          (error) => emit(GetUserLocationError(error: error)),
          (data) {
            globals.location = data;
            emit(GetUserLocationSuccess(location: data));
          },
        );
      } on GraphQLError catch (e) {
        emit(GetUserLocationError(error: e.message));
      }
    });
    on<UpdateUserLastSeenEvent>((event, emit) async {
      emit(UpdateUserLastSeenLoading());
      try {
        final response = await userRepository.updateLastSeen(
          userId: event.userId,
        );
        response.fold(
          (error) => emit(UpdateUserLastSeenError(error: error)),
          (isUpdated) => emit(UpdateUserLastSeenSuccess(isUpdated: isUpdated)),
        );
      } on GraphQLError catch (e) {
        emit(UpdateUserLastSeenError(error: e.message));
      }
    });
  }
}
