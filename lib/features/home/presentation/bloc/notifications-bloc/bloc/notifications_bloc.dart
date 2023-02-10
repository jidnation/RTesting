import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/logger.dart';
import '../../../../data/models/notifications.dart';
import '../../../../data/repositories/social_service_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final socialServiceRepository = SocialServiceRepository();

  NotificationsBloc() : super(NotificationsInitial()){
 on<GetNotificationsEvent>((event, emit) async {
      emit(GetNotificationsLoading());
      final response = await socialServiceRepository.getNotifications();
      Console.log('notifications response', response);
      response.fold((l) => emit(GetNotificationsError(error: l)),
          (r) => emit(GetNotificationsSuccess(notifications: r)));
    });

  }

  
}
