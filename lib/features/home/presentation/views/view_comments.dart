import 'dart:io';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/media_service.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/file_utils.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:reach_me/features/home/presentation/views/comment_reach.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:reach_me/features/home/presentation/widgets/comment_media.dart';
//import 'package:reach_me/features/home/presentation/widgets/post_media.dart';

import '../../../../core/models/file_result.dart';
import '../../../chat/presentation/widgets/audio_player.dart';
import '../widgets/post_media.dart';

class ViewCommentsScreen extends StatefulHookWidget {
  static String id = 'view_comments_screen';
  const ViewCommentsScreen({Key? key, required this.post}) : super(key: key);

  final PostFeedModel post;

  @override
  State<ViewCommentsScreen> createState() => _ViewCommentsScreenState();
}

class _ViewCommentsScreenState extends State<ViewCommentsScreen> {
  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();
  late final RecorderController recorderController;
//FlutterSoundRecorder? _soundRecorder;
  bool isRecordingInit = false;
  bool isRecording = false;
  Set active = {};

  handleTap(index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _initialiseController();
    //_soundRecorder = FlutterSoundRecorder();
    //openAudio();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _soundRecorder!.closeRecorder();
    isRecordingInit = false;
    recorderController.dispose();
  }

/*void openAudio() async {
  final status = await permit.Permission.microphone.request();
  if (status != PermissionStatus.granted) {
    throw RecordingPermissionException('Mic permission not allowed');
  }
  await _soundRecorder!.openRecorder();
  isRecordingInit = true;
}*/

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatLinearPCM
      ..sampleRate = 16000;
  }

  @override
  Widget build(BuildContext context) {
    final reachDM = useState(false);
    final controller = useTextEditingController();
    final triggerProgressIndicator = useState(true);
    final comments = useState<List<CommentModel>>([]);
    final commentLike = useState<CommentLikeModel?>(null);
    final scrollController = useScrollController();
    final isTyping = useState<bool>(false);
    final imageList = useState<List<UploadFileDto>>([]);

    useEffect(() {
      globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
          postId: widget.post.postId, pageLimit: 50, pageNumber: 1));
      return null;
    }, []);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, statee) {
            if (statee is RecipientUserData) {
              if (reachDM.value) {
                RouteNavigators.route(
                    context, MsgChatInterface(recipientUser: statee.user));
              }
              reachDM.value = false;
            }
            if (statee is UserError) {
              reachDM.value = false;
              Snackbars.error(context, message: statee.error);
            }
          },
          builder: (context, statee) {
            return BlocConsumer<SocialServiceBloc, SocialServiceState>(
                bloc: globals.socialServiceBloc,
                listener: (context, state) {
                  if (state is CommentOnPostSuccess) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 10),
                        curve: Curves.easeOut,
                      );
                    });

                    Snackbars.success(context,
                        message: "Your commment has been posted");
                    triggerProgressIndicator.value = false;
                    globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
                        postId: widget.post.postId,
                        pageLimit: 50,
                        pageNumber: 1));
                  }
                  if (state is CommentOnPostError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is CommentOnPostLoading) {
                    toast('Posting comment...',
                        duration: const Duration(milliseconds: 100));
                  }
                  if (state is GetAllCommentsOnPostSuccess) {
                    comments.value = state.data!.reversed.toList();
                  }

                  if (state is GetAllCommentsOnPostError) {
                    Snackbars.error(context, message: state.error);
                  }

                  //if (state is UnlikeCommentOnPostSuccess ||
                  // state is LikeCommentOnPostSuccess) {
                  //globals.socialServiceBloc!.add(GetAllCommentLikesEvent(
                  //  commentId: comments.value[index].commentId));

                  //}

                  if (state is LikeCommentOnPostSuccess) {
                    commentLike.value = state.commentLikeModel;
                  }

                  if (state is UnlikeCommentOnPostSuccess) {
                    // commentUnlike.value = state.unlikeComment;
                    //isLiked.value = false;
                  }

                  if (state is MediaUploadSuccess) {
                    String? audioUrl = state.image!;
                    globals.socialServiceBloc!.add(CommentOnPostEvent(
                        content: ' ',
                        postId: widget.post.postId,
                        userId: globals.user!.id,
                        audioMediaItem: audioUrl.isNotEmpty ? audioUrl : null,
                        postOwnerId: widget.post.postOwnerId));
                  }
                  if (state is UploadMediaSuccess) {
                    List<String> mediaUrls = state.data as List<String>;
                    List<String> imageUrls = mediaUrls
                        .where((e) => FileUtils.fileType(e) == 'image')
                        .toList();
                    globals.socialServiceBloc!.add(CommentOnPostEvent(
                        content: ' ',
                        postId: widget.post.postId,
                        userId: globals.user!.id,
                        imageMediaItems:
                            imageUrls.isNotEmpty ? imageUrls : null,
                        postOwnerId: widget.post.postOwnerId));
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is GetAllCommentsOnPostLoading;
                  print('${commentLike.value}');
                  return WillPopScope(
                    child: ProgressHUD(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => RouteNavigators.pop(context),
                                icon: Transform.rotate(
                                  angle: 3.142,
                                  child: const Icon(
                                    Icons.arrow_right_alt,
                                  ),
                                ),
                              ),
                              Text(
                                'View comments',
                                style: TextStyle(
                                  fontSize: getScreenHeight(16),
                                  color: AppColors.textColor2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Opacity(
                                opacity: 0,
                                child: IconButton(
                                  onPressed: null,
                                  icon: Transform.rotate(
                                    angle: 3.142,
                                    child: const Icon(
                                      Icons.arrow_right_alt,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).paddingSymmetric(h: 16),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, bottom: 20, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppColors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Helper.renderProfilePicture(
                                      widget.post.profilePicture,
                                      size: 35,
                                    ),
                                    SizedBox(width: getScreenHeight(12)),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '@${widget.post.username!}',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(15),
                                            color: AppColors.textColor2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        widget.post.location == null
                                            ? const SizedBox.shrink()
                                            : Text(
                                                '',
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(12),
                                                  color: AppColors.textColor2
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: getScreenHeight(12)),
                                widget.post.post!.content == null
                                    ? const SizedBox()
                                    : Text(
                                        widget.post.post!.content!,
                                        style: TextStyle(
                                          fontSize: getScreenHeight(14),
                                          color: AppColors.textColor2,
                                        ),
                                      ),
                                if ((widget.post.post!.imageMediaItems ?? [])
                                    .isNotEmpty)
                                  Helper.renderPostImages(
                                          widget.post.post!, context)
                                      .paddingOnly(r: 16, l: 16, b: 16, t: 10)
                                else
                                  const SizedBox(),
                              ],
                            ),
                          ).paddingOnly(t: 16, b: 7, r: 20, l: 20),
                          const SizedBox(height: 20),
                          if (isLoading && triggerProgressIndicator.value)
                            const Expanded(child: CupertinoActivityIndicator())
                          else
                            Expanded(
                              child: comments.value.isEmpty
                                  ? const Center(child: Text('No comments yet'))
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      itemCount: comments.value.length,
                                      itemBuilder: (context, index) {
                                        // if (comments
                                        //         .value[index].audioMediaItem ==
                                        //     null) {
                                        //   comments.value[index].audioMediaItem =
                                        //       ' ';
                                        // }
                                        return CommentsTile(
                                          comment: comments.value[index],
                                          isLiked:
                                              comments.value[index].isLiked ??
                                                      false
                                                  ? true
                                                  : false,
                                          onLike: () {
                                            print(
                                                "${comments.value[index].isLiked}");
                                            HapticFeedback.mediumImpact();
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              if (comments
                                                  .value[index].isLiked!) {
                                                comments.value[index].isLiked =
                                                    false;

                                                comments.value[index].nLikes =
                                                    (comments.value[index]
                                                                .nLikes ??
                                                            1) -
                                                        1;
                                                globals.socialServiceBloc!.add(
                                                  UnlikeCommentOnPostEvent(
                                                    commentId: comments
                                                        .value[index]
                                                        .commentId!,
                                                    likeId: commentLike
                                                        .value!.likeId!,
                                                  ),
                                                );
                                              } else {
                                                comments.value[index].isLiked =
                                                    true;
                                                comments.value[index].nLikes =
                                                    (comments.value[index]
                                                                .nLikes ??
                                                            0) +
                                                        1;
                                                globals.socialServiceBloc!
                                                    .add(LikeCommentOnPostEvent(
                                                  postId: comments
                                                      .value[index].postId,
                                                  commentId: comments
                                                      .value[index].commentId,
                                                ));
                                              }
                                            }
                                          },
                                          onMessage: () {
                                            HapticFeedback.mediumImpact();
                                            reachDM.value = true;
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.userBloc!.add(
                                                  GetRecipientProfileEvent(
                                                      email: comments
                                                          .value[index]
                                                          .authId!));
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),
                          Container(
                            color: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 4,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              isTyping.value = true;
                                            } else {
                                              isTyping.value = false;
                                            }
                                          },
                                          focusNode: focusNode,
                                          controller: controller,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Comment as ${globals.user!.username!}...',
                                            hintStyle: TextStyle(
                                                fontSize: getScreenHeight(14)),
                                            suffixIcon: GestureDetector(
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
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                /* final image =
                                                                await getImage(
                                                                    ImageSource
                                                                        .camera);
                                                            if (image != null) {
                                                              globals.chatBloc!.add(
                                                                  UploadImageFileEvent(
                                                                      file:
                                                                          image));
                                                            }*/
                                                              }),
                                                          ListTile(
                                                            leading: SvgPicture
                                                                .asset(
                                                                    'assets/svgs/gallery.svg'),
                                                            title: const Text(
                                                                'Gallery'),
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              final image = await MediaService()
                                                                  .pickFromGallery(
                                                                      context:
                                                                          context,
                                                                      maxAssets:
                                                                          5);
                                                              if (image ==
                                                                  null) {
                                                                return;
                                                              }

                                                              if (image !=
                                                                  null) {
                                                                for (var e
                                                                    in image) {
                                                                  imageList.value.add(UploadFileDto(
                                                                      file: e
                                                                          .file,
                                                                      fileResult:
                                                                          e,
                                                                      id: Random()
                                                                          .nextInt(
                                                                              100)
                                                                          .toString()));
                                                                }
                                                              }
                                                              globals
                                                                  .socialServiceBloc!
                                                                  .add(UploadPostMediaEvent(
                                                                      media: imageList
                                                                          .value));

                                                              /*globals.socialServiceBloc!.add(CommentOnPostEvent(
                                                                  postId: widget
                                                                      .post
                                                                      .postId,
                                                                  content: " ",
                                                                  userId:
                                                                      globals
                                                                          .user!
                                                                          .id,
                                                                  postOwnerId:
                                                                      widget
                                                                          .post
                                                                          .postOwnerId
                                                                  // imageMediaItems: image.
                                                                  ));*/
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
                                                //width: 25,
                                                //height: 20,
                                              ).paddingAll(10),
                                            ),
                                            prefixIcon: !isRecording
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Helper
                                                          .renderProfilePicture(
                                                        globals.user!
                                                            .profilePicture,
                                                        size: 35,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      GestureDetector(
                                                        onTap: () {
                                                          focusNode.unfocus();
                                                          focusNode
                                                                  .canRequestFocus =
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
                                                    ],
                                                  )
                                                : AudioWaveforms(
                                                    size: Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                        20),
                                                    recorderController:
                                                        recorderController,
                                                    enableGesture: true,
                                                    waveStyle: const WaveStyle(
                                                      waveColor: Colors.black,
                                                      extendWaveform: true,
                                                      showMiddleLine: false,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      color: Colors.grey,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18,
                                                            right: 20,
                                                            top: 15,
                                                            bottom: 15),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                  ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            border: null,
                                            focusedErrorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      isTyping.value
                                          ? IconButton(
                                              icon: SvgPicture.asset(
                                                  'assets/svgs/send.svg'),
                                              onPressed: () {
                                                if (controller
                                                    .text.isNotEmpty) {
                                                  globals.socialServiceBloc!
                                                      .add(CommentOnPostEvent(
                                                          postId: widget
                                                              .post.postId,
                                                          content:
                                                              controller.text,
                                                             userId:
                                                              globals.user!.id,
                                                          postOwnerId: widget
                                                              .post
                                                              .postOwnerId));
                                                }
                                                controller.clear();
                                              },
                                            )
                                          : IconButton(
                                              //constraints: const BoxConstraints(
                                              // maxHeight: 25, maxWidth: 25),
                                              onPressed: () async {
                                                print('BUTTON WORKING');
                                                /* var tempDir =
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

                                                        /*globals.chatBloc!.add(
                                                            UploadImageFileEvent(
                                                                file: audioMessage));*/
                                                      } else {
                                                        await _soundRecorder!
                                                            .startRecorder(
                                                          toFile: path,
                                                        );
                                                      }
                                                      setState(() {
                                                        isRecording = !isRecording;

                                                      });*/
                                                var tempDir =
                                                    await getTemporaryDirectory();
                                                String? path =
                                                    '${tempDir.path}/comment_sound.aac';

                                                if (isRecording) {
                                                  path =
                                                      await recorderController
                                                          .stop();
                                                  File audio = File(path!);
                                                  /* globals.socialServiceBloc!
                                                      .add(CommentOnPostEvent(
                                                          content: " ",
                                                          audioMediaItem:
                                                              audio.path,
                                                          postId: widget
                                                              .post.postId,
                                                          userId:
                                                              globals.user!.id!,
                                                          postOwnerId: widget
                                                              .post
                                                              .postOwnerId));*/
                                                  globals.socialServiceBloc!
                                                      .add(MediaUploadEvent(
                                                          media: audio));

                                                  print(path);
                                                } else {
                                                  await recorderController
                                                      .record(path);
                                                }

                                                setState(() {
                                                  isRecording = !isRecording;
                                                });
                                              },
                                              icon: !isRecording
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/mic.svg',
                                                      color:
                                                          AppColors.blackShade3,
                                                      width: 20,
                                                      height: 26,
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/svgs/dc-cancel.svg',
                                                      color:
                                                          AppColors.blackShade3,
                                                      height: 20,
                                                      width: 20,
                                                    )),
                                    ],
                                  ),
                                ),
                                Offstage(
                                  offstage: !emojiShowing,
                                  child: SizedBox(
                                    height: 250,
                                    child: EmojiPicker(
                                      textEditingController: controller,
                                      config: const Config(
                                        columns: 7,
                                      ),
                                      onEmojiSelected: (category, emoji) {
                                        setState(() {
                                          controller.text = controller.text;
                                        });
                                        if (!isTyping.value) {
                                          setState(() {
                                            isTyping.value = !isTyping.value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ).paddingOnly(t: 10)
                        ],
                      ).paddingOnly(t: 30),
                    ),
                    onWillPop: (() {
                      if (emojiShowing) {
                        setState(() {
                          emojiShowing = false;
                        });
                      } else {
                        RouteNavigators.pop(context);
                      }
                      return Future.value(false);
                    }),
                  );
                });
          }),
    );
  }
}

class AltViewCommentsScreen extends StatefulHookWidget {
  static String id = 'view_comments_screen';
  const AltViewCommentsScreen({Key? key, required this.post}) : super(key: key);

  final PostModel post;

  @override
  State<AltViewCommentsScreen> createState() => _AltViewCommentsScreenState();
}

class _AltViewCommentsScreenState extends State<AltViewCommentsScreen> {
  Set active = {};

  handleTap(index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reachDM = useState(false);
    final controller = useTextEditingController();
    final triggerProgressIndicator = useState(true);
    final comments = useState<List<CommentModel>>([]);
    final scrollController = useScrollController();
    useEffect(() {
      globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
          postId: widget.post.postId, pageLimit: 50, pageNumber: 1));
      return null;
    }, []);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, statee) {
            if (statee is RecipientUserData) {
              if (reachDM.value) {
                RouteNavigators.route(
                    context, MsgChatInterface(recipientUser: statee.user));
              }
              reachDM.value = false;
            }
            if (statee is UserError) {
              reachDM.value = false;
              Snackbars.error(context, message: statee.error);
            }
          },
          builder: (context, statee) {
            return BlocConsumer<SocialServiceBloc, SocialServiceState>(
                bloc: globals.socialServiceBloc,
                listener: (context, state) {
                  if (state is CommentOnPostSuccess) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 10),
                        curve: Curves.easeOut,
                      );
                    });
                    Snackbars.success(context,
                        message: "Your commment has been posted");
                    triggerProgressIndicator.value = false;
                    globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
                        postId: widget.post.postId,
                        pageLimit: 50,
                        pageNumber: 1));
                  }
                  if (state is CommentOnPostError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is CommentOnPostLoading) {
                    toast('Posting comment...',
                        duration: const Duration(milliseconds: 100));
                  }
                  if (state is GetAllCommentsOnPostSuccess) {
                    comments.value = state.data!.reversed.toList();
                  }

                  if (state is GetAllCommentsOnPostError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is UnlikeCommentOnPostSuccess ||
                      state is LikeCommentOnPostSuccess) {
                    globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
                        postId: widget.post.postId,
                        pageLimit: 50,
                        pageNumber: 1));
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is GetAllCommentsOnPostLoading;

                  return ProgressHUD(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => RouteNavigators.pop(context),
                              icon: Transform.rotate(
                                angle: 3.142,
                                child: const Icon(
                                  Icons.arrow_right_alt,
                                ),
                              ),
                            ),
                            Text(
                              'View comments',
                              style: TextStyle(
                                fontSize: getScreenHeight(16),
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Opacity(
                              opacity: 0,
                              child: IconButton(
                                onPressed: null,
                                icon: Transform.rotate(
                                  angle: 3.142,
                                  child: const Icon(
                                    Icons.arrow_right_alt,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(h: 16),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, bottom: 20, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Helper.renderProfilePicture(
                                    widget
                                        .post.postOwnerProfile!.profilePicture,
                                    size: 35,
                                  ),
                                  SizedBox(width: getScreenHeight(12)),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '@${widget.post.postOwnerProfile!.username!}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          color: AppColors.textColor2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      widget.post.location == null
                                          ? const SizedBox.shrink()
                                          : Text(
                                              '',
                                              style: TextStyle(
                                                fontSize: getScreenHeight(12),
                                                color: AppColors.textColor2
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: getScreenHeight(12)),
                              widget.post.content == null
                                  ? const SizedBox()
                                  : Text(
                                      widget.post.content!,
                                      style: TextStyle(
                                        fontSize: getScreenHeight(14),
                                        color: AppColors.textColor2,
                                      ),
                                    ),
                              if (widget.post.imageMediaItems!.isNotEmpty)
                                Helper.renderPostImages(widget.post, context)
                                    .paddingOnly(r: 16, l: 16, b: 16, t: 10)
                              else
                                const SizedBox(),
                            ],
                          ),
                        ).paddingOnly(t: 16, b: 7, r: 20, l: 20),
                        const SizedBox(height: 20),
                        if (isLoading && triggerProgressIndicator.value)
                          const Expanded(child: CupertinoActivityIndicator())
                        else
                          Expanded(
                            child: comments.value.isEmpty
                                ? const Center(child: Text('No comments yet'))
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    itemCount: comments.value.length,
                                    itemBuilder: (context, index) {
                                      return CommentsTile(
                                        comment: comments.value[index],
                                        isLiked: comments
                                                .value[index].like!.isNotEmpty
                                            ? true
                                            : false,
                                        onLike: () {
                                          HapticFeedback.mediumImpact();
                                          handleTap(index);
                                          if (active.contains(index)) {
                                            if (comments.value[index].like!
                                                .isNotEmpty) {
                                              globals.socialServiceBloc!
                                                  .add(UnlikeCommentOnPostEvent(
                                                commentId: comments
                                                    .value[index].commentId!,
                                                likeId: comments
                                                    .value[index].postId!,
                                              ));
                                            } else {
                                              globals.socialServiceBloc!.add(
                                                LikeCommentOnPostEvent(
                                                  postId: comments
                                                      .value[index].postId,
                                                  commentId: comments
                                                      .value[index].commentId,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        onMessage: () {
                                          HapticFeedback.mediumImpact();
                                          reachDM.value = true;
                                          handleTap(index);
                                          if (active.contains(index)) {
                                            globals.userBloc!.add(
                                                GetRecipientProfileEvent(
                                                    email: comments
                                                        .value[index].authId!));
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ),
                        Container(
                          color: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText:
                                  'Comment as ${globals.user!.username!}...',
                              hintStyle:
                                  TextStyle(fontSize: getScreenHeight(14)),
                              suffixIcon: IconButton(
                                icon: SvgPicture.asset('assets/svgs/send.svg'),
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    globals.socialServiceBloc!.add(
                                        CommentOnPostEvent(
                                            postId: widget.post.postId,
                                            content: controller.text,
                                            userId: globals.user!.id,
                                            postOwnerId: widget.post.authId));
                                    controller.clear();
                                  }
                                },
                              ),
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Helper.renderProfilePicture(
                                    globals.user!.profilePicture,
                                    size: 35,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              border: null,
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ).paddingOnly(t: 10)
                      ],
                    ).paddingOnly(t: 30),
                  );
                });
          }),
    );
  }
}

class CommentsTile extends StatelessWidget {
  const CommentsTile({
    Key? key,
    required this.comment,
    this.onLike,
    this.onMessage,
    required this.isLiked,
  }) : super(key: key);
  final Function()? onLike, onMessage;
  final CommentModel comment;
  final bool isLiked;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 14,
          right: 14,
          bottom: 20,
          top: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                final progress = ProgressHUD.of(context);
                progress?.showWithText('Viewing Reacher..');
                Future.delayed(const Duration(seconds: 3), () {
                  globals.userBloc!
                      .add(GetRecipientProfileEvent(email: comment.authId));
                  comment.authId == globals.user!.id
                      ? RouteNavigators.route(context, const AccountScreen())
                      : RouteNavigators.route(
                          context,
                          RecipientAccountProfile(
                            recipientEmail: 'email',
                            recipientImageUrl:
                                comment.commentOwnerProfile!.profilePicture,
                            recipientId: comment.authId,
                          ));
                  progress?.dismiss();
                });
              },
              child: Row(
                children: [
                  Helper.renderProfilePicture(
                    comment.commentOwnerProfile!.profilePicture,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${comment.commentOwnerProfile!.username!}',
                        style: TextStyle(
                          fontSize: getScreenHeight(15),
                          fontFamily: 'Poppins',
                          color: AppColors.textColor2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: getScreenHeight(12)),
            if (comment.content!.isNotEmpty)
              Text(
                comment.content!,
                style: TextStyle(
                  fontSize: getScreenHeight(14),
                  color: AppColors.textColor2,
                ),
              ),
            // if (comment.audioMediaItem!.isNotEmpty)
            //   PostAudioMedia(path: comment.audioMediaItem!)
            //   //PlayAudio(
            //     //audioFile: comment.audioMediaItem!,
            //     //isMe: true,
            //   //)
            //              .paddingOnly(r: 16, l: 16, b: 10, t: 0)
            // else if (comment.imageMediaItems!.isNotEmpty)
            //   CommentMedia(comment: comment)
            //       .paddingOnly(l: 16, r: 16, b: 10, t: 0)
            // else
            //   const SizedBox.shrink(),
            SizedBox(height: getScreenHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFF5F5F5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          onPressed: onLike,
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: isLiked
                              ? SvgPicture.asset(
                                  'assets/svgs/like-active.svg',
                                  height: getScreenHeight(20),
                                  width: getScreenWidth(20),
                                )
                              : SvgPicture.asset(
                                  'assets/svgs/like.svg',
                                  height: getScreenHeight(20),
                                  width: getScreenWidth(20),
                                ),
                        ),
                        SizedBox(width: getScreenWidth(4)),
                        FittedBox(
                          child: Text(
                            comment.nLikes.toString(),
                            style: TextStyle(
                              fontSize: getScreenHeight(12),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor3,
                            ),
                          ),
                        ),
                        if (comment.authId != globals.user!.id!)
                          SizedBox(width: getScreenWidth(15)),
                        if (comment.authId != globals.user!.id!)
                          CupertinoButton(
                            onPressed: onMessage,
                            minSize: 0,
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              'assets/svgs/message.svg',
                              height: getScreenHeight(20),
                              width: getScreenWidth(20),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: getScreenWidth(20)),
              ],
            )
          ],
        )).paddingOnly(b: 10, r: 20, l: 20);
  }
}
