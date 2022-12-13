import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../helper/logger.dart';

class NotifcationService {
  static handleNotifications() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
         Console.log('additional data', event.notification.additionalData);
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
             Console.log('additional data', result.notification.additionalData);
        });
    OneSignal.shared
        .setPermissionObserver((OSPermissionStateChanges changes) {});
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {});
    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {});
  }
}
