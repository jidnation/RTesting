
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/chat/widgets/bottom_sheet.dart';
import 'package:reach_me/screens/chat/widgets/msg_bubble.dart';
import 'package:reach_me/screens/video-call/video_call_screen.dart';
import 'package:reach_me/screens/voice-call/voice_call_screen.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

class MsgChatInterface extends StatefulWidget {
  static const String id = 'msg_chat_interface';
  const MsgChatInterface({Key? key}) : super(key: key);

  @override
  State<MsgChatInterface> createState() => _MsgChatInterfaceState();
}

class _MsgChatInterfaceState extends State<MsgChatInterface> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundShade2,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.backgroundShade2,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        shadowColor: const Color(0x1A000000),
        elevation: 4,
        leadingWidth: 45,
        titleSpacing: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/svgs/arrow-back.svg',
            width: 19,
            height: 12,
          ),
          onPressed: () => NavigationService.goBack(),
        ),
        title: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProfilePicture(width: 30, height: 30),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Rooney Brown',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black)),
                  Text('Active about 45min ago',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyShade2)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            height: 40,
            width: 40,
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/video call.svg'),
              onPressed: () {
                NavigationService.navigateTo(VideoCallScreen.id);
              },
              splashRadius: 20,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 30,
            width: 30,
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/voice call.svg'),
              onPressed: () {
                NavigationService.navigateTo(VoiceCallScreen.id);
              },
              splashRadius: 20,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 25,
            width: 20,
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/more-vertical.svg'),
              onPressed: () async {
                await showKebabBottomSheet(context);
              },
              splashRadius: 20,
            ),
          ).paddingOnly(r: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              controller: _controller,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const ProfilePicture(height: 80, width: 80),
                      const SizedBox(height: 5),
                      const Text('Rooney Brown',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor2)),
                      const Text('@RooneyBrown',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor2)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '2K',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Reachers',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '270',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Reaching',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(
                          width: 290,
                          child: Text(
                            "English actor, typecast as the antihro, Born in shirebrook, Derbyshire",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.greyShade2,
                                fontWeight: FontWeight.w400),
                          )),
                      const SizedBox(height: 15),
                      SizedBox(
                          width: 130,
                          height: 41,
                          child: CustomButton(
                              label: 'View Profile',
                              color: AppColors.primaryColor,
                              onPressed: () {},
                              size: size,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9, horizontal: 21),
                              textColor: AppColors.white,
                              borderSide: BorderSide.none)),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                MsgBubble(
                  size: size,
                  isMe: true,
                  label: 'Hello ReachMe, How are you doing today?',
                  timeStamp: '5:01 AM',
                ),
                MsgBubble(
                  size: size,
                  isMe: false,
                  label: 'Fine, thank you, and you?',
                  timeStamp: '5:01 AM',
                ),
                MsgBubble(
                  size: size,
                  isMe: true,
                  label: 'I am good',
                  timeStamp: '5:01 AM',
                ),
                MsgBubble(
                  size: size,
                  isMe: false,
                  label: 'Fine, thank you, and you?',
                  timeStamp: '5:01 AM',
                ),
                MsgBubble(
                  size: size,
                  isMe: true,
                  label: 'I am good',
                  timeStamp: '5:01 AM',
                ),
                MsgBubble(
                  size: size,
                  isMe: false,
                  label: 'Fine, thank you, and you?',
                  timeStamp: '5:01 AM',
                ),
                MsgBubble(
                  size: size,
                  isMe: true,
                  label: 'I am good',
                  timeStamp: '5:01 AM',
                ),
                MsgBubble(
                  size: size,
                  isMe: true,
                  label: 'Hello ReachMe, How are you doing today?',
                  timeStamp: '5:01 AM',
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: CustomRoundTextField(
                  textCapitalization: TextCapitalization.sentences,
                  hintText: 'Type Message...',
                  hintStyle:
                      const TextStyle(color: Color(0xFF666666), fontSize: 12),
                  prefixIcon: GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/svgs/smile.svg',
                    ).paddingAll(10),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('tapped camera icon');
                        },
                        child: SvgPicture.asset(
                          'assets/svgs/camera icon blue.svg',
                          width: 24,
                          height: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          print('tapped attach icon');
                        },
                        child: SvgPicture.asset(
                          'assets/svgs/attach_svg.svg',
                          width: 24,
                          height: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/svgs/mic.svg',
                          width: 25, height: 25)))
            ],
          )
        ],
      ).paddingOnly(r: 15, l: 15, b: 15),
    );
  }
}
