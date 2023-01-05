import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/utils/app_globals.dart';

import '../../../../core/models/user.dart';
import '../bloc/call_bloc.dart';

const appId = "5741afe670ba4684aec914fb19eeb82a";

class InitiateAudioCall extends StatefulWidget {
  const InitiateAudioCall({super.key, this.recipient});

  final User? recipient;

  @override
  State<InitiateAudioCall> createState() => _InitiateAudioCallState();
}

class _InitiateAudioCallState extends State<InitiateAudioCall> {
  int uid = 0;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  @override
  void initState() {
    setupVoiceSDKEngine();
    super.initState();
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    super.dispose();
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
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    globals.callBloc!.add(InitiatePrivateCall(
        callMode: CallMode.audio,
        callType: CallType.private,
        receiverId: widget.recipient!.id!));
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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CallBloc, CallState>(
        bloc: globals.callBloc,
        listener: (context, state) {
          if (state is CallSuccess) {
            join(state.response.token, state.response.channel);
          }
        },
        builder: (context, state) {
          return const SizedBox();
        },
      ),
    );
  }
}
