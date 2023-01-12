import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/home/presentation/views/status/widgets/join_post.dart';

class HostPost extends StatefulWidget {
  final bool? isHost;
  final String? channelName;
  final String? token;
  final String? audienceId;
  const HostPost(
      {Key? key,
      required this.isHost,
      this.channelName,
      this.token,
      this.audienceId})
      : super(key: key);

  @override
  State<HostPost> createState() => _HostPostState();
}

class _HostPostState extends State<HostPost> {
  int uid = 0; // uid of the local user
  int check = 0;

  bool loadState = false;
  bool start = false;
  bool mute = false;

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  var users = [];

  @override
  void initState() {
    super.initState();
    setupVideoSDKEngine();
  }

  @override
  void dispose() async {
    users.clear();
    await agoraEngine.leaveChannel();
    await agoraEngine.disableAudio();
    await agoraEngine.disableVideo();
    await agoraEngine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(child: _videoPanel()),
            ),
          ),
        ]),
      ),
      bottomSheet: widget.isHost == true
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                        // visible: !_isRecording,
                        child: MomentMicBtn(
                      svgUrl: 'assets/svgs/mic-solid.svg',
                      onClick: () async {
                        setState(() {
                          mute = !mute;
                        });
                        await agoraEngine.muteLocalAudioStream(mute);
                      },
                    )),
                    SizedBox(width: 30),
                    !start
                        ? InkWell(
                            onTap: () {
                              join();
                              setState(() {
                                start = true;
                              });
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: Colors.red,
                              ),
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/svgs/fluent_live-24-regular.svg',
                                    color: AppColors.black,
                                  )),
                            ))
                        : InkWell(
                            onTap: () {
                              setState(() {
                                start = false;
                              });
                              leave();
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: Colors.red,
                              ),
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  )),
                            )),
                    SizedBox(width: 30),
                    Visibility(
                      // visible: _isRecording,
                      child: MomentCameraBtn(
                        svgUrl: 'assets/svgs/flip-camera.svg',
                        onClick: () async {
                          await agoraEngine.switchCamera();
                        },
                      ),
                    ),
                  ]),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 210,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: CustomRoundTextField(
                    verticalHeight: 20,
                    borderRadius: 30,
                    enabledBorderSide:
                        BorderSide(color: Colors.white, width: 2),
                    fillColor: Colors.black.withOpacity(0.4),
                    hintStyle: TextStyle(color: Colors.white),
                    textStyle: TextStyle(color: Colors.white),
                    textCapitalization: TextCapitalization.none,
                    hintText: "Comment",
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/svgs/like.svg',
                    height: 35,
                    color: Colors.yellow,
                    width: 20,
                    // fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    leave();
                  },
                  child: const Icon(
                    Icons.favorite_border,
                    size: 35,
                    color: Colors.yellow,
                  ),
                )
              ]),
            ),
    );
  }

  void leave() async {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    await agoraEngine.leaveChannel().then((value) => {
          RouteNavigators.pop(context),
          agoraEngine.disableAudio(),
          agoraEngine.disableVideo(),
          agoraEngine.release(),
        });
  }

  Widget _videoPanel() {
    if (!_isJoined) {
      return GestureDetector(
        onTap: () {
          widget.isHost! ? () {} : join();
        },
        child: Text(
          widget.isHost! ? 'yet to begin livestream' : 'click here to join',
          textAlign: TextAlign.center,
        ),
      );
    } else if (widget.isHost == true) {
      // Local user joined as a host
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      // Local user joined as audience
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(
                channelId: globals.streamLive!.channelName.toString()),
          ),
        );
      } else {
        return const Text(
          'Waiting for a host to join',
          textAlign: TextAlign.center,
        );
      }
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();
    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(
        const RtcEngineContext(appId: "5741afe670ba4684aec914fb19eeb82a"));

    await agoraEngine.enableVideo();

    _addEventHandler();
  }

  void _addEventHandler() async {
    final eventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType errorCode, String errorMessage) {
        print(
            "error code of:${errorCode.toString()} occured with message $errorMessage");
      },
      onUserStateChanged:
          (RtcConnection connection, int remoteUid, int elapsed) {
        print("Local user uid:${connection.localUid} joined the channel");
        setState(() {
          //_isJoined = true;
        });
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print("Local user uid:${connection.localUid} joined the channel");
        setState(() {
          _isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        print("Remote user uid:$remoteUid joined the channel");
        setState(() {
          _remoteUid = remoteUid;
          users.add(remoteUid);
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        print("Remote user uid:$remoteUid left the channel");
        setState(() {
          _remoteUid = null;
          users.remove(_remoteUid);
          if (_remoteUid == int.parse(widget.audienceId!)) {
            leave();
            users.remove(_remoteUid);
          }
        });
      },
    );
    // Register the event handler
    agoraEngine.registerEventHandler(eventHandler);
  }

  void join() async {
    ChannelMediaOptions options;

    // Set channel profile and client role
    if (widget.isHost == true) {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );

      await agoraEngine.startPreview();

      setState(() {});
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );

      await agoraEngine.enableAudio();
      agoraEngine.setEnableSpeakerphone(true);

      setState(() {});
    }

    await agoraEngine.joinChannel(
      token: widget.isHost == true
          ? globals.streamLive!.token.toString()
          : widget.token!,
      channelId: widget.isHost == true
          ? globals.streamLive!.channelName.toString()
          : widget.channelName!,
      options: options,
      uid: uid,
    );

    globals.chatBloc!.add(JoinStreamEvent(
        channelName: globals.streamLive!.channelName.toString()));

    _addEventHandler();
  }
}

class MomentCameraBtn extends StatelessWidget {
  final String svgUrl;
  final double? padding;
  final Function()? onClick;
  const MomentCameraBtn({
    Key? key,
    required this.svgUrl,
    this.onClick,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 46,
        width: 46,
        padding: EdgeInsets.all(padding ?? 0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: SvgPicture.asset(
          svgUrl,
          height: 16.58,
          width: 16.58,
        ),
      ),
    );
  }
}

class MomentMicBtn extends StatelessWidget {
  final String svgUrl;
  final Function()? onClick;
  const MomentMicBtn({
    Key? key,
    required this.svgUrl,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.mic, color: Colors.white, size: 35)),
    );
  }
}
