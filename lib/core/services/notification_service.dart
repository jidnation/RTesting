import 'package:get/route_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:reach_me/features/call/presentation/views/incoming_call.dart';

import '../helper/logger.dart';

class NotifcationService {
  static handleNotifications() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      Console.log('additional data', event.notification.additionalData);
      switch (event.notification.additionalData!['type']) {
        case 'call.initiated':
          handleCallNotification(event);
          break; 
        default:
      }
      event.complete(event.notification);
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
    OneSignal.shared
        .setPermissionObserver((OSPermissionStateChanges changes) {});
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {});
    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {});
  }
}

handleCallNotification(OSNotificationReceivedEvent event) {
  Get.to(() => IncomingCall(
        user: event.notification.additionalData!['body']['callerProfile']
            ['firstName'],
        token: event.notification.additionalData!['body']['receiverToken'],
        channelName: event.notification.additionalData!['body']['channelName'],
        callType: event.notification.additionalData!['body']['callMode'],
      ));
}

