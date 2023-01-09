import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../account/presentation/widgets/image_placeholder.dart';
import '../bloc/call_bloc.dart';
import 'initiate_video_call.dart';

class ReceiveAudioCall extends StatefulWidget {
  const ReceiveAudioCall({
    super.key,
    required this.channelName,
    required this.token,
    required this.user,
  });

  final String channelName, token, user;

  @override
  State<ReceiveAudioCall> createState() => _ReceiveAudioCallState();
}

class _ReceiveAudioCallState extends State<ReceiveAudioCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  int? _localuid;
  bool muteMic = false;
  late RtcEngine _engine;
  final StopWatchTimer stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countUp);

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: '5741afe670ba4684aec914fb19eeb82a',
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onConnectionStateChanged: (connection, state, reason) {
          showCallAlerts(reason);
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          stopWatchTimer.onStartTimer();
          setState(() {
            _localUserJoined = true;
            _localuid = connection.localUid;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");

          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
          endCall();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          Console.log(
            '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}',
            ' token: $token',
          );
        },
      ),
    );
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();
    await join();
    globals.callBloc!.add(
      AnswerPrivateCall(channelName: widget.channelName),
    );
  }

  join() async {
    Console.log('call joined status', 'joining');
    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      options: const ChannelMediaOptions(),
      uid: 1,
    );
    setState(() {
      _localUserJoined = true;
    });
    Console.log('call joined status', _localUserJoined);
  }

  endCall() {
    Navigator.pop(context);
    Fluttertoast.showToast(msg: 'call ended');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
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
                    widget.user,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ongoing call',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: size.width,
                      height: 100,
                      color: const Color(0xff000000),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 26,
                          height: 26,
                        ),
                        FloatingActionButton(
                          onPressed: () => endCall(),
                          backgroundColor: const Color(0xffE91C43),
                          child: SvgPicture.asset(
                            'assets/svgs/call.svg',
                            color: AppColors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
                              const Opacity(
                                opacity: 0.5,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xff000000),
                                  radius: 23,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                right: 10,
                                bottom: 10,
                                child: SvgPicture.asset(
                                  'assets/svgs/mic.svg',
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
