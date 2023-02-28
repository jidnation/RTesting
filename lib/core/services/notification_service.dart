import 'package:get/route_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:reach_me/features/call/presentation/views/incoming_call.dart';
// import 'package:reach_me/features/home/presentation/views/status/widgets/host_post.dart';

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
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      switch (result.notification.additionalData!['type']) {
        case 'call.initiated':
          openCallNotification(result);
          break;
        case 'stream.initiated':
          handleStreamNotification(result);
          break;
        default:
      }
    });
    OneSignal.shared
        .setPermissionObserver((OSPermissionStateChanges changes) {});
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {});
    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {});
  }
}

handleCallNotification(OSNotificationReceivedEvent event) {
  Console.log('params',
      event.notification.additionalData!['body']['callerProfile']['firstName']);
  Console.log(
      'params',
      event.notification.additionalData!['body']['callerProfile']
          ['profilePicture']);
  Get.to(() => IncomingCall(
        user: event.notification.additionalData!['body']['callerProfile']
            ['firstName'],
        token: event.notification.additionalData!['body']['receiverToken'],
        channelName: event.notification.additionalData!['body']['channelName'],
        callType: event.notification.additionalData!['body']['callMode'],
        firstName: event.notification.additionalData!['body']['callerProfile']
            ['firstName'],
        profilePicture: event.notification.additionalData!['body']
            ['callerProfile']['profilePicture'],
      ));
}

openCallNotification(OSNotificationOpenedResult result) {
  Get.to(() => IncomingCall(
        user: result.notification.additionalData!['body']['callerProfile']
            ['firstName'],
        token: result.notification.additionalData!['body']['receiverToken'],
        channelName: result.notification.additionalData!['body']['channelName'],
        callType: result.notification.additionalData!['body']['callMode'],
        firstName: result.notification.additionalData!['body']['firstName'],
        profilePicture: result.notification.additionalData!['body']
            ['profilePicture'],
      ));
}

handleStreamNotification(OSNotificationOpenedResult result) {
  Console.log("important", result.notification.body.toString());
  Console.log('important', result.notification.additionalData);

  // Get.to(() => HostPost(
  //       isHost: false,
  //       channelName: result.notification.additionalData!['body']['channelName'],
  //       token: result.notification.additionalData!['body']['audienceToken'],
  //       audienceId: result.notification.additionalData!['body']['audienceId'],
  //     ));
}
