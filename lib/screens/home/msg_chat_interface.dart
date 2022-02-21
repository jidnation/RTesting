import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/home/chats_list_screen.dart';
import 'package:reach_me/screens/home/view_comments.dart';
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
              onPressed: () {},
              splashRadius: 20,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 30,
            width: 30,
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/voice call.svg'),
              onPressed: () {},
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
                      const ProfilePicture(height: 100, width: 100),
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
                                fontSize: 16,
                                color: AppColors.greyShade2,
                                fontWeight: FontWeight.w400),
                          )),
                      const SizedBox(height: 20),
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
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/svgs/camera icon blue.svg',
                          width: 28,
                          height: 22,
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/svgs/attach_svg.svg',
                          width: 28,
                          height: 22,
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/svgs/mic.svg',
                          width: 30, height: 30)))
            ],
          )
        ],
      ).paddingOnly(r: 15, l: 15, b: 15),
    );
  }
}

class MsgBubble extends StatelessWidget {
  const MsgBubble({
    Key? key,
    required this.isMe,
    required this.label,
    required this.size,
    required this.timeStamp,
  }) : super(key: key);

  final Size size;
  final bool isMe;
  final String label;
  final String timeStamp;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
      color: AppColors.white,
      borderColor: const Color(0xFFE1E1E1),
      borderWidth: 2,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width / 1.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textBaseline: TextBaseline.ideographic,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor2,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeStamp,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor2),
                )),
          ],
        ),
      ),
    );
  }
}

Future showKebabBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            decoration: const BoxDecoration(
              color: AppColors.greyShade7,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ListView(shrinkWrap: true, children: [
              Center(
                child: Container(
                    height: 4,
                    width: 58,
                    decoration: BoxDecoration(
                        color: AppColors.greyShade4,
                        borderRadius: BorderRadius.circular(40))),
              ).paddingOnly(t: 23),
              const SizedBox(height: 20),
              KebabBottomTextButton(label: 'Mute message', onPressed: () {}),
              KebabBottomTextButton(label: 'Clear chat', onPressed: () {}),
              KebabBottomTextButton(label: 'Search', onPressed: () {}),
              KebabBottomTextButton(label: 'Report', onPressed: () {}),
              KebabBottomTextButton(label: 'Restrict', onPressed: () {}),
              KebabBottomTextButton(label: 'Block', onPressed: () {}),
              const SizedBox(height: 20),
            ]));
      });
}
