import 'dart:io';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as permit;
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/dtos/create.repost.input.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/components/snackbar.dart';
import '../../../../core/models/file_result.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/regex_util.dart';
import '../../../account/presentation/views/account.dart';
import '../../data/models/comment_model.dart';
import '../bloc/social-service-bloc/ss_bloc.dart';
import '../bloc/user-bloc/user_bloc.dart';

class CommentReach extends StatefulHookWidget {
  final PostFeedModel postFeedModel;
  const CommentReach({required this.postFeedModel, Key? key}) : super(key: key);

  @override
  State<CommentReach> createState() => _CommentReachState();
}

class _CommentReachState extends State<CommentReach> {
  late final RecorderController recorderController;
  bool isRecordingInit = false;
  bool isRecording = false;
  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();

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

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatLinearPCM
      ..sampleRate = 16000;
  }

  @override
  void initState() {
    super.initState();
    _initialiseController();
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
    recorderController.dispose();
  }
  // final _imageList = useState<List<UploadFileDto>>([]);

  String getUserLoation() {
    if (globals.user!.showLocation!) {
      return globals.location!;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(widget.postFeedModel.post!.createdAt!);
    var size = MediaQuery.of(context).size;
    final counter = useState(0);
    final controller = useTextEditingController();
    final replyFeature = useState("everyone");
    final _mediaList = useState<List<UploadFileDto>>([]);
    final triggerProgressIndicator = useState(true);
    final comments = useState<List<CommentModel>>([]);
    final scrollController = useScrollController();
    final isTyping = useState<bool>(false);

    return BlocConsumer<SocialServiceBloc, SocialServiceState>(
      bloc: globals.socialServiceBloc,
      listener: (context, state) {
        if (state is CreateRepostSuccess) {
          Snackbars.success(context,
              message: "Reach has been reposted on your timeline");

          globals.socialServiceBloc!
              .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
          Navigator.pop(context);
        }
        if (state is CreateRepostError) {
          Snackbars.error(context, message: state.error);
        }
        if (state is CreateRepostLoading) {
          toast('Reposting reach...',
              duration: const Duration(milliseconds: 100));
        }

        //
        // if (state is CommentOnPostSuccess) {
        //   SchedulerBinding.instance.addPostFrameCallback((_) {
        //     scrollController.animateTo(
        //       scrollController.position.minScrollExtent,
        //       duration: const Duration(milliseconds: 10),
        //       curve: Curves.easeOut,
        //     );
        //   });
        //   Snackbars.success(context, message: "Your commment has been posted");
        //   triggerProgressIndicator.value = false;
        //   globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
        //       postId: widget.postFeedModel.postId,
        //       pageLimit: 50,
        //       pageNumber: 1));
        // }
        // if (state is CommentOnPostError) {
        //   Snackbars.error(context, message: state.error);
        // }
        // if (state is CommentOnPostLoading) {
        //   toast('Posting comment...',
        //       duration: const Duration(milliseconds: 100));
        // }
        // if (state is GetAllCommentsOnPostSuccess) {
        //   comments.value = state.data!.reversed.toList();
        // }
        //
        // if (state is GetAllCommentsOnPostError) {
        //   Snackbars.error(context, message: state.error);
        // }
        // if (state is UnlikeCommentOnPostSuccess ||
        //     state is LikeCommentOnPostSuccess) {
        //   globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
        //       postId: widget.postFeedModel.postId,
        //       pageLimit: 50,
        //       pageNumber: 1));
        // }
      },
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
                child: Stack(
          children: [
            Positioned(
              child: Row(
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
                      RichText(
                          text: TextSpan(
                              text: 'Reply to ',
                              style: const TextStyle(
                                  color: AppColors.textColor5, fontSize: 16),
                              children: [
                            TextSpan(
                              text: '@${widget.postFeedModel.username!}',
                              style: const TextStyle(
                                  color: AppColors.primaryColor, fontSize: 16),
                            )
                          ]))
                    ],
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/svgs/send.svg'),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        // globals.socialServiceBloc!.add(CommentOnPostEvent(
                        //     postId: widget.postFeedModel.postId,
                        //     content: controller.text,
                        //     userId: globals.user!.id));

                        globals.socialServiceBloc!.add(CreateRepostEvent(
                            input: CreateRepostInput(
                                repostedPostId: widget.postFeedModel.postId,
                                repostedPostOwnerId:
                                    widget.postFeedModel.postOwnerId,
                                content: controller.text,
                                location: globals.user!.showLocation!
                                    ? globals.location!
                                    : 'nil',
                                postRating: 'normal',
                                commentOption: 'everyone')));
                      }
                      // controller.clear();
                    },
                  ),
                ],
              ).paddingSymmetric(h: 16),
            ),
            Container(
              width: size.width,
              height: size.height,
              margin: const EdgeInsets.only(top: 75),
              child: Column(children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Helper.renderProfilePicture(
                            globals.user!.profilePicture,
                            size: 38,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
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
                                    SizedBox(
                                        width: 93,
                                        child: Text(
                                          getUserLoation(),
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.08,
                            decoration: BoxDecoration(
                                color: AppColors.greyShade9,
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: AppColors.greyShade9)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        width: size.width,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: AppColors.greyShade10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoButton(
                                  minSize: 0,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    final progress = ProgressHUD.of(context);
                                    progress
                                        ?.showWithText('Viewing Reacher...');
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      globals.userBloc!.add(
                                          GetRecipientProfileEvent(
                                              email: widget
                                                  .postFeedModel.postOwnerId));
                                      widget.postFeedModel.postOwnerId ==
                                              globals.user!.id
                                          ? RouteNavigators.route(
                                              context, const AccountScreen())
                                          : RouteNavigators.route(
                                              context,
                                              RecipientAccountProfile(
                                                recipientEmail: 'email',
                                                recipientImageUrl: widget
                                                    .postFeedModel
                                                    .profilePicture,
                                                recipientId: widget
                                                    .postFeedModel.postOwnerId,
                                              ));
                                      progress?.dismiss();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Helper.renderProfilePicture(
                                        widget.postFeedModel.profilePicture,
                                        size: 40,
                                      ).paddingOnly(l: 13, t: 10),
                                      SizedBox(width: getScreenWidth(9)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '@${widget.postFeedModel.username!}',
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(14),
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textColor2,
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              widget.postFeedModel.verified!
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/verified.svg')
                                                  : const SizedBox.shrink()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                widget.postFeedModel.post!
                                                            .location! ==
                                                        'nil'
                                                    ? ''
                                                    : widget.postFeedModel.post!
                                                        .location!,
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(10),
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.4,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textColor2,
                                                ),
                                              ),
                                              Text(
                                                postDuration,
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(10),
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.4,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textColor2,
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
                            widget.postFeedModel.post!.content == null
                                ? const SizedBox.shrink()
                                : Row(
                                    children: [
                                      Flexible(
                                        child: ReadMoreText(
                                          "${widget.postFeedModel.post!.content}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: getScreenHeight(14)),
                                          trimLines: 3,
                                          colorClickableText:
                                              const Color(0xff717F85),
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'See more',
                                          trimExpandedText: 'See less',
                                          moreStyle: TextStyle(
                                              fontSize: getScreenHeight(14),
                                              fontFamily: "Roboto",
                                              color: const Color(0xff717F85)),
                                        ),
                                      ),
                                      SizedBox(width: getScreenWidth(2)),
                                      Tooltip(
                                        message:
                                            'This Reach has been edited by the Reacher',
                                        waitDuration:
                                            const Duration(seconds: 1),
                                        showDuration:
                                            const Duration(seconds: 2),
                                        child: Text(
                                          widget.postFeedModel.post!.edited!
                                              ? "(Reach Edited)"
                                              : "",
                                          style: TextStyle(
                                            fontSize: getScreenHeight(12),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).paddingSymmetric(h: 16, v: 10),
                            if (widget.postFeedModel.post!.imageMediaItems!
                                .isNotEmpty)
                              Helper.renderPostImages(
                                      widget.postFeedModel.post!, context)
                                  .paddingOnly(r: 16, l: 16, b: 16, t: 10)
                            else
                              const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.028,
                      ),
                      const Divider(color: Color(0xFFEBEBEB), thickness: 0.5),
                      TextField(
                        focusNode: focusNode,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        minLines: 1,
                        maxLines: null,
                        controller: controller,
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
                          counterText: '',
                          hintText: "Comment to this reach...",
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
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          width: getScreenWidth(200),
                                          height: getScreenHeight(200),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.file(
                                            mediaDto.file,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned.fill(
                                            child: GestureDetector(onTap: () {
                                          RouteNavigators.route(
                                              context,
                                              PhotoView(
                                                imageProvider: FileImage(
                                                  mediaDto.file,
                                                ),
                                              ));
                                        })),
                                        Positioned(
                                          right: getScreenWidth(4),
                                          top: getScreenWidth(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              _mediaList.value.removeAt(index);
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                height: getScreenHeight(26),
                                                width: getScreenWidth(26),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.grey,
                                                    size: getScreenHeight(14),
                                                  ),
                                                ),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).paddingOnly(r: 10);
                                    // if (FileUtils.isImage(mediaDto.file) ||
                                    //     FileUtils.isVideo(mediaDto.file)) {
                                    //   return PostReachMedia(
                                    //       fileResult: mediaDto.fileResult!,
                                    //       onClose: () {
                                    //         _mediaList.value.removeAt(index);
                                    //         setState(() {});
                                    //       });
                                    // } else {
                                    //   return const SizedBox.shrink();
                                    // }
                                  }),
                            )).paddingSymmetric(h: 16)
                      else
                        const SizedBox.shrink(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      // showEmoji.value
                      //     ? buildEmoji()
                      //     : SizedBox(
                      //         height: MediaQuery.of(context).size.height * 0.3,
                      //       ),

                      // who can reply
                      // Container(
                      //   // margin: const EdgeInsets.only(top: 210),
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 20,
                      //     vertical: 15,
                      //   ),
                      //   color: const Color(0xFFF5F5F5),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       InkWell(
                      //         onTap: () {
                      //           showModalBottomSheet(
                      //               context: context,
                      //               shape: const RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.only(
                      //                     topLeft: Radius.circular(10),
                      //                     topRight: Radius.circular(10)),
                      //               ),
                      //               builder: (context) {
                      //                 return ListView(
                      //                     physics:
                      //                         const NeverScrollableScrollPhysics(),
                      //                     shrinkWrap: true,
                      //                     padding: const EdgeInsets.symmetric(
                      //                       horizontal: 27,
                      //                       vertical: 10,
                      //                     ),
                      //                     children: [
                      //                       Container(
                      //                         height: 4,
                      //                         decoration: BoxDecoration(
                      //                           color: AppColors.greyShade5
                      //                               .withOpacity(0.5),
                      //                           borderRadius:
                      //                               BorderRadius.circular(20),
                      //                         ),
                      //                       ).paddingSymmetric(h: size.width / 2.7),
                      //                       SizedBox(height: getScreenHeight(21)),
                      //                       Center(
                      //                         child: Text(
                      //                           'Who can reply',
                      //                           style: TextStyle(
                      //                             fontSize: getScreenHeight(16),
                      //                             color: AppColors.black,
                      //                             fontWeight: FontWeight.w600,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       SizedBox(height: getScreenHeight(5)),
                      //                       Center(
                      //                         child: Text(
                      //                           'Identify who can reply to this reach.',
                      //                           style: TextStyle(
                      //                             fontSize: getScreenHeight(14),
                      //                             color: AppColors.greyShade3,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       SizedBox(height: getScreenHeight(20)),
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             replyFeature.value = 'everyone';
                      //                             RouteNavigators.pop(context);
                      //                           });
                      //                         },
                      //                         child: ListTile(
                      //                           contentPadding: EdgeInsets.zero,
                      //                           minLeadingWidth: 14,
                      //                           leading: SvgPicture.asset(
                      //                               'assets/svgs/world.svg'),
                      //                           title: Text(
                      //                             'Everyone can reply',
                      //                             style: TextStyle(
                      //                               fontSize: getScreenHeight(16),
                      //                               color: AppColors.black,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       SizedBox(height: getScreenHeight(10)),
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             replyFeature.value =
                      //                                 'people_you_follow';
                      //                           });
                      //                           RouteNavigators.pop(context);
                      //                         },
                      //                         child: ListTile(
                      //                           contentPadding: EdgeInsets.zero,
                      //                           minLeadingWidth: 14,
                      //                           leading: SvgPicture.asset(
                      //                               'assets/svgs/people-you-follow.svg'),
                      //                           title: Text(
                      //                             'People you follow',
                      //                             style: TextStyle(
                      //                               fontSize: getScreenHeight(16),
                      //                               color: AppColors.black,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       SizedBox(height: getScreenHeight(10)),
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             replyFeature.value =
                      //                                 'only_people_you_mention';
                      //                           });
                      //                           RouteNavigators.pop(context);
                      //                         },
                      //                         child: ListTile(
                      //                           contentPadding: EdgeInsets.zero,
                      //                           minLeadingWidth: 14,
                      //                           leading: SvgPicture.asset(
                      //                               'assets/svgs/people-you-mention.svg'),
                      //                           title: Text(
                      //                             'Only people you mention',
                      //                             style: TextStyle(
                      //                               fontSize: getScreenHeight(16),
                      //                               color: AppColors.black,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       SizedBox(height: getScreenHeight(10)),
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             replyFeature.value = 'none';
                      //                           });
                      //                           RouteNavigators.pop(context);
                      //                         },
                      //                         child: ListTile(
                      //                           contentPadding: EdgeInsets.zero,
                      //                           minLeadingWidth: 14,
                      //                           leading: SvgPicture.asset(
                      //                               'assets/svgs/none.svg'),
                      //                           title: Text(
                      //                             'None',
                      //                             style: TextStyle(
                      //                               fontSize: getScreenHeight(16),
                      //                               color: AppColors.black,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ]);
                      //               });
                      //         },
                      //         child: replyWidget(replyFeature.value),
                      //       ),
                      //       Row(

                      //         children: [
                      //           replyWidget(replyFeature.value),
                      //           IconButton(
                      //             onPressed: () {
                      //               setState(() {
                      //                 //  showEmoji.value = !showEmoji.value;
                      //               });
                      //             },
                      //             padding: EdgeInsets.zero,
                      //             icon: SvgPicture.asset('assets/svgs/emoji.svg'),
                      //             splashColor: Colors.transparent,
                      //             splashRadius: 20,
                      //             constraints: const BoxConstraints(),
                      //           ),
                      //           const SizedBox(width: 20),
                      //           IconButton(
                      //             onPressed: () async {
                      //               // final media = await MediaService()
                      //               //     .loadMediaFromGallery(context: context);
                      //               final media =
                      //                   await getImage(ImageSource.gallery);
                      //               if (media != null) {
                      //                 _mediaList.value.add(UploadFileDto(
                      //                     file: media,
                      //                     id: Random().nextInt(100).toString()));
                      //                 setState(() {});
                      //               }
                      //             },
                      //             splashColor: Colors.transparent,
                      //             splashRadius: 20,
                      //             padding: EdgeInsets.zero,
                      //             icon: SvgPicture.asset('assets/svgs/gallery.svg'),
                      //             constraints: const BoxConstraints(),
                      //           ),
                      //           const SizedBox(width: 20),
                      //           IconButton(
                      //             //constraints: const BoxConstraints(
                      //             // maxHeight: 25, maxWidth: 25),
                      //             onPressed: () async {
                      //               setState(() {
                      //                 isRecording = !isRecording;
                      //               });
                      //               var tempDir = await getTemporaryDirectory();
                      //               var path = '${tempDir.path}/flutter_sound.aac';

                      //               if (!isRecordingInit) {
                      //                 return;
                      //               }
                      //               if (isRecording) {
                      //                 await _soundRecorder!.stopRecorder();
                      //                 print(path);
                      //                 File audioMessage = File(path);

                      //                 /*globals.chatBloc!.add(
                      //                                   UploadImageFileEvent(
                      //                                       file: audioMessage));*/
                      //               } else {
                      //                 await _soundRecorder!.startRecorder(
                      //                   toFile: path,
                      //                 );
                      //               }
                      //             },
                      //             icon: !isRecording
                      //                 ? SvgPicture.asset(
                      //                     'assets/svgs/mic.svg',
                      //                     color: AppColors.blackShade3,
                      //                     width: 20,
                      //                     height: 26,
                      //                   )
                      //                 : SvgPicture.asset(
                      //                     'assets/svgs/dc-cancel.svg',
                      //                     color: AppColors.blackShade3,
                      //                     height: 20,
                      //                     width: 20,
                      //                   ),
                      //             constraints: const BoxConstraints(),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ]),
            ),
            Positioned(
              top: 750,
              child: Container(
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
                        IconButton(
                          onPressed: () {
                            focusNode.unfocus();
                            focusNode.canRequestFocus = false;
                            setState(() {
                              emojiShowing = !emojiShowing;
                            });
                          },
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset('assets/svgs/emoji.svg'),
                          splashColor: Colors.transparent,
                          splashRadius: 20,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () async {
                            // final media = await MediaService()
                            //     .loadMediaFromGallery(context: context);
                            final media = await getImage(ImageSource.gallery);
                            if (media != null) {
                              _mediaList.value.add(UploadFileDto(
                                  file: media,
                                  id: Random().nextInt(100).toString()));
                              setState(() {});
                            }
                          },
                          splashColor: Colors.transparent,
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset('assets/svgs/gallery.svg'),
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          //constraints: const BoxConstraints(
                          // maxHeight: 25, maxWidth: 25),
                          onPressed: () async {
                            var tempDir = await getTemporaryDirectory();
                            String? path =
                                '${tempDir.path}/commentReach_sound.aac';

                            if (isRecording) {
                              path = await recorderController.stop();
                              File audio = File(path!);
                              globals.socialServiceBloc!
                                  .add(MediaUploadEvent(media: audio));
                              print(path);
                            } else {
                              await recorderController.record(path);
                            }

                            setState(() {
                              isRecording = !isRecording;
                            });
                          },
                          icon: !isRecording
                              ? SvgPicture.asset(
                                  'assets/svgs/mic.svg',
                                  color: AppColors.blackShade3,
                                  width: 20,
                                  height: 26,
                                )
                              : SvgPicture.asset(
                                  'assets/svgs/dc-cancel.svg',
                                  color: AppColors.blackShade3,
                                  height: 20,
                                  width: 20,
                                ),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: emojiShowing,
              child: SizedBox(
                height: 227,
                child: EmojiPicker(
                  textEditingController: controller,
                  config: Config(
                      columns: 7,
                      emojiSizeMax: 28 * (Platform.isIOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: Colors.white,
                      indicatorColor: Theme.of(context).primaryColor,
                      iconColor: Colors.grey,
                      iconColorSelected: Theme.of(context).primaryColor,
                      backspaceColor: Theme.of(context).primaryColor,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 32,
                      noRecents: const Text(
                        'Pas d\'émojis récents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      )),
                  onEmojiSelected: (category, emoji) {
                    controller
                      ..text += emoji.emoji
                      ..selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length));
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
            ),
            isRecording? audioRecording() : const SizedBox.shrink(),
          ],
        )));
      },
    );
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

  Widget audioRecording() {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              recorderController.stop();
            },
            child: Icon(
              Icons.delete,
              size: 32,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: AudioWaveforms(
              size: Size(MediaQuery.of(context).size.width / 2, 20),
              recorderController: recorderController,
              enableGesture: true,
              waveStyle: const WaveStyle(
                waveColor: Colors.blueAccent,
                extendWaveform: true,
                showMiddleLine: false,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(
                  left: 18, right: 20, top: 15, bottom: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
         GestureDetector(
          onTap: () {
            
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.primaryColor
            ),
            child: const Icon(
              Icons.send,
              color: AppColors.white,
              size: 16,
            ),
          ),
         ) 
        ],
      ),
    );
  }
}
