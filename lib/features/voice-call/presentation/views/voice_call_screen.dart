import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/voice-call/presentation/bloc/voice_call_bloc.dart';

import '../../../../core/models/user.dart';
import '../../../video-call/presentation/bloc/video_call_bloc.dart';

class VoiceCallScreen extends StatefulWidget {
  static const String id = 'voice_call';
  const VoiceCallScreen({Key? key, this.recipient}) : super(key: key);

  final User? recipient;

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  @override
  void initState() {
    globals.voiceCallBloc!.add(InitiatePrivateAudioCall(
      callType: CallType.private,
      receiverId: widget.recipient!.id!,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            GestureDetector(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/voice-call.png'),
                    fit: BoxFit.cover,
                  ),
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
                    widget.recipient!.firstName ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Calling...',
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
                const SizedBox(height: 48, width: 48),
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
            )),
      ),
    );
  }
}
