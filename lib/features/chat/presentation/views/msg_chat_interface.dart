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
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
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
import 'package:reach_me/features/call/presentation/views/initiate_audio_call.dart';
import 'package:reach_me/features/call/presentation/views/initiate_video_call.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/chat/presentation/widgets/audio_player.dart';
import 'package:reach_me/features/chat/presentation/widgets/msg_bubble.dart';

import '../../../../core/components/snackbar.dart';

class MsgChatInterface extends StatefulHookWidget {
  static const String id = 'msg_chat_interface';
  const MsgChatInterface(
      {Key? key, this.recipientUser, this.thread, this.quotedData})
      : super(key: key);
  final User? recipientUser;
  final ChatsThread? thread;
  final String? quotedData;

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
  bool isPaused = false;
  TimerController timerController = TimerController();

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
      // globals.chatBloc!.add(GetThreadMessagesEvent(
      //     id: '${globals.user!.id}--${widget.recipientUser!.id}'));
      globals.chatBloc!.add(GetThreadMessagesEvent(
          threadId: widget.thread?.id, receiverId: widget.recipientUser?.id));
    });
    if (widget.quotedData != null) {
      focusNode.requestFocus();
    }
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
        .setSubscriptionDuration(const Duration(milliseconds: 100));
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
    final isUploading = useState<bool>(false);
    final showIsSending = useState<bool>(false);
    final controller = useTextEditingController();
    final _quotedData = useState(widget.quotedData);
    useEffect(() {
      globals.chatBloc!.add(GetThreadMessagesEvent(
          threadId: widget.thread?.id, receiverId: widget.recipientUser?.id));
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
                RouteNavigators.route(context,
                    InitiateVideoCall(recipient: widget.recipientUser));
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
                RouteNavigators.route(context,
                    InitiateAudioCall(recipient: widget.recipientUser));
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
              _controller.jumpTo(_controller.position.maxScrollExtent);
            }

            if (state is ChatSendSuccess) {
              isSending.value = false;
              showIsSending.value = false;
              _quotedData.value = null;
              // _controller.jumpTo(_controller.position.maxScrollExtent);

            }
            if (state is UserUploadingImage) {
              toast('Uploading media...',
                  duration: const Duration(milliseconds: 1000));
            }

            if (state is ChatUploadError) {
              Snackbars.error(context, message: 'Media Upload Error');
            }

            if (state is ChatUploadSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.easeOut,
                );
              });
              toast('Uploading media...',
                  duration: const Duration(milliseconds: 300));
              globals.chatBloc!.add(SendChatMessageEvent(
                  senderId: globals.user!.id,
                  receiverId: widget.recipientUser!.id,
                  threadId: widget.thread?.id,
                  value: state.imgUrl,
                  type: 'image',
                  quotedData: _quotedData.value,
                  messageMode: _quotedData.value == null
                      ? MessageMode.direct.name
                      : MessageMode.quoted.name));
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        itemBuilder: (c, i) => MsgBubble(
                                              msgDate: '',
                                              isMe: globals.user!.id ==
                                                  globals.userChat![i].senderId,
                                              label:
                                                  globals.userChat![i].value!,
                                              size: size,
                                              quotedData: globals
                                                  .userChat![i].quotedData,
                                              timeStamp: Helper.parseChatTime(
                                                  globals.userChat![i].sentAt ??
                                                      ''),
                                              chat: globals.userChat![i],
                                            ),
                                        separatorBuilder: (c, i) =>
                                            const SizedBox(
                                              height: 10,
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
                                      fontSize: getScreenHeight(8),
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
                                  Visibility(
                                    visible: _quotedData.value != null,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.0),
                                          border: const Border(
                                              top: BorderSide(
                                                  color: AppColors.greyShade5,
                                                  width: 1))),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 0),
                                            child: Row(
                                              children: [
                                                const Expanded(
                                                  child: Text(
                                                    'Reaching out to a post...',
                                                    style: TextStyle(
                                                        color: AppColors.black),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () => _quotedData
                                                        .value = null,
                                                    child:
                                                        const Icon(Icons.close))
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 8,
                                          // ),
                                          const Divider(
                                            color: AppColors.greyShade5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              Chat(
                                                          quotedData:
                                                              _quotedData.value)
                                                      .quotedContent ??
                                                  '',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: AppColors.greyShade1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    Flexible(
                                      child: !isRecording
                                          ? CustomRoundTextField(
                                              focusNode: focusNode,
                                              controller: controller,
                                              fillColor: AppColors.white,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
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
                                                mainAxisSize: MainAxisSize.min,
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
                                                              Column(children: [
                                                                ListTile(
                                                                  leading:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/svgs/Camera.svg',
                                                                    color: AppColors
                                                                        .black,
                                                                  ),
                                                                  title: const Text(
                                                                      'Camera'),
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    final image =
                                                                        await getImage(
                                                                            ImageSource.camera);
                                                                    if (image !=
                                                                        null) {
                                                                      globals
                                                                          .chatBloc!
                                                                          .add(UploadImageFileEvent(
                                                                              file: image));
                                                                    }
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  leading: SvgPicture
                                                                      .asset(
                                                                          'assets/svgs/gallery.svg'),
                                                                  title: const Text(
                                                                      'Gallery'),
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    final image =
                                                                        await getImage(
                                                                            ImageSource.gallery);
                                                                    if (image !=
                                                                        null) {
                                                                      globals
                                                                          .chatBloc!
                                                                          .add(UploadImageFileEvent(
                                                                              file: image));
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
                                          : Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _soundRecorder!
                                                          .stopRecorder();

                                                      setState(() {
                                                        isRecording = false;
                                                        timerController
                                                            .resetTimer();
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  TimerWidget(
                                                      controller:
                                                          timerController),
                                                  // Align(
                                                  //   child: StreamBuilder<
                                                  //       RecordingDisposition>(
                                                  //     stream: _soundRecorder!
                                                  //         .onProgress,
                                                  //     builder:
                                                  //         (context, snapshot) {
                                                  //       final duration =
                                                  //           snapshot.hasData
                                                  //               ? snapshot.data!
                                                  //                   .duration
                                                  //               : Duration.zero;

                                                  //       print(duration
                                                  //           .inMilliseconds);

                                                  //       String twoDigits(
                                                  //               int n) =>
                                                  //           n
                                                  //               .toString()
                                                  //               .padLeft(
                                                  //                   2, '0');
                                                  //       final twoDigitMinutes =
                                                  //           twoDigits(duration
                                                  //               .inMinutes
                                                  //               .remainder(60));
                                                  //       final twoDigitSeconds =
                                                  //           twoDigits(duration
                                                  //               .inSeconds
                                                  //               .remainder(60));
                                                  //       return Text(
                                                  //         '$twoDigitMinutes: $twoDigitSeconds',
                                                  //         style: const TextStyle(
                                                  //             fontSize: 20,
                                                  //             color: AppColors
                                                  //                 .primaryColor),
                                                  //       );
                                                  //     },
                                                  //   ),
                                                  // ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (!isPaused) {
                                                          _soundRecorder!
                                                              .pauseRecorder();

                                                          setState(() {
                                                            timerController
                                                                .startTimer();
                                                            isPaused =
                                                                !isPaused;
                                                          });
                                                        } else {
                                                          _soundRecorder!
                                                              .resumeRecorder();

                                                          setState(() {
                                                            isPaused =
                                                                !isPaused;

                                                            timerController
                                                                .pauseTimer();
                                                          });
                                                        }
                                                      },
                                                      child: isPaused
                                                          ? const Icon(
                                                              Icons.mic,
                                                              size: 30,
                                                              color: AppColors
                                                                  .primaryColor,
                                                            )
                                                          : const Icon(
                                                              Icons.pause,
                                                              size: 30,
                                                              color: AppColors
                                                                  .primaryColor,
                                                            )),
                                                ],
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 6),
                                    isTyping.value
                                        ? GestureDetector(
                                            onTap: () {
                                              if (controller.text.isNotEmpty) {
                                                final value =
                                                    controller.text.trim();

                                                Chat temp = Chat(
                                                    senderId: globals.user!.id,
                                                    type: 'text',
                                                    quotedData:
                                                        widget.quotedData,
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
                                                      senderId:
                                                          globals.user!.id,
                                                      receiverId: widget
                                                          .recipientUser!.id,
                                                      threadId:
                                                          widget.thread?.id,
                                                      value: value,
                                                      type: 'text',
                                                      quotedData:
                                                          _quotedData.value,
                                                      messageMode:
                                                          _quotedData.value ==
                                                                  null
                                                              ? MessageMode
                                                                  .direct.name
                                                              : MessageMode
                                                                  .quoted.name),
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

                                                setState(() {
                                                  timerController.resetTimer();
                                                });
                                              } else {
                                                await _soundRecorder!
                                                    .startRecorder(
                                                  toFile: path,
                                                );
                                              }
                                              setState(() {
                                                timerController.startTimer();
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
                                      height: 227,
                                      child: EmojiPicker(
                                        textEditingController: controller,
                                        config: Config(
                                            columns: 7,
                                            emojiSizeMax: 28 *
                                                (Platform.isIOS ? 1.30 : 1.0),
                                            verticalSpacing: 0,
                                            horizontalSpacing: 0,
                                            gridPadding: EdgeInsets.zero,
                                            initCategory: Category.RECENT,
                                            bgColor: Colors.white,
                                            indicatorColor:
                                                Theme.of(context).primaryColor,
                                            iconColor: Colors.grey,
                                            iconColorSelected:
                                                Theme.of(context).primaryColor,
                                            backspaceColor:
                                                Theme.of(context).primaryColor,
                                            skinToneDialogBgColor: Colors.white,
                                            skinToneIndicatorColor: Colors.grey,
                                            enableSkinTones: true,
                                            showRecentsTab: true,
                                            recentsLimit: 32,
                                            noRecents: const Text(
                                              'Pas d\'émojis récents',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black26),
                                              textAlign: TextAlign.center,
                                            )),
                                        onEmojiSelected: (category, emoji) {
                                          if (!isTyping.value) {
                                            setState(() {
                                              isTyping.value = !isTyping.value;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
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
}
