import 'dart:io';
//import 'dart:js_util';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/views/post_reach_media.dart';

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
    var size = MediaQuery.of(context).size;
    final counter = useState(0);
    final nVideos = useState(0);
    final nAudios = useState(0);
    final nImages = useState(0);
    final controller = useTextEditingController();

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
                            if (controller.text.isNotEmpty ||
                                _mediaList.value.isNotEmpty) {
                              if (_mediaList.value.isNotEmpty) {
                                globals.socialServiceBloc!.add(
                                    UploadPostMediaEvent(
                                        media: _mediaList.value));
                                globals.postContent = controller.text;
                                globals.postCommentOption = 'everyone';
                                setState(() {});
                              } else {
                                globals.socialServiceBloc!.add(CreatePostEvent(
                                  content: controller.text,
                                  commentOption: 'everyone',
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
                    TextField(
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      minLines: 1,
                      maxLines: null,
                      controller: controller,
                      inputFormatters: [
                        MaxWordTextInputFormater(maxWords: 200)
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
                    ).paddingSymmetric(h: 16),
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
                                  // return Stack(
                                  //   alignment: Alignment.topRight,
                                  //   children: [
                                  //     Container(
                                  //       width: getScreenWidth(200),
                                  //       height: getScreenHeight(200),
                                  //       clipBehavior: Clip.hardEdge,
                                  //       decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(15),
                                  //       ),
                                  //       child: Image.file(
                                  //         mediaDto.file,
                                  //         fit: BoxFit.cover,
                                  //       ),
                                  //     ),
                                  //     Positioned.fill(
                                  //         child: GestureDetector(onTap: () {
                                  //       RouteNavigators.route(
                                  //           context,
                                  //           PhotoView(
                                  //             imageProvider: FileImage(
                                  //               mediaDto.file,
                                  //             ),
                                  //           ));
                                  //     })),
                                  //     Positioned(
                                  //       right: getScreenWidth(4),
                                  //       top: getScreenWidth(5),
                                  //       child: GestureDetector(
                                  //         onTap: () {
                                  //           _mediaList.value.removeAt(index);
                                  //           setState(() {});
                                  //         },
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(10.0),
                                  //           child: Container(
                                  //             height: getScreenHeight(26),
                                  //             width: getScreenWidth(26),
                                  //             child: Center(
                                  //               child: Icon(
                                  //                 Icons.close,
                                  //                 color: AppColors.grey,
                                  //                 size: getScreenHeight(14),
                                  //               ),
                                  //             ),
                                  //             decoration: const BoxDecoration(
                                  //                 shape: BoxShape.circle,
                                  //                 color: AppColors.white),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ).paddingOnly(r: 10);

                                  if (FileUtils.isImage(mediaDto.file) ||
                                      FileUtils.isVideo(mediaDto.file)) {
                                    return PostReachMedia(
                                        fileResult: mediaDto.fileResult!,
                                        onClose: () {
                                          _mediaList.value.removeAt(index);
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
                          path: _mediaList
                              .value[_mediaList.value
                                  .indexWhere((e) => FileUtils.isAudio(e.file))]
                              .file
                              .path)
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
                      ),
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
                            final media = await MediaService()
                                .loadMediaFromGallery(context: context);
                            if (media == null) return;
                            if (FileUtils.isVideo(media.file) &&
                                nVideos.value > 0) {
                              Snackbars.error(context,
                                  message:
                                      'Sorry, you cannot add more than one video file');
                              return;
                            }

                            _mediaList.value.add(UploadFileDto(
                                file: media.file,
                                fileResult: media,
                                id: Random().nextInt(100).toString()));

                            if (FileUtils.isVideo(media.file)) {
                              nVideos.value = nVideos.value + 1;
                            } else if (FileUtils.isImage(media.file)) {
                              nImages.value = nImages.value + 1;
                            }
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
                            if (FileUtils.isAudio(media.file) &&
                                nAudios.value > 0) {
                              Snackbars.error(context,
                                  message:
                                      'Sorry, you cannot add more than one audio file');
                              return;
                            }

                            _mediaList.value.add(UploadFileDto(
                                file: media.file,
                                fileResult: media,
                                id: Random().nextInt(100).toString()));

                            if (FileUtils.isAudio(media.file)) {
                              nAudios.value = nAudios.value + 1;
                            }
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
                        MaxWordTextInputFormater(maxWords: 200)
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
                      ),
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
}
