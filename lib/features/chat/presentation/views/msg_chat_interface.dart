import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/chat/presentation/widgets/msg_bubble.dart';
import 'package:reach_me/features/video-call/video_call_screen.dart';
import 'package:reach_me/features/voice-call/voice_call_screen.dart';

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
  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecordingInit = false;
  bool isRecording = false;

  //AUDIO_WAVEFORM RECORDER
  RecorderController? recorderController;
  File? audioFile;
  String? filePath;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();

    openAudio();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
    });
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      globals.chatBloc!.add(GetThreadMessagesEvent(
          id: '${globals.user!.id}--${widget.recipientUser!.id}'));
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
    _soundRecorder?.closeRecorder();
    isRecordingInit = false;
    focusNode.dispose();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    await _soundRecorder!
        .setSubscriptionDuration(const Duration(milliseconds: 500));
    isRecordingInit = true;
  }

  Future<File?> getImage(ImageSource source) async {
    final _picker = ImagePicker();
    try {
      final imageFile = await _picker.pickImage(
        source: source,
        imageQuality: 100,
        // maxHeight: 900,
        // maxWidth: 600,
      );

      if (imageFile != null) {
        File image = File(imageFile.path);
        return image;
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
    final controller = useTextEditingController();
    useEffect(() {
      globals.chatBloc!.add(GetThreadMessagesEvent(
          id: '${globals.user!.id}--${widget.recipientUser!.id}'));
      return null;
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
                  : RecipientProfilePicture(
                      width: getScreenWidth(30),
                      height: getScreenHeight(30),
                      imageUrl: widget.recipientUser!.profilePicture,
                    ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      '@${widget.recipientUser!.username}',
                      style: TextStyle(
                        fontSize: getScreenHeight(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      'Active ${Helper.parseUserLastSeen(widget.recipientUser!.lastSeen ?? '50')}',
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
          // SizedBox(
          //   height: getScreenHeight(35),
          //   width: getScreenWidth(30),
          //   child: IconButton(
          //     icon: SvgPicture.asset('assets/svgs/pop-vertical.svg'),
          //     onPressed: () async {
          //       await showKebabBottomSheet(context);
          //     },
          //     splashRadius: 20,
          //   ),
          // ).paddingOnly(r: 10),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
          bloc: globals.chatBloc,
          listener: (context, state) {
            if (state is ChatStreamData) {
              print(state.data);
            }

            if (state is GetThreadMessagesSuccess) {
              isSending.value = false;
              showIsSending.value = false;
            }

            if (state is ChatUploadSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
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
            return
                // Container(
                //   width: size.width,
                //   height: size.height,
                // child:
                WillPopScope(
                    child: Stack(
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
                                      widget.recipientUser!.profilePicture ==
                                              null
                                          ? ImagePlaceholder(
                                              width: getScreenWidth(80),
                                              height: getScreenHeight(80),
                                            )
                                          : RecipientProfilePicture(
                                              width: getScreenWidth(80),
                                              height: getScreenHeight(80),
                                              imageUrl: widget.recipientUser!
                                                  .profilePicture,
                                            ),
                                      SizedBox(height: getScreenHeight(5)),
                                      Text('@${widget.recipientUser!.username}',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(14),
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textColor2,
                                          )),
                                      SizedBox(height: getScreenHeight(10)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  fontWeight: FontWeight.w500,
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
                                                  fontWeight: FontWeight.w500,
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
                                              RouteNavigators.route(
                                                  context,
                                                  RecipientAccountProfile(
                                                    recipientEmail: widget
                                                        .recipientUser!.email,
                                                    recipientImageUrl: widget
                                                        .recipientUser!
                                                        .profilePicture,
                                                    recipientId: widget
                                                        .recipientUser!.id,
                                                  ));
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
                                    ],
                                  ),
                                  if (globals.userChat!.isEmpty)
                                    const SizedBox.shrink()
                                  else
                                    ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (c, i) => MsgBubble(
                                              msgDate: '',
                                              isMe: globals.user!.id ==
                                                  globals.userChat![i].senderId,
                                              label:
                                                  globals.userChat![i].value!,
                                              size: size,
                                              timeStamp: Helper.parseChatTime(
                                                  globals.userChat![i].sentAt ??
                                                      ''),
                                            ),
                                        separatorBuilder: (c, i) => SizedBox(
                                              height: 0,
                                            ),
                                        itemCount: globals.userChat!.length)
                                  // Column(
                                  //   children: List.generate(
                                  //     globals.userChat!.length,
                                  //     (index) => MsgBubble(
                                  //       msgDate: '',
                                  //       isMe: globals.user!.id ==
                                  //           globals.userChat![index].senderId,
                                  //       label:
                                  //           globals.userChat![index].value!,
                                  //       size: size,
                                  //       timeStamp: Helper.parseChatTime(
                                  //           globals.userChat![index].sentAt ??
                                  //               ''),
                                  //     ),
                                  //   ),
                                  // )
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
                              /*child: Transform.translate(
                              offset: Offset(
                                  0.0,
                                  -1 *
                                      MediaQuery.of(context).viewInsets.bottom),*/
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(children: [
                                    Flexible(
                                        child: !isRecording
                                            ? CustomRoundTextField(
                                                focusNode: focusNode,
                                                controller: controller,
                                                fillColor: AppColors.white,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                hintText: 'Type Message...',
                                                hintStyle: const TextStyle(
                                                    color: Color(0xFF666666),
                                                    fontSize: 12),
                                                onChanged: (val) {
                                                  if (val.isNotEmpty) {
                                                    setState(() {
                                                      isTyping.value = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isTyping.value = false;
                                                    });
                                                  }
                                                },
                                                prefixIcon: GestureDetector(
                                                  onTap: () async {
                                                    focusNode.unfocus();
                                                    focusNode.canRequestFocus =
                                                        false;
                                                    setState(() {
                                                      emojiShowing =
                                                          !emojiShowing;
                                                    });
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/svgs/emoji.svg',
                                                  ).paddingAll(10),
                                                ),
                                                suffixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
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
                                                                Column(
                                                                    children: [
                                                                      ListTile(
                                                                        leading:
                                                                            SvgPicture.asset(
                                                                          'assets/svgs/Camera.svg',
                                                                          color:
                                                                              AppColors.black,
                                                                        ),
                                                                        title: const Text(
                                                                            'Camera'),
                                                                        onTap:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                          final image =
                                                                              await getImage(ImageSource.camera);
                                                                          if (image !=
                                                                              null) {
                                                                            globals.chatBloc!.add(UploadImageFileEvent(file: image));
                                                                          }
                                                                        },
                                                                      ),
                                                                      ListTile(
                                                                        leading:
                                                                            SvgPicture.asset('assets/svgs/gallery.svg'),
                                                                        title: const Text(
                                                                            'Gallery'),
                                                                        onTap:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                          final image =
                                                                              await getImage(ImageSource.gallery);
                                                                          if (image !=
                                                                              null) {
                                                                            globals.chatBloc!.add(UploadImageFileEvent(file: image));
                                                                          }
                                                                        },
                                                                      ),
                                                                    ]).paddingSymmetric(
                                                                    v: 5),
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
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _soundRecorder!
                                                          .closeRecorder();
                                                      setState(() {
                                                        isRecording = false;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  Align(
                                                    child: StreamBuilder<
                                                        RecordingDisposition>(
                                                      stream: _soundRecorder!
                                                          .onProgress,
                                                      builder:
                                                          (context, snapshot) {
                                                        final duration =
                                                            snapshot.hasData
                                                                ? snapshot.data!
                                                                    .duration
                                                                : Duration.zero;

                                                        String twoDigits(
                                                                int n) =>
                                                            n
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0');
                                                        final twoDigitMinutes =
                                                            twoDigits(duration
                                                                .inMinutes
                                                                .remainder(60));
                                                        final twoDigitSeconds =
                                                            twoDigits(duration
                                                                .inSeconds
                                                                .remainder(60));
                                                        return Text(
                                                          '$twoDigitMinutes: $twoDigitSeconds',
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              color: AppColors
                                                                  .primaryColor),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )),
                                    const SizedBox(width: 7),
                                    isTyping.value
                                        ? GestureDetector(
                                            onTap: () {
                                              if (controller.text.isNotEmpty) {
                                                final value =
                                                    controller.text.trim();

                                                Chat temp = Chat(
                                                    senderId: globals.user!.id,
                                                    type: 'text',
                                                    value:
                                                        controller.text.trim());
                                                globals.userChat!.add(temp);
                                                controller.clear();

                                                SchedulerBinding.instance
                                                    .addPostFrameCallback(
                                                  (_) {
                                                    _controller.animateTo(
                                                      _controller.position
                                                          .maxScrollExtent,
                                                      duration: const Duration(
                                                          milliseconds: 10),
                                                      curve: Curves.easeOut,
                                                    );
                                                  },
                                                );

                                                globals.chatBloc!.add(
                                                  SendChatMessageEvent(
                                                    senderId: globals.user!.id,
                                                    receiverId: widget
                                                        .recipientUser!.id,
                                                    threadId:
                                                        '${globals.user!.id}--${widget.recipientUser!.id}',
                                                    value: value,
                                                    type: 'text',
                                                  ),
                                                );
                                                isSending.value = true;
                                                showIsSending.value = true;
                                              } else {
                                                controller.clear();
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
                                            onTap: () async {
                                              var tempDir =
                                                  await getTemporaryDirectory();
                                              var path =
                                                  '${tempDir.path}/flutter_sound.aac';
                                              if (!isRecordingInit) {
                                                return;
                                              }
                                              if (isRecording) {
                                                await _soundRecorder!
                                                    .stopRecorder();
                                                print(path);
                                                File audioMessage = File(path);

                                                globals.chatBloc!.add(
                                                    UploadImageFileEvent(
                                                        file: audioMessage));
                                              } else {
                                                await _soundRecorder!
                                                    .startRecorder(
                                                  toFile: path,
                                                );
                                              }
                                              setState(() {
                                                isRecording = !isRecording;
                                              });
                                            },
                                            child: !isRecording
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/mic.svg',
                                                      width: 25,
                                                      height: 25,
                                                      color: AppColors.white,
                                                    ),
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/send.svg',
                                                      width: 25,
                                                      height: 25,
                                                      color: AppColors.white,
                                                    ))),
                                  ]).paddingOnly(r: 15, l: 15, b: 15, t: 10),
                                  Offstage(
                                    offstage: !emojiShowing,
                                    child: SizedBox(
                                        height: 230,
                                        child: EmojiPicker(
                                          textEditingController: controller,
                                          config: const Config(
                                            columns: 7,
                                          ),
                                          onEmojiSelected: (category, emoji) {
                                            controller
                                              ..text += emoji.emoji
                                              ..selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset: controller
                                                              .text.length));
                                            if (!isTyping.value) {
                                              setState(() {
                                                isTyping.value =
                                                    !isTyping.value;
                                              });
                                            }
                                            setState(() {
                                              controller.text = controller.text;
                                            });
                                          },
                                        )),
                                  )
                                  //const Spacer(),
                                ],
                              ),
                              //  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onWillPop: () {
                      if (emojiShowing) {
                        setState(() {
                          emojiShowing = false;
                        });
                      } else {
                        RouteNavigators.pop(context);
                      }
                      return Future.value(false);
                    });
            //);
          }),
    );
  }

  /*Widget showemoji() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onBackspacePressed: () {
          RouteNavigators.pop(context);
        },
        textEditingController: controller,
        config: Config(
          columns: 7,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: const Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ), // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
        onEmojiSelected: (category, emoji) {
          setState(() {
            controller.text = controller.text;
          });
          if (!isTyping) {
            setState(() {
              isTyping = !isTyping;
            });
          }
        },
      ),
    );
  }*/
}
