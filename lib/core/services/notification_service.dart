import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:reach_me/features/video-call/presentation/views/incoming_video_call.dart';

import '../helper/logger.dart';

class NotifcationService {
  static handleNotifications() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
      Console.log('additional data', event.notification.additionalData);
      if (event.notification.additionalData!['notificationType'] == 'call') {
        Console.log('additional data', 'call');
        FlutterRingtonePlayer.playRingtone();
        Get.to(() => const IncomingVideoCall());
      }
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
