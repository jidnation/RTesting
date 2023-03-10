import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wakelock/wakelock.dart';

import '../../../../core/components/profile_picture.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../account/presentation/widgets/image_placeholder.dart';
import '../bloc/call_bloc.dart';

enum CallStatus {
  calling,
  ringing,
  successful,
  failed,
  rejected,
  ended,
  timedout
}

const appId = "5741afe670ba4684aec914fb19eeb82a";

class InitiateVideoCall extends StatefulWidget {
  static const String id = 'call';
  const InitiateVideoCall({Key? key, this.recipient}) : super(key: key);
  final User? recipient;

  @override
  State<InitiateVideoCall> createState() => _CallScreenState();
}

class _CallScreenState extends State<InitiateVideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool muteMic = false;
  String? channelName;
  late RtcEngine _engine;
  bool remoteUserJoined = false;
  bool callSwitched = false;

  CallStatus status = CallStatus.calling;

  final assetsAudioPlayer = AssetsAudioPlayer();
  final StopWatchTimer stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countUp);
  @override
  void initState() {
    initAgora();
    Wakelock.enable();

    super.initState();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: '5741afe670ba4684aec914fb19eeb82a',
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    _engine.registerEventHandler(agoraEventHandler());
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();
    globals.callBloc!.add(
      InitiatePrivateCall(
        callType: CallType.private,
        callMode: CallMode.video,
        receiverId: widget.recipient!.id!,
      ),
    );
  }

  RtcEngineEventHandler agoraEventHandler() {
    return RtcEngineEventHandler(
      onConnectionStateChanged: (connection, state, reason) {
        showCallAlerts(reason);
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        Console.log('reachme calllog channel join', 'join channel success');
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          _localUserJoined = true;
        });
      },
      onRemoteVideoStateChanged:
          (connection, remoteUid, state, reason, elapsed) {
        Console.log('remote video state', state);
        if (state == RemoteVideoState.remoteVideoStateStopped) {
          setState(() {
            callSwitched = true;
          });
        } else if (state == RemoteVideoState.remoteVideoStateStarting &&
            callSwitched == true) {
          setState(() {
            callSwitched = false;
          });
        }
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        stopRingingSound();
        setState(() {
          status = CallStatus.successful;
          remoteUserJoined = !remoteUserJoined;
          _remoteUid = remoteUid;
          stopWatchTimer.onStartTimer();
          Console.log('status', status);
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        debugPrint("remote user $remoteUid left channel");
        setState(() {
          status = CallStatus.ended;
          remoteUserJoined = !remoteUserJoined;
          _remoteUid = null;
        });
        endCall();
      },
    );
  }

  endCall() {
    Navigator.pop(context);
    Fluttertoast.showToast(msg: 'call ended');
  }

  join(String token, String channel) async {
    channelName = channel;
    Console.log('call joined status', 'joining');

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(),
      uid: 0,
    );
    await playRingingSound();
    setState(() {
      _localUserJoined = true;
    });
    Console.log('timer started', DateTime.now().second);
    await Future.delayed(const Duration(seconds: 30)).then((value) {
      if (_remoteUid == null) {
        setState(() {
          status = CallStatus.timedout;
        });
        Fluttertoast.showToast(
            msg: '${widget.recipient!.username} did not pick up');
        Navigator.pop(context);
        Console.log('timer started', DateTime.now().second);
      }
    });
    Console.log('call joined status', _localUserJoined);
  }

  playRingingSound() async {
    assetsAudioPlayer.open(
      Audio("assets/sounds/calling_sound.mp3"),
      autoStart: true,
      showNotification: false,
    );
  }

  stopRingingSound() {
    assetsAudioPlayer.stop();
  }

  toggleCamera() async {
    await _engine.switchCamera();
  }

  muteMicrophone() async {
    muteMic = !muteMic;
    await _engine.muteLocalAudioStream(muteMic);
    Fluttertoast.showToast(msg: muteMic ? 'muted' : 'unmuted');
    setState(() {});
  }

  @override
  void dispose() {
    _engine.disableAudio();
    _engine.disableVideo();
    _engine.leaveChannel();
    _engine.unregisterEventHandler(agoraEventHandler());
    _engine.release();
    stopRingingSound();
    Wakelock.disable();

    stopWatchTimer.dispose();
    super.dispose();
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
                width: size.width,
                height: size.height,
                child: Center(
                  child: callSwitched
                      ? Stack(
                          children: [
                            Image.asset(
                              'assets/images/incoming_call.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            widget.recipient!.profilePicture == null
                                ? Positioned(
                                    top: 100,
                                    left: 1,
                                    right: 1,
                                    child: Column(
                                      children: [
                                        ImagePlaceholder(
                                          width: getScreenWidth(100),
                                          height: getScreenHeight(100),
                                        ),
                                        Text(
                                          widget.recipient!.firstName ?? '',
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Positioned(
                                    top: 100,
                                    left: 1,
                                    right: 1,
                                    child: Column(
                                      children: [
                                        RecipientProfilePicture(
                                          width: getScreenWidth(100),
                                          height: getScreenHeight(100),
                                          imageUrl:
                                              widget.recipient!.profilePicture,
                                        ),
                                        Text(
                                          widget.recipient!.firstName ?? '',
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        )
                      : _localUserJoined
                          ? !remoteUserJoined
                              ? _localPreview(
                                  _localUserJoined,
                                  0,
                                )
                              : Stack(
                                  children: [
                                    SizedBox(
                                      width: size.width,
                                      height: size.height,
                                      child: _remoteVideo(channelName!),
                                    ),
                                    Visibility(
                                      visible: remoteUserJoined,
                                      child: Positioned(
                                        bottom: 110,
                                        right: 20,
                                        child: SizedBox(
                                          width: size.width * 0.25,
                                          height: size.height * 0.15,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: _localPreview(
                                              _localUserJoined,
                                              0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                          : const SizedBox(),
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      callSwitched = !callSwitched;
                    });
                    if (callSwitched) {
                      _engine.disableVideo();
                    } else {
                      _engine.enableVideo();
                    }
                  },
                  child: const Icon(
                    Icons.videocam_off_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 30,
                child: StreamBuilder<int>(
                  stream: stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value!,
                        milliSecond: false);
                    return Text(
                      displayTime,
                      style: const TextStyle(color: Colors.white),
                    );
                  },
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
                            onTap: () => toggleCamera(),
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
                                    'assets/svgs/video.svg',
                                    color: AppColors.white,
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

  Widget _remoteVideo(String channel) {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }
  }

  Widget _localPreview(bool _isJoined, int uid) {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

showCallAlerts(ConnectionChangedReasonType reasonType) {
  switch (reasonType) {
    case ConnectionChangedReasonType.connectionChangedConnecting:
      Fluttertoast.showToast(msg: 'connecting');
      break;
    case ConnectionChangedReasonType.connectionChangedJoinSuccess:
      Fluttertoast.showToast(msg: 'call joined');
      break;
    case ConnectionChangedReasonType.connectionChangedLost:
      Fluttertoast.showToast(msg: 'connection lost');
      break;
    case ConnectionChangedReasonType.connectionChangedLeaveChannel:
      Fluttertoast.showToast(msg: 'call ended');
      break;
    default:
      break;
  }
}
