import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/audio_recording_service.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/core/utils/regex_util.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/views/add_to_glossary.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/widgets/post_reach_media.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';

import '../../../../core/models/file_result.dart';
import '../../../../core/services/media_service.dart';
import '../../../../core/utils/file_utils.dart';
import '../../core/utils/location.helper.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/post_reach.dart';

class TimeLinePostReach extends StatefulHookWidget {
  const TimeLinePostReach({Key? key}) : super(key: key);

  @override
  State<TimeLinePostReach> createState() => _TimeLinePostReachState();
}

class _TimeLinePostReachState extends State<TimeLinePostReach> {
  bool nudity = false;
  bool graphicViolence = false;
  bool sensitive = false;
  String postRating = "normal";
  bool showCursor = true;
  bool enabled = true;
  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();
  GlobalKey<FlutterMentionsState> controllerKey =
      GlobalKey<FlutterMentionsState>();

  // final ScrollController _controller = ScrollController();
  // bool _isPlaying = false;
  // final _soundRecorderController = RecorderController()
  //   ..androidEncoder = AndroidEncoder.aac
  //   ..androidOutputFormat = AndroidOutputFormat.aac_adts
  //   ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
  //   ..sampleRate = 16000;

  final AudioRecordingService _recordingService = AudioRecordingService();

// This is what you're looking for!
//   void _scrollDown() {
//     _controller.animateTo(
//       _controller.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 1),
//       curve: Curves.fastOutSlowIn,
//     );
//     // _controller.jumpTo(_controller.position.maxScrollExtent);
//   }

  @override
  void initState() {
    super.initState();
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
    focusNode.dispose();
  }

  int maxCount = 11000;
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

  @override
  Widget build(BuildContext context) {
    final _isLoading = useState<bool>(true);
    final _recentWords = useState<List<Map<String, dynamic>>>([]);
    final _mentionUsers = useState<List<Map<String, dynamic>>>([]);
    final _mentionList = useState<List<String>?>([]);
    final isTyping = useState<bool>(false);
    useMemoized(() {
      globals.dictionaryBloc!
          .add(AddWordsToMentionsEvent(pageLimit: 1000, pageNumber: 1));
    });

    useMemoized(() async {
      globals.userBloc!.add(FetchUserReachingsEvent(
          pageLimit: 50, pageNumber: 1, authId: globals.userId));
      LocationData _locationData = await LocationHelper.determineLocation();
      debugPrint("LocationData ${_locationData.latitude.toString()}");
      globals.userBloc!.add(GetUserLocationEvent(
          lat: _locationData.latitude.toString(),
          lng: _locationData.longitude.toString()));
    });

    var size = MediaQuery.of(context).size;
    final counter = useState(0);

    final controller = useTextEditingController();
    final replyFeature = useState("everyone");

    final _mediaList = useState<List<UploadFileDto>>([]);
    int nVideos =
        _mediaList.value.where((e) => FileUtils.isVideo(e.file)).length;
    int nAudios =
        _mediaList.value.where((e) => FileUtils.isAudio(e.file)).length;
    int nImages =
        _mediaList.value.where((e) => FileUtils.isImage(e.file)).length;
    // final _imageList = useState<List<UploadFileDto>>([]);
    String getUserLocation() {
      if (globals.user!.showLocation == true) {
        return globals.location!;
      } else {
        return 'NIL';
      }
    }

    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is GetUserLocationSuccess) {
              globals.location = state.location;
            }
          },
          bloc: globals.userBloc,
          builder: (context, state) {
            return WillPopScope(
              child: SafeArea(
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 17),
                                        padding: EdgeInsets.zero,
                                        splashColor: Colors.transparent,
                                        splashRadius: 20,
                                        constraints: const BoxConstraints(),
                                        onPressed: () =>
                                            RouteNavigators.pop(context),
                                      ),
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Create a reach',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                        'assets/svgs/send.svg'),
                                    onPressed: () {
                                      if (controllerKey.currentState!
                                              .controller!.text.isNotEmpty ||
                                          _mediaList.value.isNotEmpty) {
                                        ///////
                                        if (_mediaList.value.isNotEmpty) {
                                          timeLineFeedStore.createMediaPost(
                                              context,
                                              mediaList: _mediaList.value);
                                          setState(() {
                                            _mentionList.value = controllerKey
                                                .currentState!
                                                .controller!
                                                .text
                                                .mentions;
                                          });
                                          globals.postContent = controllerKey
                                              .currentState!.controller!.text;
                                          globals.postCommentOption =
                                              replyFeature.value;
                                          globals.postRating = postRating;
                                          globals.mentionList =
                                              _mentionList.value;

                                          // globals.mentionList!.add(controllerKey
                                          //     .currentState!.controller!.markupText);

                                          debugPrint(
                                              "Mention: ${controllerKey.currentState!.controller!.markupText}");

                                          setState(() {});
                                        }
                                        //////
                                        else {
                                          setState(() {
                                            _mentionList.value = controllerKey
                                                .currentState!
                                                .controller!
                                                .text
                                                .mentions;
                                          });

                                          debugPrint(
                                              "Mentions Value List: ${_mentionList.value}");
                                          globals.socialServiceBloc!.add(
                                              CreatePostEvent(
                                                  content: controllerKey
                                                      .currentState!
                                                      .controller!
                                                      .text,
                                                  commentOption:
                                                      replyFeature.value,
                                                  location: getUserLocation(),
                                                  postRating: postRating,
                                                  mentionList:
                                                      _mentionList.value));
                                          debugPrint(
                                              "Mention: ${controllerKey.currentState!.controller!.markupText}");
                                          debugPrint(
                                              "Mention: ${controllerKey.currentState!.controller!.text}");
                                        }
                                      }
                                    },
                                  ),
                                ]).paddingSymmetric(h: 16),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Helper.renderProfilePicture(
                                      globals.user!.profilePicture,
                                      size: 33,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                        Text(
                                          '${getUserLocation().toLowerCase().trim().toString() == 'nil' ? '' : globals.location}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.greyShade1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // GestureDetector(
                                    //   onTap: () => RouteNavigators.route(
                                    //       context, const TagLocation()),
                                    //   child: Container(
                                    //     padding: const EdgeInsets.all(3),
                                    //     decoration: BoxDecoration(
                                    //       color: const Color(0xFFF5F5F5),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Row(
                                    //       children: [
                                    //         SvgPicture.asset(
                                    //             'assets/svgs/location.svg'),
                                    //         const Text(
                                    //           '   Location',
                                    //           style: TextStyle(
                                    //             fontSize: 12,
                                    //             fontWeight: FontWeight.w500,
                                    //             color: AppColors.textColor2,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
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
                                ),
                              ],
                            ).paddingSymmetric(h: 16),
                            const SizedBox(height: 20),
                            const Divider(
                                color: Color(0xFFEBEBEB), thickness: 0.5),
                            BlocListener<UserBloc, UserState>(
                              bloc: globals.userBloc,
                              listener: (context, userState) {
                                if (userState is FetchUserReachingsSuccess) {
                                  if (userState.reachings != null) {
                                    _mentionUsers.value = userState.reachings!
                                        .map((reachings) => {
                                              "id": reachings.reachingId,
                                              "display":
                                                  reachings.reaching!.username
                                            })
                                        .toList();
                                  }

                                  _isLoading.value = false;
                                }
                              },
                              child:
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
                                  return FlutterMentions(
                                    key: controllerKey,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    maxLength: maxCount,
                                    focusNode: focusNode,
                                    suggestionPosition:
                                        SuggestionPosition.Bottom,
                                    onChanged: (val) {
                                      counter.value = val
                                          .trim()
                                          .split(RegexUtil.spaceOrNewLine)
                                          .length;
                                      if (counter.value == 200) {
                                        setState(() {
                                          maxCount = val.length;
                                        });
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
                                      hintText: "What's on your mind?",
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.greyShade1,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
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
                                                  const EdgeInsets.all(10.0),
                                              child: _isLoading.value
                                                  ? const CircularProgressIndicator()
                                                  : _recentWords.value.isEmpty
                                                      ? TextButton(
                                                          onPressed: () {
                                                            RouteNavigators.route(
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
                                                                      color: Colors
                                                                          .blueAccent),
                                                                ),
                                                                Text(
                                                                  data[
                                                                      'meaning'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black),
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
                                                  const EdgeInsets.all(10.0),
                                              child: _isLoading.value
                                                  ? const CircularProgressIndicator()
                                                  : _mentionUsers.value.isEmpty
                                                      ? const SizedBox.shrink()
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
                                                                      color: Colors
                                                                          .blueAccent),
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
                                  );
                                },
                              ),
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
                                  if (val.length != _mediaList.value.length) {
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
                          ],
                        ),
                      ),
                      Container(
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
                                                  'People you follow',
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
                                // IconButton(
                                //   onPressed: () {},
                                //   padding: EdgeInsets.zero,
                                //   icon: SvgPicture.asset('assets/svgs/emoji.svg'),
                                //   splashColor: Colors.transparent,
                                //   splashRadius: 20,
                                //   constraints: const BoxConstraints(),
                                // ),
                                // const SizedBox(width: 20),

                                IconButton(
                                    onPressed: () async {
                                      focusNode.unfocus();
                                      focusNode.canRequestFocus = false;
                                      setState(() {
                                        emojiShowing = !emojiShowing;
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.emoji_emotions_outlined)),
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
                                      Console.log('<<<PATH>>', media.path);
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
                                indicatorColor: Theme.of(context).primaryColor,
                                iconColor: Colors.grey,
                                iconColorSelected:
                                    Theme.of(context).primaryColor,
                                backspaceColor: Theme.of(context).primaryColor,
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
                        ),
                      ),

                      ValueListenableBuilder(
                          valueListenable: _recordingService.recording,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return Visibility(
                              visible: value,
                              child: AudioRecordWidget(
                                recorderController:
                                    _recordingService.recorderController,
                                onSend: () async {
                                  final res = await _recordingService.stop();
                                  if (res == null) return;
                                  _mediaList.value = [
                                    ..._mediaList.value,
                                    UploadFileDto(
                                        file: res.file,
                                        id: Random().nextInt(100).toString(),
                                        fileResult: res)
                                  ];
                                },
                                onDelete: () {
                                  _recordingService.stop();
                                },
                              ),
                            );
                          })

                      // IconButton(
                      //     onPressed: () async {
                      //       if (_recordingService.isRecording) {
                      //         final res = await _recordingService.stop();
                      //         if (res == null) return;
                      //         _mediaList.value = [
                      //           ..._mediaList.value,
                      //           UploadFileDto(
                      //               file: res.file,
                      //               id: Random().nextInt(100).toString(),
                      //               fileResult: res)
                      //         ];
                      //         setState(() {});
                      //       } else {
                      //         _recordingService.record(fileName: 'post_reach_aud.aac');
                      //       }
                      //     },
                      //     icon: const Icon(Icons.mic)),
                      // AudioWaveforms(
                      //   size: Size(MediaQuery.of(context).size.width, 24.0),
                      //   waveStyle: const WaveStyle(
                      //     waveColor: Colors.black,
                      //     showDurationLabel: true,
                      //     spacing: 6.0,
                      //     // showBottom: true,
                      //     waveCap: StrokeCap.round,
                      //     scaleFactor: 0.2,
                      //     waveThickness: 3,
                      //     // showTop: true,
                      //     // showMiddleLine: true,
                      //     // extendWaveform: true,
                      //   ),
                      //   recorderController: _recordingService.recorderController,
                      // ),
                    ],
                  ),
                ),
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
              },
            );
          }),
    );
  }

  Row replyWidget(String replyFeature) {
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
