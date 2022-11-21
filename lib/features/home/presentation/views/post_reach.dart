import 'dart:io';
//import 'dart:js_util';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/formatters.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/core/utils/regex_util.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/widgets/post_reach_media.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/models/file_result.dart';
import '../../../../core/services/media_service.dart';
import '../../../../core/utils/file_utils.dart';

class UploadFileDto {
  File file;
  String id;
  FileResult? fileResult;
  UploadFileDto({required this.file, required this.id, this.fileResult});
}

class PostReach extends StatefulHookWidget {
  const PostReach({Key? key}) : super(key: key);

  @override
  State<PostReach> createState() => _PostReachState();
}

class _PostReachState extends State<PostReach> {
  GlobalKey<FlutterMentionsState> controllerKey =
      GlobalKey<FlutterMentionsState>();
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
    useMemoized(() {
      globals.dictionaryBloc!
          .add(AddWordsToMentionsEvent(pageLimit: 100, pageNumber: 1));
    });

    var size = MediaQuery.of(context).size;
    final counter = useState(0);

    final nVideos = useState(0);
    final nAudios = useState(0);
    final nImages = useState(0);
    final controller = useTextEditingController();
    final replyFeature = useState("everyone");

    final _mediaList = useState<List<UploadFileDto>>([]);

    // final _imageList = useState<List<UploadFileDto>>([]);

    String getUserLoation() {
      if (globals.user!.showLocation!) {
        return globals.location!;
      } else {
        return 'nil';
      }
    }

    return Scaffold(
      body: SafeArea(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, size: 17),
                              padding: EdgeInsets.zero,
                              splashColor: Colors.transparent,
                              splashRadius: 20,
                              constraints: const BoxConstraints(),
                              onPressed: () => RouteNavigators.pop(context),
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
                          icon: SvgPicture.asset('assets/svgs/send.svg'),
                          onPressed: () {
                            if (controllerKey.currentState!.controller!.text
                                    .isNotEmpty ||
                                _mediaList.value.isNotEmpty) {
                              if (_mediaList.value.isNotEmpty) {
                                globals.socialServiceBloc!.add(
                                    UploadPostMediaEvent(
                                        media: _mediaList.value));

                                globals.postContent = controllerKey
                                    .currentState!.controller!.text;
                                globals.postCommentOption = replyFeature.value;

                                setState(() {});
                              } else {
                                debugPrint(
                                    "reply feature: ${replyFeature.value}");
                                globals.socialServiceBloc!.add(CreatePostEvent(
                                  content: controllerKey
                                      .currentState!.controller!.text,
                                  commentOption: replyFeature.value,
                                  location: getUserLoation(),
                                ));
                              }
                              RouteNavigators.pop(context);
                            }
                          },
                        ),
                      ],
                    ).paddingSymmetric(h: 16),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  globals.user!.showLocation!
                                      ? globals.location!
                                      : '',
                                  // globals.location == 'NIL'
                                  //     ? ''
                                  //     : globals.location!
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
                    const Divider(color: Color(0xFFEBEBEB), thickness: 0.5),
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
                          Snackbars.error(context, message: state.error);
                        }
                      },
                      builder: (context, state) {
                        return FlutterMentions(
                          key: controllerKey,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          // minLines: null,
                          maxLines: null,
                          inputFormatters: [
                            MaxWordTextInputFormatter(maxWords: 200)
                          ],
                          suggestionPosition: SuggestionPosition.Bottom,
                          onChanged: (val) {
                            counter.value = val
                                .trim()
                                .split(RegexUtil.spaceOrNewLine)
                                .length;
                            if (counter.value >= 200) {
                              Snackbars.error(context,
                                  message: '200 words limit reached!');
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
                                    padding: const EdgeInsets.all(10.0),
                                    child: _isLoading.value
                                        ? const CircularProgressIndicator()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 20.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '#${data['display']}',
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                  Text(
                                                    data['meaning'],
                                                    textAlign: TextAlign.left,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black),
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
                    const SizedBox(height: 10),
                    if (_mediaList.value.isNotEmpty)
                      SizedBox(
                          height: getScreenHeight(200),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: ListView.builder(
                                itemCount: _mediaList.value.length,
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (_mediaList.value.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  UploadFileDto mediaDto =
                                      _mediaList.value[index];
                                  if (FileUtils.isImage(mediaDto.file) ||
                                      FileUtils.isVideo(mediaDto.file)) {
                                    return PostReachMedia(
                                        fileResult: mediaDto.fileResult!,
                                        onClose: () {
                                          if (FileUtils.isImage(
                                              mediaDto.file)) {
                                            nImages.value = nImages.value - 1;
                                          } else {
                                            nVideos.value = nVideos.value - 1;
                                          }
                                          _mediaList.value = [
                                            ..._mediaList.value
                                          ]..removeAt(index);
                                          setState(() {});
                                        });
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                          )).paddingSymmetric(h: 16)
                    else
                      const SizedBox.shrink(),
                    if (_mediaList.value
                            .indexWhere((e) => FileUtils.isAudio(e.file)) >=
                        0)
                      PostReachAudioMedia(
                        margin: const EdgeInsets.all(16),
                        path: _mediaList
                            .value[_mediaList.value
                                .indexWhere((e) => FileUtils.isAudio(e.file))]
                            .file
                            .path,
                        onCancel: () {
                          int pos = _mediaList.value
                              .indexWhere((e) => FileUtils.isAudio(e.file));
                          _mediaList.value = [..._mediaList.value]
                            ..removeAt(pos);
                          nAudios.value = nAudios.value - 1;
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ).paddingSymmetric(h: size.width / 2.7),
                                    SizedBox(height: getScreenHeight(21)),
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
                                    SizedBox(height: getScreenHeight(5)),
                                    Center(
                                      child: Text(
                                        'Identify who can reply to this reach.',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(14),
                                          color: AppColors.greyShade3,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(20)),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          replyFeature.value = 'everyone';
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
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
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
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
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
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
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
                                            fontSize: getScreenHeight(16),
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
                            final media = await MediaService().pickFromGallery(
                                context: context, maxAssets: 15);
                            if (media == null) return;
                            int total = media.length;
                            int noOfVideos = media
                                .where((e) => FileUtils.isVideo(e.file))
                                .length;
                            int noOfImages = media
                                .where((e) => FileUtils.isImage(e.file))
                                .length;

                            if ((_mediaList.value.length + total) > 15) {
                              Snackbars.error(context,
                                  message:
                                      'Sorry, you cannot add more than 15 media');
                              return;
                            }

                            if (noOfVideos > 1 ||
                                (noOfVideos > 0 && nVideos.value > 0)) {
                              Snackbars.error(context,
                                  message:
                                      'Sorry, you cannot add more than one video media');
                              return;
                            }

                            for (var e in media) {
                              _mediaList.value.add(UploadFileDto(
                                  file: e.file,
                                  fileResult: e,
                                  id: Random().nextInt(100).toString()));
                            }

                            nVideos.value = nVideos.value + noOfVideos;
                            nImages.value = nImages.value + noOfImages;
                            setState(() {});
                          },
                          splashColor: Colors.transparent,
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset('assets/svgs/gallery.svg'),
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () async {
                            final media =
                                await MediaService().getAudio(context: context);
                            if (media == null) return;
                            if ((_mediaList.value.length + 1) > 15) {
                              Snackbars.error(context,
                                  message:
                                      'Sorry, you cannot add more than 15 media');
                              return;
                            }
                            if (!FileUtils.isAudio(media.file)) {
                              Snackbars.error(context,
                                  message: 'Audio format not supported!');
                              return;
                            }
                            if (nAudios.value > 0) {
                              Snackbars.error(context,
                                  message:
                                      'Sorry, you cannot add more than one audio media');
                              return;
                            }
                            nAudios.value = nAudios.value + 1;
                            Console.log('<<<PATH>>', media.path);
                            _mediaList.value.add(UploadFileDto(
                                file: media.file,
                                fileResult: media,
                                id: Random().nextInt(100).toString()));
                          },
                          padding: EdgeInsets.zero,
                          splashColor: Colors.transparent,
                          splashRadius: 20,
                          icon: SvgPicture.asset('assets/svgs/mic.svg'),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

class TagLocation extends StatelessWidget {
  const TagLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 17),
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                    onPressed: () => RouteNavigators.pop(context),
                  ),
                  const Text(
                    'Tag Location',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      width: 36,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 17,
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () => RouteNavigators.pop(context),
                  ),
                ],
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 22),
              const CustomRoundTextField(
                hintText: 'Search Location',
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(33),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nigeria',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                    )
                  ],
                ),
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  'Michael Okpara University of Agriculture',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Owerri, Imo State, Nigeria',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Michael Okpara University of Agriculture',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Owerri, Imo State, Nigeria',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditReach extends HookWidget {
  const EditReach({Key? key, required this.post}) : super(key: key);
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = useTextEditingController(text: post.content ?? '');
    final counter = useState(
        (post.content ?? '').trim().split(RegexUtil.spaceOrNewLine).length);
    return Scaffold(
      body: SafeArea(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, size: 17),
                              padding: EdgeInsets.zero,
                              splashColor: Colors.transparent,
                              splashRadius: 20,
                              constraints: const BoxConstraints(),
                              onPressed: () => RouteNavigators.pop(context),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              'Edit reach',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: SvgPicture.asset('assets/svgs/send.svg'),
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              globals.socialServiceBloc!.add(EditContentEvent(
                                content: controller.text,
                                postId: post.postId,
                              ));
                              RouteNavigators.pop(context);
                            }
                          },
                        ),
                      ],
                    ).paddingSymmetric(h: 16),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@${globals.user!.username}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor2,
                                  ),
                                ),
                                Text(
                                  globals.location ?? '',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.greyShade1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '${counter.value}/200',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor2,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEBEBEB), thickness: 0.5),
                    TextField(
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      minLines: 1,
                      maxLines: 6,
                      controller: controller,
                      // maxLength: 200,
                      inputFormatters: [
                        MaxWordTextInputFormatter(maxWords: 200)
                      ],
                      // maxLength: 200,
                      onChanged: (val) {
                        counter.value =
                            val.trim().split(RegexUtil.spaceOrNewLine).length;
                        if (counter.value >= 200) {
                          Snackbars.error(context,
                              message: '200 words limit reached!');
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        counterText: '',
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
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 10),
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
                                      ).paddingSymmetric(h: size.width / 2.7),
                                      SizedBox(height: getScreenHeight(21)),
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
                                      SizedBox(height: getScreenHeight(5)),
                                      Center(
                                        child: Text(
                                          'Identify who can reply to this reach.',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(14),
                                            color: AppColors.greyShade3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: getScreenHeight(20)),
                                      InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 14,
                                          leading: SvgPicture.asset(
                                              'assets/svgs/world.svg'),
                                          title: Text(
                                            'Everyone can reply',
                                            style: TextStyle(
                                              fontSize: getScreenHeight(16),
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: getScreenHeight(10)),
                                      InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 14,
                                          leading: SvgPicture.asset(
                                              'assets/svgs/people-you-follow.svg'),
                                          title: Text(
                                            'People you follow',
                                            style: TextStyle(
                                              fontSize: getScreenHeight(16),
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: getScreenHeight(10)),
                                      InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 14,
                                          leading: SvgPicture.asset(
                                              'assets/svgs/people-you-mention.svg'),
                                          title: Text(
                                            'Only people you mention',
                                            style: TextStyle(
                                              fontSize: getScreenHeight(16),
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: getScreenHeight(10)),
                                      InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 14,
                                          leading: SvgPicture.asset(
                                              'assets/svgs/none.svg'),
                                          title: Text(
                                            'None',
                                            style: TextStyle(
                                              fontSize: getScreenHeight(16),
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                              });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/svgs/world.svg',
                                height: 30),
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
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
