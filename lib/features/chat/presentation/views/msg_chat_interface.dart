import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/chat/presentation/widgets/bottom_sheet.dart';
import 'package:reach_me/features/chat/presentation/widgets/msg_bubble.dart';
import 'package:reach_me/features/video-call/video_call_screen.dart';
import 'package:reach_me/features/voice-call/voice_call_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class MsgChatInterface extends StatefulHookWidget {
  static const String id = 'msg_chat_interface';
  const MsgChatInterface({Key? key, this.recipientUser}) : super(key: key);
  final User? recipientUser;

  @override
  State<MsgChatInterface> createState() => _MsgChatInterfaceState();
}

class _MsgChatInterfaceState extends State<MsgChatInterface> {
  final ScrollController _controller = ScrollController();
  Timer? timer;

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
    globals.chatBloc!
        .add(SubcribeToChatStreamEvent(id: widget.recipientUser!.id));
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      globals.chatBloc!.add(GetThreadMessagesEvent(
          id: '${globals.user!.id}--${widget.recipientUser!.id}'));
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Future<XFile?> getImage(ImageSource source) async {
    final _picker = ImagePicker();
    try {
      final imageFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 900,
        maxWidth: 600,
      );

      if (imageFile != null) {
        return imageFile;
      }
    } catch (e) {
      // print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isTyping = useState<bool>(false);
    final isSending = useState<bool>(false);
    final showIsSending = useState<bool>(false);
    //final isRecording = useState<bool>(false);
    final controller = useTextEditingController();
    useMemoized(() {
      //  timer = Timer.periodic(const Duration(seconds: 60), (timer) {

      // SchedulerBinding.instance!.addPostFrameCallback((_) {
      //   _controller.animateTo(
      //     _controller.position.maxScrollExtent,
      //     duration: const Duration(milliseconds: 10),
      //     curve: Curves.easeOut,
      //   );
      // });
      // });
      globals.chatBloc!.add(GetThreadMessagesEvent(
          id: '${globals.user!.id}--${widget.recipientUser!.id}'));
    }, [globals.recipientUser!.id]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness:
              Platform.isAndroid ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.grey,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        shadowColor: Colors.transparent,
        elevation: 4,
        leadingWidth: 45,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          splashRadius: 15,
          onPressed: () => RouteNavigators.pop(context),
        ),
        title: InkWell(
          onTap: () {
            RouteNavigators.route(
                context,
                RecipientAccountProfile(
                  recipientEmail: widget.recipientUser!.email,
                  recipientImageUrl: widget.recipientUser!.profilePicture,
                  recipientId: widget.recipientUser!.id,
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.recipientUser!.profilePicture == null
                  ? ImagePlaceholder(
                      width: getScreenWidth(30),
                      height: getScreenHeight(30),
                    )
                  : ProfilePicture(
                      width: getScreenWidth(30),
                      height: getScreenHeight(30),
                    ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      (widget.recipientUser!.firstName! +
                              ' ' +
                              widget.recipientUser!.lastName!)
                          .toTitleCase(),
                      style: TextStyle(
                        fontSize: getScreenHeight(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      'Active about 45min ago',
                      style: TextStyle(
                        fontSize: getScreenHeight(11),
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyShade2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            height: getScreenHeight(40),
            width: getScreenWidth(40),
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/video.svg'),
              onPressed: () {
                RouteNavigators.route(context, const VideoCallScreen());
              },
              splashRadius: 20,
            ),
          ),
          SizedBox(width: getScreenWidth(10)),
          SizedBox(
            height: getScreenHeight(35),
            width: getScreenWidth(35),
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/call.svg'),
              onPressed: () {
                RouteNavigators.route(context, const VoiceCallScreen());
              },
              splashRadius: 20,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: getScreenHeight(35),
            width: getScreenWidth(30),
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/pop-vertical.svg'),
              onPressed: () async {
                await showKebabBottomSheet(context);
              },
              splashRadius: 20,
            ),
          ).paddingOnly(r: 10),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
          bloc: globals.chatBloc,
          listener: (context, state) {
            if (state is ChatStreamData) {
              print(state.data);
            }
            // if (state is ChatLoading) {
            //   isSending.value = true;
            //   showIsSending.value = true;
            // }
            if (state is GetThreadMessagesSuccess) {
              isSending.value = false;
              showIsSending.value = false;

              SchedulerBinding.instance!.addPostFrameCallback((_) {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.easeOut,
                );
              });
            }

            if (state is ChatUploadSuccess) {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.easeOut,
                );
              });

              globals.chatBloc!.add(SendChatMessageEvent(
                senderId: globals.user!.id,
                receiverId: widget.recipientUser!.id,
                threadId: '${globals.user!.id}--${widget.recipientUser!.id}',
                value: state.imgUrl,
                type: 'image',
              ));

              isSending.value = true;
              showIsSending.value = true;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    Flexible(
                      child: ListView(
                        controller: _controller,
                        shrinkWrap: false,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: getScreenHeight(20)),
                              widget.recipientUser!.profilePicture == null
                                  ? ImagePlaceholder(
                                      width: getScreenWidth(80),
                                      height: getScreenHeight(80),
                                    )
                                  : ProfilePicture(
                                      width: getScreenWidth(80),
                                      height: getScreenHeight(80),
                                    ),
                              SizedBox(height: getScreenHeight(5)),
                              Text(
                                  (widget.recipientUser!.firstName! +
                                          ' ' +
                                          widget.recipientUser!.lastName!)
                                      .toTitleCase(),
                                  style: TextStyle(
                                    fontSize: getScreenHeight(14),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor2,
                                  )),
                              Text('@${widget.recipientUser!.username}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(11),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF767474),
                                  )),
                              SizedBox(height: getScreenHeight(10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.recipientUser!.nReachers
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          color: AppColors.greyShade2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Reachers',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(14),
                                          color: AppColors.greyShade2,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: getScreenWidth(20)),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.recipientUser!.nReaching
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          color: AppColors.greyShade2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Reaching',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(14),
                                          color: AppColors.greyShade2,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: getScreenHeight(11)),
                              if (widget.recipientUser!.bio == null)
                                const SizedBox.shrink()
                              else
                                SizedBox(
                                    width: getScreenWidth(290),
                                    child: Text(
                                      widget.recipientUser!.bio ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: getScreenHeight(14),
                                        color: AppColors.greyShade2,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                              SizedBox(height: getScreenHeight(15)),
                              SizedBox(
                                  width: getScreenWidth(130),
                                  height: getScreenHeight(41),
                                  child: CustomButton(
                                    label: 'View Profile',
                                    color: AppColors.white,
                                    onPressed: () {
                                      RouteNavigators.route(context,
                                          const RecipientAccountProfile());
                                    },
                                    size: size,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 9,
                                      horizontal: 21,
                                    ),
                                    textColor: const Color(0xFF767474),
                                    borderSide: BorderSide.none,
                                  )),
                              const SizedBox(height: 15),
                              const Text(
                                'Apr 30, 2021',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textColor2,
                                ),
                              )
                            ],
                          ),
                          if (globals.userChat!.isEmpty)
                            const SizedBox.shrink()
                          else
                            Column(
                              children: List.generate(
                                globals.userChat!.length,
                                (index) => MsgBubble(
                                  isMe: globals.user!.id ==
                                      globals.userChat![index].senderId,
                                  label: globals.userChat![index].value!,
                                  size: size,
                                  timeStamp: '3:00PM',
                                  // timeStamp: Helper.parseChatDate(globals.userChat![index].sentAt!),
                                ),
                              ),
                            )
                        ],
                      ).paddingOnly(r: 15, l: 15),
                    ),
                    Visibility(
                      visible: showIsSending.value,
                      child: Row(
                        mainAxisAlignment:
                            globals.user!.id != widget.recipientUser!.id
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sending',
                            style: TextStyle(
                              fontSize: getScreenHeight(11),
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ).paddingSymmetric(h: 30),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: Offset(
                            0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
                        child: Row(
                          children: [
                            Flexible(
                              child: CustomRoundTextField(
                                controller: controller,
                                fillColor: AppColors.white,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                hintText: 'Type Message...',
                                hintStyle: const TextStyle(
                                    color: Color(0xFF666666), fontSize: 12),
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    isTyping.value = true;
                                  } else {
                                    isTyping.value = false;
                                  }
                                },
                                prefixIcon: GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/svgs/emoji.svg',
                                  ).paddingAll(10),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/svgs/attach.svg',
                                        // width: 24,
                                        // height: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Column(children: [
                                                  ListTile(
                                                    leading: SvgPicture.asset(
                                                      'assets/svgs/Camera.svg',
                                                      color: AppColors.black,
                                                    ),
                                                    title: const Text('Camera'),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      final image =
                                                          await getImage(
                                                              ImageSource
                                                                  .camera);
                                                      if (image != null) {
                                                        globals.chatBloc!.add(
                                                            UploadImageFileEvent(
                                                                file: image));
                                                      }
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: SvgPicture.asset(
                                                        'assets/svgs/gallery.svg'),
                                                    title:
                                                        const Text('Gallery'),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      final image =
                                                          await getImage(
                                                              ImageSource
                                                                  .gallery);
                                                      if (image != null) {
                                                        globals.chatBloc!.add(
                                                            UploadImageFileEvent(
                                                                file: image));
                                                      }
                                                    },
                                                  ),
                                                ]).paddingSymmetric(v: 5),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svgs/gallery.svg',
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            isTyping.value
                                ? GestureDetector(
                                    onTap: () {
                                      if (controller.text.isNotEmpty ||
                                          controller.text != ' ') {
                                        final value = controller.text.trim();

                                        Chat temp = Chat(
                                            senderId: globals.user!.id,
                                            type: 'text',
                                            value: controller.text.trim());
                                        globals.userChat!.add(temp);
                                        controller.clear();

                                        SchedulerBinding.instance!
                                            .addPostFrameCallback(
                                          (_) {
                                            _controller.animateTo(
                                              _controller
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 10),
                                              curve: Curves.easeOut,
                                            );
                                          },
                                        );

                                        globals.chatBloc!.add(
                                          SendChatMessageEvent(
                                            senderId: globals.user!.id,
                                            receiverId:
                                                widget.recipientUser!.id,
                                            threadId:
                                                '${globals.user!.id}--${widget.recipientUser!.id}',
                                            value: value,
                                            type: 'text',
                                          ),
                                        );
                                        isSending.value = true;
                                        showIsSending.value = true;
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svgs/send.svg',
                                        width: 25,
                                        height: 25,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svgs/mic.svg',
                                        width: 25,
                                        height: 25,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  )
                          ],
                        ).paddingOnly(r: 15, l: 15, b: 15, t: 10),
                      ),
                    )
                  ],
                ),
                //const Spacer(),
              ],
            );
          }),
    );
  }
}
