import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';

import '../bloc/video_call_bloc.dart';

const appId = "5741afe670ba4684aec914fb19eeb82a";

class VideoCallScreen extends StatefulWidget {
  static const String id = 'video_call';
  const VideoCallScreen({Key? key, this.recipient}) : super(key: key);
  final User? recipient;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool muteMic = false;
  late RtcEngine _engine;

  @override
  void initState() {
    initAgora();
    super.initState();    
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    Console.log('PERMISSIONS', 'permissions request');
    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
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
    globals.videoCallBloc!.add(
      InitiatePrivateVideoCall(
        callType: CallType.private,
        receiverId: widget.recipient!.id!,
      ),
    );
  }

  join(String token, channel) async {
    Console.log('call joined status', 'joining');
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(),
      uid: 0,
    );
    setState(() {
      _localUserJoined = true;
    });
    Console.log('call joined status', _localUserJoined);
  }

  toggleCamera() async {
    await _engine.switchCamera();
  }

  muteMicrophone() async {
    muteMic = !muteMic;
    await _engine.muteLocalAudioStream(muteMic);
    Console.log('MIC STATUS', muteMic);
  }

  @override
  void dispose() {
    _engine.disableAudio();
    _engine.disableVideo();
    _engine.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<VideoCallBloc, VideoCallState>(
        bloc: globals.videoCallBloc,
        listener: (context, state) {
          if (state is VideoCallSuccess) {
            join(state.response.token, state.response.channel);
          }
        },
        builder: (context, state) {
          Console.log('call state', state);
          return Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
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
                          CircleAvatar(
                            backgroundColor: const Color(0xffE91C43),
                            radius: 29,
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
          );
        },
      ),
    );
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
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: 'channelName'),
        ),
      );
    } else {
      String msg = '';
      if (_localUserJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
