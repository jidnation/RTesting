import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/video-call/presentation/bloc/video_call_bloc.dart';

import '../../../../core/models/user.dart';

class VideoCallScreen extends StatefulWidget {
  static const String id = 'video_call';
  const VideoCallScreen({Key? key, this.recipient}) : super(key: key);
  final User? recipient;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine agoraEngine;
  late int? remoteUid; // uid of the remote user
  bool isJoined = false;
  bool muteMic = false;

  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone, Permission.camera].request();
    agoraEngine = createAgoraRtcEngine();
    Console.log('call engine', agoraEngine);
    await agoraEngine.initialize(
        const RtcEngineContext(appId: "5741afe670ba4684aec914fb19eeb82a"));
    await agoraEngine.enableVideo();
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Console.log("call Local user uid",
              ":${connection.localUid} joined the channel");
          setState(() {
            isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUId, int elapsed) {
          Console.log("call Local user uid",
              ":${connection.localUid} joined the channel");
          setState(() {
            remoteUid = remoteUId;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUId,
            UserOfflineReasonType reason) {
          Console.log("Remote user uid", "$remoteUId left the channel");
          setState(() {
            remoteUid = null;
          });
        },
      ),
    );
    Console.log('call engine init', 'engine done');
    await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await agoraEngine.enableVideo();
    await agoraEngine.startPreview();
  }

  void join(String token, String channelName) async {
    Console.log('call token', token);
    Console.log('call channelName', channelName);
    await agoraEngine.startPreview();
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    Console.log('call options', options);
    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: Random().nextInt(2),
    );
  }

  void leave() {
    setState(() {
      isJoined = false;
      remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  @override
  void initState() {
    globals.videoCallBloc!.add(InitiatePrivateVideoCall(
      callMode: CallMode.video,
      callType: CallType.private,
      receiverId: widget.recipient!.id!,
    ));
    setupVideoSDKEngine();
    super.initState();
  }

  

  toggleJoined() {
    setState(() {
      isJoined = !isJoined;
    });
  }

  toggleCamera() async {
    await agoraEngine.switchCamera();
  }

  muteMicrophone() async {
    muteMic = !muteMic;
    await agoraEngine.muteLocalAudioStream(muteMic);
    Console.log('MIC STATUS', muteMic);
  }

  @override
  void dispose() {
    agoraEngine.disableAudio();
    agoraEngine.disableVideo();
    agoraEngine.disableAudioSpectrumMonitor();
    agoraEngine.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<VideoCallBloc, VideoCallState>(
            bloc: globals.videoCallBloc,
            listener: (context, state) {
              if (state is VideoCallSuccess) {
                // join(state.response.token, state.response.channel);
                Console.log('call state token', state.response.token);
                Console.log('call state channle', state.response.channel);
                join(state.response.token, state.response.channel);
              }
              if (state is VideoCallError) {
                // Console.log('call error', state.message);
              }
              if (state is VideoCallLoading) {}
            },
            builder: (context, state) {
              Console.log('call state', state);

              if (state is VideoCallSuccess) {
                return _localPreview();
              }
              return SizedBox(
                height: size.height,
                width: size.width,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/video-call.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: size.width * 0.36,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          globals.user!.profilePicture == null
                              ? ImagePlaceholder(
                                  width: getScreenWidth(100),
                                  height: getScreenHeight(100),
                                )
                              : ProfilePicture(
                                  width: getScreenWidth(100),
                                  height: getScreenHeight(100),
                                ),
                          Text(
                            widget.recipient!.firstName!,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Calling...',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 12,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            //   borderRadius: BorderRadius.circular(8.0),
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, Color(0xFF00CCD9)],
              stops: [0, 100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: SizedBox(
                  height: 50,
                  width: 50,
                  child: SvgPicture.asset('assets/svgs/flip-camera.svg'),
                ),
              ),
              SizedBox(
                width: 65,
                height: 65,
                child: IconButton(
                  onPressed: () {},
                  icon: Container(
                    width: 65,
                    height: 65,
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                        color: Color(0xFFE91C43), shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      'assets/svgs/end-call.svg',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                width: 44,
                child: IconButton(
                  onPressed: () {},
                  icon: SizedBox(
                    height: 38,
                    width: 38,
                    child: SvgPicture.asset('assets/svgs/mute-call.svg'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _localPreview() {
    if (isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Join a channel',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

// Display remote user's video
  // Widget _remoteVideo() {
  //   if (_remoteUid != null) {
  //     return AgoraVideoView(
  //       controller: VideoViewController.remote(
  //         rtcEngine: agoraEngine,
  //         canvas: VideoCanvas(uid: re),
  //         connection: RtcConnection(channelId: channelName),
  //       ),
  //     );
  //   } else {
  //     String msg = '';
  //     if (_isJoined) msg = 'Waiting for a remote user to join';
  //     return Text(
  //       msg,
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }
}
