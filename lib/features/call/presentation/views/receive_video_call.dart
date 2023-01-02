import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/features/call/presentation/bloc/call_bloc.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import 'initiate_video_call.dart';

class ReceiveVideoCall extends StatefulWidget {
  const ReceiveVideoCall({
    super.key,
    required this.channelName,
    required this.token,
  });

  final String channelName;
  final String token;

  @override
  State<ReceiveVideoCall> createState() => _ReceiveVideoCallState();
}

class _ReceiveVideoCallState extends State<ReceiveVideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  int? _localuid;
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
        onConnectionStateChanged: (connection, state, reason) {
          Console.log('reachme calllog connection ', connection);
          Console.log('reachme calllog state', state);
          Console.log('reachme calllog reason', reason);
          showCallAlerts(reason);
        },
        onPermissionError: (permissionType) {
          Console.log('reachme calllog permission error', permissionType);
        },
        onApiCallExecuted: (err, api, result) {
          Console.log('reachme calllog api err', err);
          Console.log('reachme calllog apicall', api);
          Console.log('reachme calllog apiresult', result);
        },
        onError: (err, msg) {
          Console.log('call error', msg);
          Console.log('call error', err);
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
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
    globals.callBloc!.add(AnswerPrivateCall(channelName: widget.channelName));
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
      body: BlocConsumer<CallBloc, CallState>(
        bloc: globals.callBloc,
        listener: (context, state) {},
        builder: (context, state) {
          Console.log('call state', state);
          return Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: Center(
                  child: _localUserJoined
                      ? Stack(
                          children: [
                            SizedBox(
                              width: size.width,
                              height: size.height,
                              child: _remoteVideo(
                                widget.channelName,
                              ),
                            ),
                            Positioned(
                              bottom: 110,
                              right: 20,
                              child: SizedBox(
                                width: size.width * 0.4,
                                height: size.height * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: _localPreview(
                                    _localUserJoined,
                                    0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Image.asset(
                          'assets/images/incoming_call.png',
                          fit: BoxFit.fill,
                          height: size.height,
                          width: size.width,
                        ),
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
      return Stack(
        children: [
          Image.asset(
            'assets/images/incoming_call.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ).blurred(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('waiting for caller'),
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      );
    }
  }
}
