import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as permit;
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/dtos/create.repost.input.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/components/snackbar.dart';
import '../../../../core/models/file_result.dart';
import '../../../../core/services/audio_recording_service.dart';
import '../../../../core/services/media_service.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/regex_util.dart';
import '../../../account/presentation/views/account.dart';
import '../../../account/presentation/widgets/bottom_sheets.dart';
import '../../../dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import '../../../dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import '../../../dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import '../../../dictionary/presentation/views/add_to_glossary.dart';
import '../../../dictionary/presentation/widgets/view_words_dialog.dart';
import '../../../moment/moment_audio_player.dart';
import '../../../profile/new_account.dart';
import '../../../profile/recipientNewAccountProfile.dart';
import '../../../timeline/timeline_feed.dart';
import '../../../timeline/video_player.dart';
import '../../data/models/comment_model.dart';
import '../bloc/social-service-bloc/ss_bloc.dart';
import '../bloc/user-bloc/user_bloc.dart';
import '../widgets/post_media.dart';
import '../widgets/post_reach_media.dart';

class RepostReach extends StatefulHookWidget {
  final PostFeedModel? postFeedModel;
  const RepostReach({required this.postFeedModel, Key? key}) : super(key: key);

  @override
  State<RepostReach> createState() => _RepostReachState();
}

class _RepostReachState extends State<RepostReach> {
  Future<File?> getImage(ImageSource source) async {
    final _picker = ImagePicker();

    try {
      final imageFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
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

  void openAudio() async {
    final status = await permit.Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecordingInit = true;
  }

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
  }

  FlutterSoundRecorder? _soundRecorder;

  bool isRecordingInit = false;
  bool isRecording = false;

  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();

  // final isTyping = useState<bool>(false);
  // useEffect(() {
  //   globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
  //       postId: widget.postFeedModel.postId, pageLimit: 50, pageNumber: 1));
  //   return null;
  // }, []);

  @override
  void dispose() {
    super.dispose();
    _soundRecorder!.closeRecorder();
    isRecordingInit = false;
    focusNode.dispose();
  }
  // final _imageList = useState<List<UploadFileDto>>([]);

  String getUserLoation() {
    if (globals.user!.showLocation!) {
      if (globals.location == 'nil' || globals.location == "NIL") {
        return '';
      }
      return globals.location!;
    } else {
      return '';
    }
  }

  GlobalKey<FlutterMentionsState> controllerKey =
      GlobalKey<FlutterMentionsState>();
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  String postRating = "normal";
  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(widget.postFeedModel!.post!.createdAt!);
    var size = MediaQuery.of(context).size;
    final counter = useState(0);
    final controller = useTextEditingController();
    final replyFeature = useState("everyone");
    final _mediaList = useState<List<UploadFileDto>>([]);
    final isTyping = useState<bool>(false);

    final triggerProgressIndicator = useState(true);
    final comments = useState<List<CommentModel>>([]);
    final scrollController = useScrollController();
    //final  post = widget.postFeedModel.post;
    int nAudios =
        _mediaList.value.where((e) => FileUtils.isAudio(e.file)).length;
    int nVideos =
        _mediaList.value.where((e) => FileUtils.isVideo(e.file)).length;
    final AudioRecordingService _recordingService = AudioRecordingService();
    final _isLoading = useState<bool>(true);
    final _recentWords = useState<List<Map<String, dynamic>>>([]);
    final _mentionUsers = useState<List<Map<String, dynamic>>>([]);
    final _mentionList = useState<List<String>?>([]);

    useMemoized(() {
      globals.dictionaryBloc!
          .add(AddWordsToMentionsEvent(pageLimit: 1000, pageNumber: 1));
    });

    useMemoized(() {
      globals.userBloc!.add(FetchUserReachingsEvent(
          pageLimit: 50, pageNumber: 1, authId: globals.userId));
    });

    return BlocListener<SocialServiceBloc, SocialServiceState>(
        bloc: globals.socialServiceBloc,
        listener: (context, state) {
          if (state is CreateRepostSuccess) {
            timeLineFeedStore.initialize(isQuoting: true);
            // globals.socialServiceBloc!
            //     .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
            // Navigator.pop(context);
          }
          if (state is CreateRepostError) {
            Snackbars.error(context, message: state.error);
          }
          if (state is CreateRepostLoading) {
            toast('Quoting reach...',
                duration: const Duration(milliseconds: 100));
          }

          if (state is UploadMediaSuccess) {
            List<String> mediaUrls = state.data as List<String>;
            List<String> imageUrls = mediaUrls
                .where((e) => FileUtils.fileType(e) == 'image')
                .toList();
            String videoUrl = mediaUrls.firstWhere(
                (e) => FileUtils.fileType(e) == 'video',
                orElse: () => '');
            String audioUrl = mediaUrls.firstWhere(
                (e) => FileUtils.fileType(e) == 'audio',
                orElse: () => '');
            globals.socialServiceBloc!.add(CreateRepostEvent(
                input: CreateRepostInput(
                    repostedPostId: widget.postFeedModel!.postId,
                    repostedPostOwnerId: widget.postFeedModel!.postOwnerId,
                    content: controllerKey.currentState!.controller!.text,
                    imageMediaItems: imageUrls.isNotEmpty ? imageUrls : null,
                    videoMediaItem: videoUrl.isNotEmpty ? videoUrl : null,
                    audioMediaItem: audioUrl.isNotEmpty ? audioUrl : null,
                    location:
                        globals.user!.showLocation! ? globals.location! : 'nil',
                    postRating: postRating,
                    mentionList: _mentionList.value,
                    commentOption: replyFeature.value)));
          }
          if (state is UploadMediaError) {
            Snackbars.error(context, message: state.error);
          }
        },
        child: SafeArea(
          child: WillPopScope(
            child: Scaffold(
                body: Stack(
              children: [
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        IconButton(
                          icon: const Icon(Icons.close, size: 17),
                          padding: EdgeInsets.zero,
                          splashColor: Colors.transparent,
                          splashRadius: 20,
                          constraints: const BoxConstraints(),
                          onPressed: () => RouteNavigators.pop(context),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: FittedBox(
                            child: RichText(
                                text: TextSpan(
                                    text: 'Reply to ',
                                    style: const TextStyle(
                                        color: AppColors.textColor5,
                                        fontSize: 16),
                                    children: [
                                  TextSpan(
                                    text: '@${widget.postFeedModel!.username}',
                                    style: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16),
                                  )
                                ])),
                          ),
                        )
                      ]),
                      IconButton(
                        icon: SvgPicture.asset('assets/svgs/send.svg'),
                        onPressed: () {
                          if (controllerKey
                                  .currentState!.controller!.text.isNotEmpty ||
                              _mediaList.value.isNotEmpty) {
                            if (_mediaList.value.isNotEmpty) {
                              globals.socialServiceBloc!.add(
                                  UploadPostMediaEvent(
                                      media: _mediaList.value));

                              setState(() {
                                _mentionList.value = controllerKey
                                    .currentState!.controller!.text.mentions;
                              });

                              // globals.mentionList!.add(controllerKey
                              //     .currentState!.controller!.markupText);

                              debugPrint(
                                  "Mention: ${controllerKey.currentState!.controller!.markupText}");

                              setState(() {});
                            } else {
                              setState(() {
                                _mentionList.value = controllerKey
                                    .currentState!.controller!.text.mentions;
                              });
                              globals.socialServiceBloc!.add(CreateRepostEvent(
                                  input: CreateRepostInput(
                                      repostedPostId:
                                          widget.postFeedModel!.postId,
                                      repostedPostOwnerId:
                                          widget.postFeedModel!.postOwnerId,
                                      content: controllerKey
                                          .currentState!.controller!.text,
                                      location: globals.user!.showLocation!
                                          ? globals.location!
                                          : 'nil',
                                      postRating: postRating,
                                      mentionList: _mentionList.value,
                                      commentOption: replyFeature.value)));
                            }
                          }
                          controller.clear();
                        },
                      ),
                    ],
                  ).paddingSymmetric(h: 16),
                ),
                Container(
                  width: size.width,
                  height: size.height,
                  margin: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: size.height,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Helper.renderProfilePicture(
                                        globals.user!.profilePicture,
                                        size: 38,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (globals.user!.firstName! +
                                                        ' ' +
                                                        globals.user!.lastName!)
                                                    .toTitleCase(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textColor2,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: 93,
                                                  child: Text(
                                                    getUserLoation(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        decoration: BoxDecoration(
                                            color: AppColors.greyShade9,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: AppColors.greyShade9)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: const [
                                            Icon(
                                              Icons.location_on,
                                              size: 12,
                                            ),
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  color: AppColors.blackShade5,
                                                  fontFamily: "Poppins",
                                                  fontSize: 11),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        counter.value.toString() + '/' + '200',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: counter.value == 200
                                              ? Colors.red
                                              : AppColors.textColor2,
                                        ),
                                      ),
                                    ],
                                  ).paddingSymmetric(h: 16),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.028,
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    width: size.width,
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: AppColors.greyShade10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CupertinoButton(
                                              minSize: 0,
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                final progress =
                                                    ProgressHUD.of(context);
                                                progress?.showWithText(
                                                    'Viewing Reacher...');
                                                Future.delayed(
                                                    const Duration(seconds: 3),
                                                    () {
                                                  globals.userBloc!.add(
                                                      GetRecipientProfileEvent(
                                                          email: widget
                                                              .postFeedModel!
                                                              .postOwnerId));
                                                  widget.postFeedModel!
                                                              .postOwnerId ==
                                                          globals.user!.id
                                                      ? RouteNavigators.route(
                                                          context,
                                                          const NewAccountScreen())
                                                      : RouteNavigators.route(
                                                          context,
                                                          RecipientAccountProfile(
                                                            recipientEmail:
                                                                'email',
                                                            recipientImageUrl: widget
                                                                .postFeedModel!
                                                                .profilePicture,
                                                            recipientId: widget
                                                                .postFeedModel!
                                                                .postOwnerId,
                                                          ));
                                                  progress?.dismiss();
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Helper.renderProfilePicture(
                                                    widget.postFeedModel!
                                                        .profilePicture,
                                                    size: 40,
                                                  ).paddingOnly(l: 13, t: 10),
                                                  SizedBox(
                                                      width: getScreenWidth(9)),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '@${widget.postFeedModel!.username!}',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  getScreenHeight(
                                                                      14),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .textColor2,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 3),
                                                          widget.postFeedModel!
                                                                  .verified!
                                                              ? SvgPicture.asset(
                                                                  'assets/svgs/verified.svg')
                                                              : const SizedBox
                                                                  .shrink()
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            widget.postFeedModel!.post!.location! == 'nil' ||
                                                                    widget.postFeedModel!.post!
                                                                            .location! ==
                                                                        'NIL' ||
                                                                    widget
                                                                            .postFeedModel!
                                                                            .post!
                                                                            .location ==
                                                                        null
                                                                ? ''
                                                                : widget
                                                                            .postFeedModel!
                                                                            .post!
                                                                            .location!
                                                                            .length >
                                                                        23
                                                                    ? widget
                                                                        .postFeedModel!
                                                                        .post!
                                                                        .location!
                                                                        .substring(
                                                                            0,
                                                                            23)
                                                                    : widget
                                                                        .postFeedModel!
                                                                        .post!
                                                                        .location!,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  getScreenHeight(
                                                                      10),
                                                              fontFamily:
                                                                  'Poppins',
                                                              letterSpacing:
                                                                  0.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .textColor2,
                                                            ),
                                                          ),
                                                          Text(
                                                            postDuration,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  getScreenHeight(
                                                                      10),
                                                              fontFamily:
                                                                  'Poppins',
                                                              letterSpacing:
                                                                  0.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .textColor2,
                                                            ),
                                                          ).paddingOnly(l: 6),
                                                        ],
                                                      )
                                                    ],
                                                  ).paddingOnly(t: 10),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        widget.postFeedModel!.post!.content ==
                                                null
                                            ? const SizedBox.shrink()
                                            : ExpandableText(
                                                "${widget.postFeedModel!.post!.content}",
                                                prefixText: widget
                                                        .postFeedModel!
                                                        .post!
                                                        .edited!
                                                    ? "(Reach Edited ${Helper.parseUserLastSeen(widget.postFeedModel!.post!.updatedAt.toString())})"
                                                    : null,
                                                prefixStyle: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(12),
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColors.primaryColor),
                                                onPrefixTap: () {
                                                  tooltipkey.currentState
                                                      ?.ensureTooltipVisible();
                                                },
                                                expandText: 'see more',
                                                maxLines: 3,
                                                linkColor: Colors.blue,
                                                animation: true,
                                                expanded: false,
                                                collapseText: 'see less',
                                                onHashtagTap: (value) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return DictionaryDialog(
                                                          abbr: value,
                                                          meaning: '',
                                                          word: '',
                                                        );
                                                      });
                                                },
                                                onMentionTap: (value) {
                                                  timeLineFeedStore
                                                      .getUserByUsername(
                                                          context,
                                                          username: value);

                                                  debugPrint("Value $value");
                                                },
                                                mentionStyle: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue),
                                                hashtagStyle: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue),
                                              ).paddingSymmetric(h: 16, v: 10),
                                        if ((widget.postFeedModel?.post
                                                    ?.imageMediaItems ??
                                                [])
                                            .isNotEmpty)
                                          PostMedia(
                                                  post: widget
                                                      .postFeedModel!.post!)
                                              .paddingOnly(
                                                  r: 16, l: 16, b: 16, t: 10)
                                        else
                                          const SizedBox.shrink(),
                                        if ((widget.postFeedModel?.post
                                                    ?.videoMediaItem ??
                                                '')
                                            .isNotEmpty)
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            child: TimeLineVideoPlayer(
                                                post:
                                                    widget.postFeedModel!.post!,
                                                videoUrl: widget.postFeedModel!
                                                    .post!.videoMediaItem!),
                                          )
                                        else
                                          const SizedBox.shrink(),
                                        (widget.postFeedModel?.post
                                                        ?.audioMediaItem ??
                                                    '')
                                                .isNotEmpty
                                            ? Container(
                                                height: 59,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                width: SizeConfig.screenWidth,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color(
                                                        0xfff5f5f5)),
                                                child: Row(children: [
                                                  Expanded(
                                                      child: MomentAudioPlayer(
                                                    audioPath: widget
                                                        .postFeedModel!
                                                        .post!
                                                        .audioMediaItem!,
                                                  )),
                                                ]),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  const Divider(
                                      color: Color(0xFFEBEBEB), thickness: 0.5),

                                  BlocConsumer<DictionaryBloc, DictionaryState>(
                                    bloc: globals.dictionaryBloc,
                                    listener: (context, state) {
                                      if (state is GetWordToMentionsSuccess) {
                                        _recentWords.value = state.mentionsData
                                            .map((item) => {
                                                  "id": item["authId"],
                                                  "display": item["abbr"],
                                                  "meaning": item["meaning"],
                                                })
                                            .toList();

                                        _isLoading.value = false;
                                      }

                                      if (state is LoadingWordsToMentions) {
                                        _isLoading.value = true;
                                      }
                                      if (state is GetWordToMentionsError) {
                                        Snackbars.error(context,
                                            message: state.error);
                                      }
                                    },
                                    builder: (context, state) {
                                      return Flexible(
                                        child: FlutterMentions(
                                          autofocus: true,
                                          key: controllerKey,
                                          maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
                                          maxLength: 1100,
                                          // minLines: null,
                                          focusNode: focusNode,

                                          suggestionPosition:
                                              SuggestionPosition.Bottom,
                                          onChanged: (val) {
                                            counter.value = val
                                                .trim()
                                                .split(RegexUtil.spaceOrNewLine)
                                                .length;
                                            if (counter.value >= 200) {
                                              Snackbars.error(context,
                                                  message:
                                                      '200 words limit reached!');
                                              // setState(() {
                                              //   showCursor = false;
                                              //   enabled = false;
                                              // });
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            counterText: '',
                                            hintText: "Quote this reach",
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.greyShade1,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                          mentions: [
                                            Mention(
                                                trigger: "#",
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                ),
                                                data: _recentWords.value,
                                                matchAll: false,
                                                suggestionBuilder: (data) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: _isLoading.value
                                                        ? const CircularProgressIndicator()
                                                        : _recentWords
                                                                .value.isEmpty
                                                            ? TextButton(
                                                                onPressed: () {
                                                                  RouteNavigators
                                                                      .route(
                                                                          context,
                                                                          const AddToGlossary());
                                                                },
                                                                child: const Text(
                                                                    'Add to glossary'))
                                                            : Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 20.0,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        '#${data['display']}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.blueAccent),
                                                                      ),
                                                                      Text(
                                                                        data[
                                                                            'meaning'],
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // IconButton(
                                                                  //   onPressed: () {},
                                                                  //   icon: const Icon(Icons.add),
                                                                  // ),
                                                                ],
                                                              ),
                                                  );
                                                }),
                                            Mention(
                                                trigger: "@",
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                ),
                                                data: _mentionUsers.value,
                                                matchAll: false,
                                                suggestionBuilder: (data) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: _isLoading.value
                                                        ? const CircularProgressIndicator()
                                                        : _mentionUsers
                                                                .value.isEmpty
                                                            ? const SizedBox
                                                                .shrink()
                                                            : Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 20.0,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        '${data['display']}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.blueAccent),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // IconButton(
                                                                  //   onPressed: () {},
                                                                  //   icon: const Icon(Icons.add),
                                                                  // ),
                                                                ],
                                                              ),
                                                  );
                                                }),
                                          ],
                                          // child: TextField(
                                          //   maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                          //   minLines: 1,
                                          //   maxLines: null,
                                          //   controller: controller,
                                          //   inputFormatters: [
                                          //     MaxWordTextInputFormater(maxWords: 200)
                                          //   ],
                                          //   // maxLength: 200,
                                          //   onChanged: (val) {
                                          //     counter.value =
                                          //         val.trim().split(RegexUtil.spaceOrNewLine).length;
                                          //     if (counter.value >= 200) {
                                          //       Snackbars.error(context,
                                          //           message: '200 words limit reached!');
                                          //     }
                                          //   },
                                          //   decoration: const InputDecoration(
                                          //     counterText: '',
                                          //     hintText: "What's on your mind?",
                                          //     hintStyle: TextStyle(
                                          //       fontSize: 14,
                                          //       fontWeight: FontWeight.w400,
                                          //       color: AppColors.greyShade1,
                                          //     ),
                                          //     border: InputBorder.none,
                                          //     contentPadding: EdgeInsets.symmetric(
                                          //       horizontal: 16,
                                          //       vertical: 10,
                                          //     ),
                                          //   ),
                                          // ).paddingSymmetric(h: 16),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 10),
                                  if (_mediaList.value.isNotEmpty)
                                    PostReachMediaGrid(
                                      mediaList: _mediaList.value
                                          .where((e) =>
                                              FileUtils.isImage(e.file) ||
                                              FileUtils.isVideo(e.file))
                                          .toList(),
                                      onUpdateList: (val) {
                                        if (val.length !=
                                            _mediaList.value.length) {
                                          _mediaList.value = val;
                                        }
                                      },
                                      onRemove: (index) {
                                        _mediaList.value = [..._mediaList.value]
                                          ..removeAt(index);
                                      },
                                    ).paddingSymmetric(h: 16)
                                  else
                                    const SizedBox.shrink(),
                                  if (_mediaList.value.indexWhere(
                                          (e) => FileUtils.isAudio(e.file)) >=
                                      0)
                                    PostReachAudioMedia(
                                      margin: const EdgeInsets.all(16),
                                      path: _mediaList
                                          .value[_mediaList.value.indexWhere(
                                              (e) => FileUtils.isAudio(e.file))]
                                          .file
                                          .path,
                                      onCancel: () {
                                        int pos = _mediaList.value.indexWhere(
                                            (e) => FileUtils.isAudio(e.file));
                                        _mediaList.value = [..._mediaList.value]
                                          ..removeAt(pos);
                                      },
                                    )
                                  else
                                    const SizedBox.shrink(),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height * 0.4,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        // margin: const EdgeInsets.only(top: 210),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        color: const Color(0xFFF5F5F5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                    builder: (context) {
                                      return ListView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 27,
                                            vertical: 10,
                                          ),
                                          children: [
                                            Container(
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: AppColors.greyShade5
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ).paddingSymmetric(
                                                h: size.width / 2.7),
                                            SizedBox(
                                                height: getScreenHeight(21)),
                                            Center(
                                              child: Text(
                                                'Who can reply',
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(16),
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: getScreenHeight(5)),
                                            Center(
                                              child: Text(
                                                'Identify who can reply to this reach.',
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(14),
                                                  color: AppColors.greyShade3,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: getScreenHeight(20)),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  replyFeature.value =
                                                      'everyone';
                                                  RouteNavigators.pop(context);
                                                });
                                              },
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                minLeadingWidth: 14,
                                                leading: SvgPicture.asset(
                                                    'assets/svgs/world.svg'),
                                                title: Text(
                                                  'Everyone can reply',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(16),
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: getScreenHeight(10)),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  replyFeature.value =
                                                      'people_you_follow';
                                                });
                                                RouteNavigators.pop(context);
                                              },
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                minLeadingWidth: 14,
                                                leading: SvgPicture.asset(
                                                    'assets/svgs/people-you-follow.svg'),
                                                title: Text(
                                                  'People reaching you',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(16),
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: getScreenHeight(10)),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  replyFeature.value =
                                                      'only_people_you_mention';
                                                });
                                                RouteNavigators.pop(context);
                                              },
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                minLeadingWidth: 14,
                                                leading: SvgPicture.asset(
                                                    'assets/svgs/people-you-mention.svg'),
                                                title: Text(
                                                  'Only people you mention',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(16),
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: getScreenHeight(10)),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  replyFeature.value = 'none';
                                                });
                                                RouteNavigators.pop(context);
                                              },
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                minLeadingWidth: 14,
                                                leading: SvgPicture.asset(
                                                    'assets/svgs/none.svg'),
                                                title: Text(
                                                  'None',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(16),
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]);
                                    });
                              },
                              child: replyWidget(replyFeature.value),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      focusNode.unfocus();
                                      focusNode.canRequestFocus = false;
                                      setState(() {
                                        emojiShowing = !emojiShowing;
                                      });
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  icon:
                                      SvgPicture.asset('assets/svgs/emoji.svg'),
                                  splashColor: Colors.transparent,
                                  splashRadius: 20,
                                  constraints: const BoxConstraints(),
                                ),

                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: ((context, setState) {
                                                return ListView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 27,
                                                      vertical: 10,
                                                    ),
                                                    children: [
                                                      Container(
                                                        height: 4,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .greyShade5
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ).paddingSymmetric(
                                                          h: size.width / 2.7),
                                                      SizedBox(
                                                          height:
                                                              getScreenHeight(
                                                                  21)),
                                                      Center(
                                                        child: Text(
                                                          'Content warning',
                                                          style: TextStyle(
                                                            fontSize:
                                                                getScreenHeight(
                                                                    16),
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              getScreenHeight(
                                                                  5)),
                                                      Center(
                                                        child: Text(
                                                          "Select a category and we'll put a content warning. This helps people avoid content they don't want to see",
                                                          style: TextStyle(
                                                            fontSize:
                                                                getScreenHeight(
                                                                    14),
                                                            color: AppColors
                                                                .greyShade3,
                                                          ),
                                                        ),
                                                      ),
                                                      RadioListTile(
                                                        title: const Text(
                                                            'Nudity'),
                                                        value: 'Nudity',
                                                        groupValue: postRating,
                                                        activeColor: AppColors
                                                            .primaryColor,
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            postRating = value!;
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile(
                                                        title: const Text(
                                                            'Graphic Violence'),
                                                        value:
                                                            'Graphic Violence',
                                                        activeColor: AppColors
                                                            .primaryColor,
                                                        groupValue: postRating,
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            postRating = value!;
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile(
                                                        title: const Text(
                                                            'Sensitive'),
                                                        value: 'Sensitive',
                                                        activeColor: AppColors
                                                            .primaryColor,
                                                        groupValue: postRating,
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            postRating = value!;
                                                          });
                                                        },
                                                      ),
                                                    ]);
                                              }),
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.flag)),

                                IconButton(
                                  onPressed: () async {
                                    final res = await showMediaUploadOption(
                                        context: context,
                                        iconPath1: 'assets/svgs/Camera.svg',
                                        iconPath2: 'assets/svgs/gallery.svg',
                                        title1: 'Camera',
                                        title2: 'Gallery');
                                    if (res == null) return;
                                    List<FileResult>? media;
                                    if (res == 1) {
                                      final cMedia = await MediaService()
                                          .pickFromCamera(
                                              enableRecording: true,
                                              context: context);
                                      media = cMedia != null ? [cMedia] : null;
                                    } else {
                                      media = await MediaService()
                                          .pickFromGallery(
                                              context: context, maxAssets: 15);
                                    }

                                    if (media == null) return;
                                    int total = media.length;
                                    // int noOfVideos = media
                                    //     .where((e) => FileUtils.isVideo(e.file))
                                    //     .length;
                                    // int noOfImages = media
                                    //     .where((e) => FileUtils.isImage(e.file))
                                    //     .length;

                                    if ((_mediaList.value.length + total) >
                                        15) {
                                      Snackbars.error(context,
                                          message:
                                              'Sorry, you cannot add more than 15 media');
                                      return;
                                    }

                                    if (nVideos > 0) {
                                      Snackbars.error(context,
                                          message:
                                              'Sorry, you cannot add more than one video media');
                                      return;
                                    }
                                    for (var e in media) {
                                      _mediaList.value.add(UploadFileDto(
                                          file: e.file,
                                          fileResult: e,
                                          id: Random()
                                              .nextInt(100)
                                              .toString()));
                                    }
                                    setState(() {});
                                  },
                                  splashColor: Colors.transparent,
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: SvgPicture.asset(
                                      'assets/svgs/gallery.svg'),
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 20),
                                // IconButton(
                                //   //constraints: const BoxConstraints(
                                //   // maxHeight: 25, maxWidth: 25),
                                //   onPressed: () async {
                                //     setState(() {
                                //       isRecording = !isRecording;
                                //     });
                                //     var tempDir = await getTemporaryDirectory();
                                //     var path = '${tempDir.path}/flutter_sound.aac';

                                //     if (!isRecordingInit) {
                                //       return;
                                //     }
                                //     if (isRecording) {
                                //       await _soundRecorder!.stopRecorder();
                                //       print(path);
                                //       File audioMessage = File(path);

                                //       /*globals.chatBloc!.add(
                                //                                 UploadImageFileEvent(
                                //                                     file: audioMessage));*/
                                //     } else {
                                //       await _soundRecorder!.startRecorder(
                                //         toFile: path,
                                //       );
                                //     }
                                //   },
                                //   icon: !isRecording
                                //       ? SvgPicture.asset(
                                //           'assets/svgs/mic.svg',
                                //           color: AppColors.blackShade3,
                                //           width: 20,
                                //           height: 26,
                                //         )
                                //       : SvgPicture.asset(
                                //           'assets/svgs/dc-cancel.svg',
                                //           color: AppColors.blackShade3,
                                //           height: 20,
                                //           width: 20,
                                //         ),
                                //   constraints: const BoxConstraints(),
                                // ),

                                PopupMenuButton(
                                  onSelected: (value) async {
                                    if ((_mediaList.value.length + 1) > 15) {
                                      Snackbars.error(context,
                                          message:
                                              'Sorry, you cannot add more than 15 media');
                                      return;
                                    }
                                    if (nAudios > 0) {
                                      Snackbars.error(context,
                                          message:
                                              'Sorry, you cannot add more than one audio media');
                                      return;
                                    }
                                    if (value == null) return;
                                    if (value == 1) {
                                      final media = await MediaService()
                                          .getAudio(context: context);
                                      if (media == null) return;
                                      if (!FileUtils.isAudio(media.file)) {
                                        Snackbars.error(context,
                                            message:
                                                'Audio format not supported!');
                                        return;
                                      }
                                      //  Console.log('<<<PATH>>', media.path);
                                      _mediaList.value.add(UploadFileDto(
                                          file: media.file,
                                          fileResult: media,
                                          id: Random()
                                              .nextInt(100)
                                              .toString()));
                                      setState(() {});
                                    } else if (value == 2) {
                                      _recordingService.record(
                                          fileName: 'post_reach_aud.aac');
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                          'Upload',
                                          style:
                                              TextStyle(color: AppColors.black),
                                        )),
                                    const PopupMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Record',
                                          style:
                                              TextStyle(color: AppColors.black),
                                        )),
                                  ],
                                  child:
                                      SvgPicture.asset('assets/svgs/mic.svg'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Offstage(
                          offstage: !emojiShowing,
                          child: SizedBox(
                            height: 227,
                            child: EmojiPicker(
                              textEditingController: controller,
                              config: Config(
                                  columns: 7,
                                  emojiSizeMax:
                                      28 * (Platform.isIOS ? 1.30 : 1.0),
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
                                        fontSize: 20, color: Colors.black26),
                                    textAlign: TextAlign.center,
                                  )),
                              onEmojiSelected: (category, emoji) {
                                controllerKey.currentState!.controller!.text +=
                                    emoji.emoji;
                                setState(() {
                                  controllerKey.currentState!.controller!.text =
                                      controllerKey
                                          .currentState!.controller!.text;
                                });
                                if (!isTyping.value) {
                                  setState(() {
                                    isTyping.value = !isTyping.value;
                                  });
                                }
                              },
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            )),
            onWillPop: () {
              if (emojiShowing) {
                setState(() {
                  emojiShowing = false;
                });
              } else {
                RouteNavigators.pop(context);
              }
              return Future.value(false);
            },
          ),
        ));
  }

  Widget replyWidget(String replyFeature) {
    switch (replyFeature) {
      case 'everyone':
        return Row(
          children: [
            SvgPicture.asset('assets/svgs/world.svg', height: 30),
            const SizedBox(width: 9),
            const Text(
              'Everyone can reply',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor2,
              ),
            ),
          ],
        );

      case 'people_you_follow':
        return Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/people-you-follow.svg',
              height: 30,
            ),
            const SizedBox(width: 9),
            const Text(
              'People you follow',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor2,
              ),
            ),
          ],
        );

      case 'only_people_you_mention':
        return Row(
          children: [
            SvgPicture.asset('assets/svgs/people-you-mention.svg', height: 30),
            const SizedBox(width: 9),
            const Text(
              'Only people you mention',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor2,
              ),
            ),
          ],
        );

      case 'none':
        return Row(
          children: [
            SvgPicture.asset('assets/svgs/none.svg', height: 30),
            const SizedBox(width: 9),
            const Text(
              'None',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor2,
              ),
            ),
          ],
        );

      default:
        return Row(
          children: [
            SvgPicture.asset('assets/svgs/world.svg', height: 30),
            const SizedBox(width: 9),
            const Text(
              'Everyone can reply',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor2,
              ),
            ),
          ],
        );
    }
  }
}
