import 'package:get/route_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:reach_me/features/video-call/presentation/views/incoming_video_call.dart';

import '../helper/logger.dart';

class NotifcationService {
  static handleNotifications() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      Console.log('additional data', event.notification.additionalData);
      if (event.notification.additionalData!['type'] == 'call.initiated') {
        Console.log(
            'additional data',
            event.notification.additionalData!['body']['callerProfile']
                ['firstName']);
        Console.log(
            'additional data',
            event.notification.additionalData!['body']
                ['receiverToken']);
        Console.log(
            'additional data',
            event.notification.additionalData!['body']
                ['channelName']);
        Get.to(() => IncomingVideoCall(
              user: event.notification.additionalData!['body']['callerProfile']
                  ['firstName'],
              token: event.notification.additionalData!
                  ['receiverToken'],
              channelName: event.notification.additionalData!['body']
                  ['callerProfile']['channelName'],
            ));
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
