import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/components/profile_picture.dart';
import '../../../../core/models/user.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../account/presentation/widgets/image_placeholder.dart';
import '../bloc/call_bloc.dart';

const appId = "5741afe670ba4684aec914fb19eeb82a";

enum AudioCallState {
  connecting('connecting'),
  calling('calling'),
  ongoing('ongoing call'),
  failed('failed'),
  disconnected('disconnected');

  final String message;
  const AudioCallState(this.message);
}

class InitiateAudioCall extends StatefulWidget {
  const InitiateAudioCall({super.key, this.recipient});

  final User? recipient;

  @override
  State<InitiateAudioCall> createState() => _InitiateAudioCallState();
}

class _InitiateAudioCallState extends State<InitiateAudioCall> {
  int uid = 0;
  bool isRinging = true;
  bool muteMic = false;
  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;
  final StopWatchTimer stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countUp);
  AudioCallState callState = AudioCallState.connecting;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    setupVoiceSDKEngine();
    playRingingSound();
    dropCallIfNotPickedUp();
    super.initState();
  }

  @override
  void dispose() {
    agoraEngine.disableAudio();
    agoraEngine.disableVideo();
    agoraEngine.leaveChannel();
    agoraEngine.release();
    stopWatchTimer.dispose();
    stopRingingSound();
    super.dispose();
  }

  playRingingSound() async {
    assetsAudioPlayer.open(
      Audio("assets/sounds/calling_sound.mp3"),
      autoStart: true,
      showNotification: false,
    );
  }

  dropCallIfNotPickedUp() async {
    await Future.delayed(const Duration(seconds: 30));
    if (isRinging) {
      Navigator.pop(context);
      callState = AudioCallState.failed;
      showCallMessage();
      stopRingingSound();
    }
  }

  stopRingingSound() {
    assetsAudioPlayer.stop();
  }

  Future<void> setupVoiceSDKEngine() async {
    await [Permission.microphone].request();
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _isJoined = true;
            callState = AudioCallState.calling;

          });
        },
        onUserMuteAudio: (connection, remoteUid, muted) {
          Console.log(remoteUid.toString(), muted);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
            callState = AudioCallState.ongoing;
            isRinging = false;
            stopWatchTimer.onStartTimer();

            stopRingingSound();
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
            callState = AudioCallState.disconnected;
            showCallMessage();
            Navigator.pop(context);
          });
        },
      ),
    );
    globals.callBloc!.add(
      InitiatePrivateCall(
          callMode: CallMode.audio,
          callType: CallType.private,
          receiverId: widget.recipient!.id!),
    );
  }

  showCallMessage() {
    Fluttertoast.showToast(msg: callState.message);
  }

  void join(String token, String channelName) async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  muteMicrophone() async {
    muteMic = !muteMic;
    await agoraEngine.muteLocalAudioStream(muteMic);
    Fluttertoast.showToast(msg: muteMic ? 'muted' : 'unmuted');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<CallBloc, CallState>(
        bloc: globals.callBloc,
        listener: (context, state) {
          if (state is CallSuccess) {
            join(state.response.token, state.response.channel);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/incoming_call.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 100,
                left: 1,
                right: 1,
                child: Column(
                  children: [
                    widget.recipient!.profilePicture == null
                        ? ImagePlaceholder(
                            width: getScreenWidth(100),
                            height: getScreenHeight(100),
                          )
                        : RecipientProfilePicture(
                            width: getScreenWidth(100),
                            height: getScreenHeight(100),
                            imageUrl: widget.recipient!.profilePicture,
                          ),
                    const SizedBox(height: 10),
                    Text(
                      widget.recipient!.firstName!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ),
                    _remoteUid != null
                        ? StreamBuilder<int>(
                            stream: stopWatchTimer.rawTime,
                            initialData: 0,
                            builder: (context, snap) {
                              final value = snap.data;
                              final displayTime = StopWatchTimer.getDisplayTime(
                                  value!,
                                  milliSecond: false);
                              return Text(
                                displayTime,
                                style: const TextStyle(color: Colors.white),
                              );
                            },
                          )
                        : Text(
                            callState.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          GestureDetector(
                            onTap: null,
                            child: Stack(
                              children: [
                                const Opacity(
                                  opacity: 0.5,
                                  child: Visibility(
                                    visible: false,
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xff000000),
                                      radius: 23,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Positioned(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                    bottom: 10,
                                    child: SvgPicture.asset(
                                      'assets/svgs/video.svg',
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FloatingActionButton(
                            backgroundColor: const Color(0xffE91C43),
                            onPressed: () {
                              Fluttertoast.showToast(msg: 'call ended');
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              'assets/svgs/call.svg',
                              color: AppColors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => muteMicrophone(),
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
                                    muteMic
                                        ? 'assets/svgs/mic_slash.svg'
                                        : 'assets/svgs/mic.svg',
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
          );
        },
      ),
    );
  }
}
