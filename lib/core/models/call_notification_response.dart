import 'package:reach_me/features/video-call/presentation/bloc/video_call_bloc.dart';

class CallNotificationResponse {
  final CallType callType;
  final CallMode callMode;
  final String callerFirstName;
  final String token;
  final String channelName;

  const CallNotificationResponse({
    required this.callMode,
    required this.callType,
    required this.callerFirstName,
    required this.channelName,
    required this.token,
  });

  factory CallNotificationResponse.fromJson(Map<String, dynamic> json) =>
      CallNotificationResponse(
        callMode: json['callMode'],
        callType: json['callType'],
        callerFirstName: json['callerFirstName'],
        channelName: json['channelName'],
        token: json['token'],
      );
}
