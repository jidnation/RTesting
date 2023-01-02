import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../account/presentation/widgets/image_placeholder.dart';
import '../bloc/call_bloc.dart';

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

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    Console.log('PERMISSIONS', 'permissions request');
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
          Console.log('reachme calllog error message', msg);
          Console.log('reachme calllog error', err);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Console.log('reachme calllog channel join', 'join channel success');
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
    globals.callBloc!.add(
      InitiatePrivateCall(
        callType: CallType.private,
        callMode: CallMode.video,
        receiverId: widget.recipient!.id!,
      ),
    );
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
        listener: (context, state) {
          if (state is CallSuccess) {
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
                      ? Stack(
                          children: [
                            SizedBox(
                              width: size.width,
                              height: size.height,
                              child: _remoteVideo(channelName!),
                            ),
                            Positioned(
                              bottom: 110,
                              right: 20,
                              child: SizedBox(
                                width: size.width * 0.4,
                                height: size.height * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: _localPreview(_localUserJoined, 0),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(
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
                                    widget.recipient!.firstName!,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Calling',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                Text('waiting for recipient'),
                SizedBox(height: 10,),
                CircularProgressIndicator(color: Colors.white,)
              ],
            ),
          )
        ],
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
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
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
