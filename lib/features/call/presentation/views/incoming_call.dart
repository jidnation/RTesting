import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/call/presentation/bloc/call_bloc.dart';
import 'package:reach_me/features/call/presentation/views/receive_audio_call.dart';
import 'package:reach_me/features/call/presentation/views/receive_video_call.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../account/presentation/widgets/image_placeholder.dart';

class IncomingCall extends StatelessWidget {
  const IncomingCall(
      {super.key,
      required this.channelName,
      required this.user,
      required this.token,
      required this.callType});

  final String token, channelName, user, callType;

  stopRingtone() async {
    FlutterRingtonePlayer.playRingtone();
    await Future.delayed(const Duration(seconds: 30));
    FlutterRingtonePlayer.stop();
    OneSignal.shared.clearOneSignalNotifications();
    Get.back();
  }

  acceptCall() {
    globals.callBloc!.add(AnswerPrivateCall(channelName: channelName));
    Get.to(
      () => callType == 'audio'
          ? ReceiveAudioCall(channelName: channelName, token: token, user: user)
          : ReceiveVideoCall(channelName: channelName, token: token),
    );
  }

  rejectCall() {
    globals.callBloc!.add(RejectPrivateCall(channelName: channelName));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    stopRingtone();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/incoming_call.png',
            fit: BoxFit.fill,
            height: size.height,
            width: size.width,
          ),
          Positioned(
            top: 100,
            left: 1,
            right: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImagePlaceholder(
                  width: getScreenWidth(100),
                  height: getScreenHeight(100),
                ),
                Text(
                  user,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Incoming $callType call',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () => rejectCall(),
                  backgroundColor: const Color(0xffE91C43),
                  child: SvgPicture.asset(
                    'assets/svgs/call.svg',
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => acceptCall(),
                  backgroundColor: const Color(0xff24FE00),
                  child: SvgPicture.asset(
                    'assets/svgs/call.svg',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            left: 1,
            right: 1,
            bottom: 40,
          ),
        ],
      ),
    );
  }
}
