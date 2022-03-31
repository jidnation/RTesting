import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class ChatsListScreen extends StatelessWidget {
  static const String id = 'chats_list_screen';
  const ChatsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset('assets/svgs/arrow-back.svg',
                width: 19, height: 12),
            onPressed: () {
              RouteNavigators.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/svgs/settings.svg',
                  width: 23, height: 23, color: AppColors.blackShade3),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 48,
                      child: CustomRoundTextField(
                        hintText: 'Search Reach',
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ).paddingSymmetric(h: 20),
                    const SizedBox(height: 25),
                    Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.greyShade5, width: 1.0),
                            ),
                          ),
                        ),
                        const TabBar(
                          indicatorWeight: 1.5,
                          indicatorColor: AppColors.primaryColor,
                          unselectedLabelColor: AppColors.greyShade4,
                          labelColor: AppColors.textColor2,
                          tabs: [
                            Tab(
                              child: Text(
                                'General Reachout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Starred Reachout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                        child: TabBarView(children: [
                      ListView(
                        shrinkWrap: true,
                        children: const [
                          SizedBox(height: 14),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                        ],
                      ).paddingSymmetric(h: 14),
                      ListView(
                        shrinkWrap: true,
                        children: const [
                          SizedBox(height: 14),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                          ChatItem(username: 'Rooney Brown', status: 'Seen'),
                          ChatItem(
                              username: 'Gospel Chapel',
                              status: 'Sent Thursday'),
                          ChatItem(
                              username: 'Wendy Francis',
                              status: 'Liked a message'),
                        ],
                      ).paddingSymmetric(h: 14),
                    ]))
                  ],
                )),
          ),
        ));
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem(
      {Key? key, this.avatar, required this.status, required this.username})
      : super(key: key);

  final String username;
  final String status;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        RouteNavigators.route(context, const MsgChatInterface());
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.hardEdge,
            child: Image.asset('assets/images/user.png', fit: BoxFit.fill),
            decoration: const BoxDecoration(shape: BoxShape.circle),
          ),
          const SizedBox(width: 13),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor2,
                        fontWeight: FontWeight.w500)),
                Text(status,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.greyShade3,
                        fontWeight: FontWeight.w400)),
              ])
        ],
      ),
    );
  }
}
