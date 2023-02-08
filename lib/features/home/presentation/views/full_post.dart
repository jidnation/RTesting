import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/comment_reach.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/components/snackbar.dart';
import '../../../../core/services/media_service.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../account/presentation/views/account.dart';
import '../../../account/presentation/widgets/bottom_sheets.dart';
import '../../../chat/presentation/views/msg_chat_interface.dart';
import '../../../dictionary/presentation/widgets/view_words_dialog.dart';
import '../../../moment/comment_media.dart';
import '../../../moment/moment_audio_player.dart';
import '../../../profile/new_account.dart';
import '../../../timeline/comment_box_bottom_sheet.dart';
import '../../../timeline/timeline_feed.dart';
import '../../../timeline/video_player.dart';
import '../../data/models/comment_model.dart';
import '../widgets/post_media.dart';
import 'home_screen.dart';

class FullPostScreen extends StatefulHookWidget {
  static String id = 'full_post_screen';

  //final bool likingPost;
  // final Function()? onLike, onMessage, onUpvote, onDownvote, routeProfile;
  // final bool isLiked, isVoted;
  // final String? voteType;
  final PostFeedModel? postFeedModel;

  const FullPostScreen({required this.postFeedModel, Key? key})
      : super(key: key);

  @override
  State<FullPostScreen> createState() => _FullPostScreenState();
}

class _FullPostScreenState extends State<FullPostScreen> {
  @override
  void initState() {
    globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
        postId: widget.postFeedModel!.postId, pageLimit: 50, pageNumber: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final post = useState<PostFeedModel>(widget.postFeedModel!);
    final comments = useState<List<CommentModel>>([]);
    final postDuration = timeago.format(widget.postFeedModel!.post!.createdAt!);
    final size = MediaQuery.of(context).size;
    final controller = useTextEditingController();
    final scrollController = useScrollController();
    final showEmoji = useState(false);
    final showCommentField = useState(true);
    final reachUser = useState(false);
    final starUser = useState(false);
    final likePost = useState(false);
    final shoutoutPost = useState(false);
    final shoutdownPost = useState(false);
    final _currentPost = useState<PostFeedModel?>(null);
    final commentOption = widget.postFeedModel!.post!.commentOption;
    final isLiked = useState<String?>(null);
    final reachingList = useState<List<VirtualReach>?>([]);
    final isReaching = useState(false);
    final triggerProgressIndicator = useState(true);
    final commentFocusNode = useFocusNode();
    final commentToReply = useState<CommentModel?>(null);

    useMemoized(() {
      globals.userBloc!.add(GetReachRelationshipEvent(
          userIdToReach: widget.postFeedModel!.postOwnerId,
          type: ReachRelationshipType.reacher));
    });

    // useMemoized(() {
    //   globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
    //       postId: widget.postFeedModel!.postId, pageLimit: 50, pageNumber: 1));
    // });

    Set active = {};

    handleTap(index) {
      if (active.isNotEmpty) active.clear();
      setState(() {
        active.add(index);
      });
    }

    final _refreshController = RefreshController();

    Future<void> onRefresh() async {
      SocialServiceBloc();
      globals.socialServiceBloc!
          .add(GetPostEvent(postId: widget.postFeedModel!.postId));
    }

    var scr = GlobalKey();
    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

    Future<String> saveImage(Uint8List? bytes) async {
      await [Permission.storage].request();
      String time = DateTime.now().microsecondsSinceEpoch.toString();
      final name = 'screenshot_${time}_reachme';
      final result = await ImageGallerySaver.saveImage(bytes!, name: name);
      debugPrint("Result ${result['filePath']}");
      Snackbars.success(context, message: 'Image saved to Gallery');
      RouteNavigators.pop(context);
      return result['filePath'];
    }

    void takeScreenShot() async {
      RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()
          as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    final reachDM = useState(false);
    return BlocConsumer<UserBloc, UserState>(
      bloc: globals.userBloc,
      listener: (context, state) {
        if (state is RecipientUserData) {
          // reachDM.value = false;
          if (reachDM.value) {
            RouteNavigators.route(
                context, MsgChatInterface(recipientUser: state.user));
          }
        }
        if (state is GetUserByUsernameSuccess) {
          // var userInfo = state.users!.user.first;
          var userInfo = state.users!;
          RouteNavigators.route(
              context,
              RecipientAccountProfile(
                recipientCoverImageUrl: userInfo.user.first.coverPicture,
                recipientEmail: userInfo.user.first.email,
                recipientId: userInfo.user.first.id,
                recipientImageUrl: userInfo.user.first.profilePicture,
              ));
        }
        if (state is GetUserByUsernameError) {
          Snackbars.error(context, message: 'User Profile not found');
        }
        if (state is GetReachRelationshipSuccess) {
          isReaching.value = state.isReaching!;
          if (shoutdownPost.value == true) {
            shoutdownPost.value = false;
            debugPrint("Shoutdown post");
            if ((state.isReaching ?? false)) {
              debugPrint("PostId: ${widget.postFeedModel!.postId} ");
              // _currentPost.value!.postId = widget.postFeedModel!.postId;
              globals.socialServiceBloc!.add(VotePostEvent(
                voteType: 'Downvote',
                postId: widget.postFeedModel!.postId,
              ));
              // debugPrint("Shoutdown success");
              // Snackbars.success(context,
              //     message: 'You shouted down on this user\'s posts');
            } else {
              Snackbars.error(context,
                  message: 'You cannot shout down on this user\'s posts');
              RouteNavigators.pop(context);
            }
          }
          debugPrint("State isReahing ${state.isReaching}");
        }
      },
      builder: (context, state) {
        bool isLoading = state is GetAllCommentsOnPostLoading;
        return BlocConsumer<SocialServiceBloc, SocialServiceState>(
          bloc: globals.socialServiceBloc,
          listener: ((context, state) {
            // if (state is MediaUploadSuccess) {
            //   String? audioMediaItem;
            //   String? videoMediaItem;
            //   List<String>? imageMediaItem;
            //   if (FileUtils.fileType(state.image!) == "audio") {
            //     audioMediaItem = state.image!;
            //   }
            //   if (FileUtils.fileType(state.image!) == "video") {
            //     videoMediaItem = state.image!;
            //   }
            //   if (FileUtils.fileType(state.image!) == "image") {
            //     imageMediaItem = [];
            //     imageMediaItem.add(state.image!);
            //   }
            //   globals.socialServiceBloc!.add(CommentOnPostEvent(
            //       postId: widget.postFeedModel!.postId,
            //       userId: globals.user!.id,
            //       content: globals.postContent,
            //       postOwnerId: widget.postFeedModel!.postOwnerId,
            //       audioMediaItem: audioMediaItem ?? null,
            //       videoMediaItem: videoMediaItem ?? null,
            //       imageMediaItems: imageMediaItem ?? []));

            //   // if ((FileUtils.fileType(url) == 'audio') ||
            //   //     (FileUtils.fileType(url) == 'image') ||
            //   //     (FileUtils.fileType(url) == 'video')) {
            //   //   if (FileUtils.fileType(url) == 'audio')
            //   //     print('This is an audioFile');

            //   //   globals.socialServiceBloc!.add(CommentOnPostEvent(
            //   //     content: globals.postContent,
            //   //     postId: widget.postFeedModel!.postId,
            //   //     userId: globals.user!.id,
            //   //     audioMediaItem: url.isNotEmpty ? url : ' ',
            //   //     postOwnerId: widget.postFeedModel!.postOwnerId,
            //   //   ));
            //   // }

            //   // if (FileUtils.fileType(url) == 'image') {
            //   //   print('This is a image file');
            //   //   List<String> imageMediaItem = [];
            //   //   imageMediaItem.add(url);
            //   //   globals.socialServiceBloc!.add(CommentOnPostEvent(
            //   //     content: globals.postContent,
            //   //     postId: widget.postFeedModel!.postId,
            //   //     userId: globals.user!.id,
            //   //     imageMediaItems:
            //   //         imageMediaItem.isNotEmpty ? imageMediaItem : [],
            //   //     postOwnerId: widget.postFeedModel!.postOwnerId,
            //   //   ));
            //   // }

            //   // if (FileUtils.fileType(url) == 'video') {
            //   //   print('This is a video file');
            //   //   globals.socialServiceBloc!.add(CommentOnPostEvent(
            //   //     content: globals.postContent,
            //   //     postId: widget.postFeedModel!.postId,
            //   //     userId: globals.user!.id,
            //   //     videoMediaItem: url.isNotEmpty ? url : ' ',
            //   //     postOwnerId: widget.postFeedModel!.postOwnerId,
            //   //   ));
            //   // }
            // }

            if (state is CommentOnPostSuccess) {
              timeLineFeedStore.initialize(
                  isUpvoting: true, isRefreshing: true);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.easeOut,
                );
              });

              Snackbars.success(context,
                  message: "Your comment has been posted");
              triggerProgressIndicator.value = false;
              globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
                  postId: widget.postFeedModel!.postId,
                  pageLimit: 50,
                  pageNumber: 1));
            }

            if (state is ReplyCommentOnPostError) {
              Snackbars.error(context, message: state.error);
            }

            if (state is ReplyCommentOnPostSuccess) {
              timeLineFeedStore.initialize(isUpvoting: true);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.easeOut,
                );
              });

              Snackbars.success(context, message: "Your reply has been posted");
              triggerProgressIndicator.value = false;
              globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
                  postId: widget.postFeedModel!.postId,
                  pageLimit: 50,
                  pageNumber: 1));
            }

            if (state is VotePostSuccess) {
              timeLineFeedStore.initialize(
                  isUpvoting: true, isRefreshing: true);
              if (!(state.isVoted!)) {
                Snackbars.success(context,
                    message: 'The post you shouted down has been removed!');
                globals.socialServiceBloc!
                    .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                RouteNavigators.pop(context);
              } else {
                Snackbars.success(context, message: 'You shouted at this post');
              }
              globals.socialServiceBloc!
                  .add(GetPostEvent(postId: widget.postFeedModel!.postId));
            }
            if (state is LikePostSuccess || state is UnlikePostSuccess) {
              timeLineFeedStore.initialize(
                  isUpvoting: true, isRefreshing: true);
              debugPrint("Like Post Success");
              globals.socialServiceBloc!
                  .add(GetPostEvent(postId: widget.postFeedModel!.postId));
            }

            if (state is SavePostSuccess) {
              RouteNavigators.pop(context);
              Snackbars.success(context, message: 'Post saved successfully');
            }
            if (state is SavePostError) {
              RouteNavigators.pop(context);
              Snackbars.error(context, message: state.error);
            }
            if (state is GetPostSuccess) {
              debugPrint("Get Post Success");
              post.value.post!.nLikes = state.data!.nLikes;
              post.value.post!.nUpvotes = state.data!.nUpvotes;
              post.value.post!.nDownvotes = state.data!.nDownvotes;
            }
            if (state is GetAllCommentsOnPostSuccess) {
              comments.value = state.data!.reversed.toList();
            }

            if (state is LikeCommentOnPostSuccess) {
              timeLineFeedStore.initialize(
                  isUpvoting: true, isRefreshing: true);
              globals.socialServiceBloc!.add(GetSingleCommentOnPostEvent(
                  commentId: state.commentLikeModel!.commentId));
            }

            if (state is UnlikeCommentOnPostSuccess) {
              timeLineFeedStore.initialize(
                  isUpvoting: true, isRefreshing: true);
              globals.socialServiceBloc!.add(
                  GetSingleCommentOnPostEvent(commentId: state.unlikeComment));
            }

            if (state is GetSingleCommentOnPostSuccess) {
              comments.value
                  .firstWhere((e) => e.commentId == state.data!.commentId)
                  .isLiked = state.data!.isLiked;

              comments.value
                  .firstWhere((e) => e.commentId == state.data!.commentId)
                  .nLikes = state.data!.nLikes;
            }
          }),
          builder: ((context, state) {
            return SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppColors.white,
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark,
                        statusBarBrightness: Platform.isAndroid
                            ? Brightness.dark
                            : Brightness.light,
                        systemNavigationBarColor: Colors.transparent,
                        systemNavigationBarDividerColor: Colors.grey,
                        systemNavigationBarIconBrightness: Brightness.dark,
                      ),
                      bottom: PreferredSize(
                          child: Container(
                            color: const Color.fromRGBO(0, 0, 0, 0.08),
                            height: 4.0,
                          ),
                          preferredSize: const Size.fromHeight(1.0)),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        onPressed: () {
                          RouteNavigators.route(context, const HomeScreen());
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      titleSpacing: 5,
                      leadingWidth: getScreenWidth(70),
                      title: Text(
                        'Full Post',
                        style: TextStyle(
                          color: const Color(0xFF001824),
                          fontSize: getScreenHeight(20),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    backgroundColor: const Color(0xffFFFFFF),
                    body: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView(shrinkWrap: true, children: [
                              RepaintBoundary(
                                key: scr,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: getScreenWidth(16),
                                    left: getScreenWidth(16),
                                    //bottom: getScreenHeight(2),
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                    ),
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
                                              },
                                              child: Row(
                                                children: [
                                                  Helper.renderProfilePicture(
                                                    widget.postFeedModel!
                                                        .profilePicture,
                                                    size: 33,
                                                  ).paddingOnly(
                                                      left: 13, top: 10),
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
                                                          ).paddingOnly(
                                                              left: 6),
                                                        ],
                                                      )
                                                    ],
                                                  ).paddingOnly(top: 10),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //  SvgPicture.asset('assets/svgs/starred.svg'),
                                                SizedBox(
                                                    width: getScreenWidth(9)),
                                                IconButton(
                                                  onPressed: () async {
                                                    await showReacherCardBottomSheet(
                                                      context,
                                                      downloadPost:
                                                          takeScreenShot,
                                                      postFeedModel:
                                                          widget.postFeedModel!,
                                                    );
                                                  },
                                                  iconSize: getScreenHeight(19),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  icon: SvgPicture.asset(
                                                      'assets/svgs/kebab card.svg'),
                                                ),
                                              ],
                                            )
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
                                                    ? "(Reach Edited)"
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
                                                  print('Tapped Url');
                                                },
                                                onMentionTap: (value) {
                                                  globals.userBloc!.add(
                                                      GetUserByUsernameEvent(
                                                          username: value));
                                                },
                                                mentionStyle: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue),
                                                hashtagStyle: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue),
                                              ).paddingSymmetric(
                                                horizontal: 16, vertical: 10),
                                        Tooltip(
                                          key: tooltipkey,
                                          triggerMode:
                                              TooltipTriggerMode.manual,
                                          showDuration:
                                              const Duration(seconds: 1),
                                          message: 'This reach has been edited',
                                        ),
                                        if ((widget.postFeedModel?.post
                                                    ?.imageMediaItems ??
                                                [])
                                            .isNotEmpty)
                                          PostMedia(
                                                  post: widget
                                                      .postFeedModel!.post!)
                                              .paddingOnly(
                                                  right: 16,
                                                  left: 16,
                                                  bottom: 16,
                                                  top: 10)
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
                                        const SizedBox(height: 10),
                                        // likes and message
                                        Row(children: [
                                          GestureDetector(
                                            onLongPress: () {
                                              if ((post.value.post?.nLikes ??
                                                      0) >
                                                  0) {
                                                showPostReactors(context,
                                                    postId: post
                                                        .value.post!.postId!,
                                                    reactionType: 'Like');
                                              }
                                            },
                                            onTap: () {
                                              HapticFeedback.mediumImpact();
                                              handleTap(
                                                  widget.postFeedModel!.post);
                                              if (active.contains(
                                                  widget.postFeedModel!.post)) {
                                                if (widget.postFeedModel!.post
                                                        ?.isLiked ??
                                                    false) {
                                                  widget.postFeedModel!.post
                                                      ?.isLiked = false;
                                                  widget.postFeedModel!.post
                                                      ?.nLikes = (widget
                                                              .postFeedModel!
                                                              .post
                                                              ?.nLikes ??
                                                          1) -
                                                      1;
                                                  globals.socialServiceBloc!
                                                      .add(UnlikePostEvent(
                                                    postId: widget
                                                        .postFeedModel!.postId,
                                                  ));
                                                } else {
                                                  widget.postFeedModel!.post
                                                      ?.isLiked = true;
                                                  widget.postFeedModel!.post
                                                      ?.nLikes = (widget
                                                              .postFeedModel!
                                                              .post
                                                              ?.nLikes ??
                                                          0) +
                                                      1;
                                                  globals.socialServiceBloc!
                                                      .add(
                                                    LikePostEvent(
                                                        postId: widget
                                                            .postFeedModel!
                                                            .postId),
                                                  );
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: size.width -
                                                  (size.width - 124),
                                              height: size.width -
                                                  (size.width - 50),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 11,
                                                vertical: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(0xFFF5F5F5),
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CupertinoButton(
                                                      minSize: 0,
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        handleTap(widget
                                                            .postFeedModel!
                                                            .post);
                                                        if (active.contains(
                                                            widget
                                                                .postFeedModel!
                                                                .post)) {
                                                          if (widget
                                                                  .postFeedModel!
                                                                  .post
                                                                  ?.isLiked ??
                                                              false) {
                                                            widget
                                                                .postFeedModel!
                                                                .post
                                                                ?.isLiked = false;
                                                            widget
                                                                .postFeedModel!
                                                                .post
                                                                ?.nLikes = (widget
                                                                        .postFeedModel!
                                                                        .post
                                                                        ?.nLikes ??
                                                                    1) -
                                                                1;
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                                    UnlikePostEvent(
                                                              postId: widget
                                                                  .postFeedModel!
                                                                  .postId,
                                                            ));
                                                          } else {
                                                            widget
                                                                .postFeedModel!
                                                                .post
                                                                ?.isLiked = true;
                                                            widget
                                                                .postFeedModel!
                                                                .post
                                                                ?.nLikes = (widget
                                                                        .postFeedModel!
                                                                        .post
                                                                        ?.nLikes ??
                                                                    0) +
                                                                1;
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                              LikePostEvent(
                                                                  postId: widget
                                                                      .postFeedModel!
                                                                      .postId),
                                                            );
                                                          }
                                                        }
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      child: likePost.value ||
                                                              (widget
                                                                      .postFeedModel
                                                                      ?.post
                                                                      ?.isLiked ??
                                                                  false)
                                                          ? SvgPicture.asset(
                                                              'assets/svgs/like-active.svg',
                                                              height:
                                                                  getScreenHeight(
                                                                      20),
                                                              width:
                                                                  getScreenWidth(
                                                                      20),
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/svgs/like.svg',
                                                              height:
                                                                  getScreenHeight(
                                                                      20),
                                                              width:
                                                                  getScreenWidth(
                                                                      20),
                                                            ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            getScreenWidth(8)),
                                                    FittedBox(
                                                      child: Text(
                                                        '${post.value.post!.nLikes}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              getScreenHeight(
                                                                  12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textColor3,
                                                        ),
                                                      ),
                                                    ).paddingOnly(right: 8),
                                                    FittedBox(
                                                      child: Text(
                                                        'Likes',
                                                        style: TextStyle(
                                                          fontSize:
                                                              getScreenHeight(
                                                                  12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textColor3,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                          SizedBox(width: getScreenWidth(15)),
                                          GestureDetector(
                                            onTap: () {
                                              if (widget.postFeedModel!
                                                      .postOwnerId !=
                                                  widget.postFeedModel!
                                                      .feedOwnerId) {
                                                HapticFeedback.mediumImpact();
                                                reachDM.value = true;

                                                handleTap(
                                                    widget.postFeedModel!.post);
                                                if (active.contains(widget
                                                    .postFeedModel!.post)) {
                                                  globals.userBloc!.add(
                                                      GetRecipientProfileEvent(
                                                          email: widget
                                                              .postFeedModel!
                                                              .postOwnerId!));
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: size.width -
                                                  (size.width - 163),
                                              height: size.width -
                                                  (size.width - 50),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 11,
                                                vertical: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: widget.postFeedModel!
                                                              .postOwnerId !=
                                                          globals.userId
                                                      ? const Color(0xFFF5F5F5)
                                                      : AppColors.disabled),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CupertinoButton(
                                                    minSize: 0,
                                                    onPressed: () {
                                                      if (widget.postFeedModel!
                                                              .postOwnerId !=
                                                          widget.postFeedModel!
                                                              .feedOwnerId) {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        reachDM.value = true;

                                                        handleTap(widget
                                                            .postFeedModel!
                                                            .post);
                                                        if (active.contains(
                                                            widget
                                                                .postFeedModel!
                                                                .post)) {
                                                          globals.userBloc!.add(
                                                              GetRecipientProfileEvent(
                                                                  email: widget
                                                                      .postFeedModel!
                                                                      .postOwnerId!));
                                                        }
                                                      }
                                                    },
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/message.svg',
                                                      height:
                                                          getScreenHeight(20),
                                                      width: getScreenWidth(20),
                                                    ),
                                                  ).paddingOnly(right: 8),
                                                  FittedBox(
                                                    child: Text(
                                                      widget.postFeedModel!
                                                                  .postOwnerId ==
                                                              globals.userId
                                                          ? "Message"
                                                          : 'Reachout',
                                                      style: TextStyle(
                                                        fontSize:
                                                            getScreenHeight(12),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .textColor3,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]).paddingOnly(left: 16, bottom: 16),

                                        // shoutout and shoutdown
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onLongPress: () {
                                                if ((post.value.post
                                                                ?.nUpvotes ??
                                                            0) >
                                                        0 &&
                                                    (post.value.post?.authId ==
                                                        globals.user!.id!)) {
                                                  showPostReactors(context,
                                                      postId: post
                                                          .value.post!.postId!,
                                                      reactionType: 'Upvote');
                                                }
                                              },
                                              onTap: () {
                                                HapticFeedback.mediumImpact();
                                                handleTap(
                                                    widget.postFeedModel!.post);

                                                if (active.contains(widget
                                                    .postFeedModel!.post)) {
                                                  if ((widget.postFeedModel!
                                                              .vote ??
                                                          [])
                                                      .isEmpty) {
                                                    setState(() {
                                                      shoutoutPost.value = true;
                                                    });
                                                    globals.socialServiceBloc!
                                                        .add(VotePostEvent(
                                                      voteType: 'Upvote',
                                                      postId: widget
                                                          .postFeedModel!
                                                          .postId,
                                                    ));
                                                  } else {
                                                    globals.socialServiceBloc!
                                                        .add(
                                                            DeletePostVoteEvent(
                                                      voteId: widget
                                                          .postFeedModel!
                                                          .postId,
                                                    ));
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: size.width -
                                                    (size.width - 124),
                                                height: size.width -
                                                    (size.width - 50),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 11,
                                                  vertical: 7,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color:
                                                      const Color(0xFFF5F5F5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CupertinoButton(
                                                      minSize: 0,
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        handleTap(widget
                                                            .postFeedModel!
                                                            .post);

                                                        if (active.contains(
                                                            widget
                                                                .postFeedModel!
                                                                .post)) {
                                                          if ((widget.postFeedModel!
                                                                      .vote ??
                                                                  [])
                                                              .isEmpty) {
                                                            setState(() {
                                                              shoutoutPost
                                                                  .value = true;
                                                            });
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                                    VotePostEvent(
                                                              voteType:
                                                                  'Upvote',
                                                              postId: widget
                                                                  .postFeedModel!
                                                                  .postId,
                                                            ));
                                                          } else {
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                                    DeletePostVoteEvent(
                                                              voteId: widget
                                                                  .postFeedModel!
                                                                  .postId,
                                                            ));
                                                          }
                                                        }
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      child: shoutoutPost
                                                                      .value ==
                                                                  true ||
                                                              widget
                                                                      .postFeedModel!
                                                                      .post!
                                                                      .isVoted ==
                                                                  'Upvote'
                                                          ? SvgPicture.asset(
                                                              'assets/svgs/shoutup-active.svg',
                                                              height:
                                                                  getScreenHeight(
                                                                      20),
                                                              width:
                                                                  getScreenWidth(
                                                                      20),
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/svgs/shoutup.svg',
                                                              height:
                                                                  getScreenHeight(
                                                                      20),
                                                              width:
                                                                  getScreenWidth(
                                                                      20),
                                                            ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            getScreenWidth(8)),
                                                    FittedBox(
                                                      child: Text(
                                                        '${post.value.post!.nUpvotes}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              getScreenHeight(
                                                                  12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textColor3,
                                                        ),
                                                      ),
                                                    ).paddingOnly(right: 6),
                                                    FittedBox(
                                                      child: Text(
                                                        'Shoutout',
                                                        style: TextStyle(
                                                          fontSize:
                                                              getScreenHeight(
                                                                  12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textColor3,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: getScreenWidth(15)),
                                            GestureDetector(
                                              onLongPress: () {
                                                if ((post.value.post
                                                                ?.nDownvotes ??
                                                            0) >
                                                        0 &&
                                                    (post.value.post?.authId ==
                                                        globals.user!.id!)) {
                                                  showPostReactors(context,
                                                      postId: post
                                                          .value.post!.postId!,
                                                      reactionType: 'Downvote');
                                                }
                                              },
                                              onTap: () {
                                                HapticFeedback.mediumImpact();
                                                handleTap(
                                                    widget.postFeedModel!.post);
                                                timeLineFeedStore.shoutDown(
                                                    context,
                                                    postId: widget
                                                        .postFeedModel!
                                                        .post!
                                                        .postId!,
                                                    authId: widget
                                                        .postFeedModel!
                                                        .post!
                                                        .postOwnerProfile!
                                                        .authId!);
                                                // if (active.contains(widget
                                                //     .postFeedModel!.post)) {
                                                //   shoutdownPost.value = true;
                                                //   globals.userBloc!.add(
                                                //       GetReachRelationshipEvent(
                                                //           userIdToReach: widget
                                                //               .postFeedModel!
                                                //               .postOwnerId,
                                                //           type:
                                                //               ReachRelationshipType
                                                //                   .reacher));
                                                // }
                                              },
                                              child: Container(
                                                width: size.width -
                                                    (size.width - 163),
                                                height: size.width -
                                                    (size.width - 50),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 11,
                                                  vertical: 7,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color:
                                                      const Color(0xFFF5F5F5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CupertinoButton(
                                                      minSize: 0,
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        handleTap(widget
                                                            .postFeedModel!
                                                            .post);

                                                        if (active.contains(
                                                            widget
                                                                .postFeedModel!
                                                                .post)) {
                                                          shoutdownPost.value =
                                                              true;
                                                          globals.userBloc!.add(
                                                              GetReachRelationshipEvent(
                                                                  userIdToReach: widget
                                                                      .postFeedModel!
                                                                      .postOwnerId,
                                                                  type: ReachRelationshipType
                                                                      .reacher));
                                                        }
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      child: shoutdownPost.value
                                                          ? SvgPicture.asset(
                                                              'assets/svgs/shoutdown-active.svg',
                                                              height:
                                                                  getScreenHeight(
                                                                      20),
                                                              width:
                                                                  getScreenWidth(
                                                                      20),
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/svgs/shoutdown.svg',
                                                              height:
                                                                  getScreenHeight(
                                                                      20),
                                                              width:
                                                                  getScreenWidth(
                                                                      20),
                                                            ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            getScreenWidth(8)),
                                                    FittedBox(
                                                      child: Text(
                                                        '${widget.postFeedModel!.post!.nDownvotes}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              getScreenHeight(
                                                                  12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textColor3,
                                                        ),
                                                      ),
                                                    ).paddingOnly(right: 8),
                                                    FittedBox(
                                                      child: Text(
                                                        'Shoutdown',
                                                        style: TextStyle(
                                                          fontSize:
                                                              getScreenHeight(
                                                                  12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textColor3,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ).paddingOnly(left: 16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 21.0),
                                child: Row(
                                  children: [
                                    const Text("Comments"),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showCommentField.value =
                                                !showCommentField.value;
                                          });
                                        },
                                        icon: Icon(
                                          !showCommentField.value
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_up,
                                        ))
                                  ],
                                ),
                              ),
                              const Divider(),
                              showCommentField.value
                                  ? comments.value.isEmpty
                                      ? const Center(
                                          child: Text('No comments yet'))
                                      : ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
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
                                              key: Key(comments
                                                      .value[index].commentId ??
                                                  index.toString()),
                                              comment: comments.value[index],
                                              isLiked: comments
                                                  .value[index].isLiked!,
                                              onLike: () {
                                                print(
                                                    "${comments.value[index].isLiked}");
                                                HapticFeedback.mediumImpact();
                                                handleTap(index);
                                                if (active.contains(index)) {
                                                  if (comments.value[index]
                                                          .isLiked !=
                                                      "false") {
                                                    // comments.value[index]
                                                    //     .nLikes = (comments
                                                    //             .value[index]
                                                    //             .nLikes ??
                                                    //         1) -
                                                    //     1;

                                                    // comments.value[index]
                                                    //     .isLiked = "false";

                                                    globals.socialServiceBloc!
                                                        .add(
                                                      UnlikeCommentOnPostEvent(
                                                        commentId: comments
                                                            .value[index]
                                                            .commentId,
                                                        likeId: comments
                                                            .value[index]
                                                            .isLiked,
                                                      ),
                                                    );
                                                  } else {
                                                    // comments.value[index]
                                                    //     .nLikes = (comments
                                                    //             .value[index]
                                                    //             .nLikes ??
                                                    //         0) +
                                                    //     1;

                                                    globals.socialServiceBloc!.add(
                                                        LikeCommentOnPostEvent(
                                                      postId: comments
                                                          .value[index].postId,
                                                      commentId: comments
                                                          .value[index]
                                                          .commentId,
                                                    ));
                                                  }
                                                }
                                              },
                                              onReply: () {
                                                // HapticFeedback.mediumImpact();
                                                // reachDM.value = true;
                                                // handleTap(index);
                                                // if (active.contains(index)) {
                                                //   globals.userBloc!.add(
                                                //       GetRecipientProfileEvent(
                                                //           email: comments
                                                //               .value[index]
                                                //               .authId!));
                                                // }
                                                // commentFocusNode.requestFocus();
                                                RouteNavigators.routeReplace(
                                                    context,
                                                    CommentReach(
                                                      postFeedModel: comments
                                                          .value[index]
                                                          .toPostFeedModel(),
                                                      commentPostFeedModel:
                                                          widget.postFeedModel,
                                                      replyingComment: true,
                                                    ));
                                              },
                                            );
                                          },
                                        )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 80),
                            ]),
                          ),
                          Positioned(
                              //top: 670,
                              bottom:
                                  ((MediaQuery.of(context).size.height) * 0.01),
                              child: commentField(
                                  controller, showEmoji, commentFocusNode,
                                  postFeedModel: widget.postFeedModel,
                                  isReaching: isReaching.value))
                        ],
                      ),
                    )));
          }),
        );
      },
    );
  }

  Widget commentField(TextEditingController controller,
      foundation.ValueNotifier<bool> showEmoji, FocusNode focusNode,
      {required PostFeedModel? postFeedModel,
      bool isReaching = false,
      bool isCommentReply = false}) {
    // debugPrint("Comment option: ${widget.postFeedModel!.post!.commentOption}");
    debugPrint("PostFeedModel: ${widget.postFeedModel!.post!.content}");
    debugPrint("PostFeedModel: ${widget.postFeedModel!.profilePicture}");
    debugPrint(
        "PostModel: ${widget.postFeedModel!.post!.postOwnerProfile!.username}");
    switch (widget.postFeedModel!.post!.commentOption) {
      case "everyone":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomRoundTextField(
                    onTap: () {
                      RouteNavigators.routeReplace(
                          context,
                          CommentReach(
                            postFeedModel: postFeedModel,
                          ));
                    },
                    focusNode: focusNode,
                    verticalHeight: 0,
                    controller: controller,
                    hintText: 'Comment on this post...',
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined),
                        onPressed: () {
                          RouteNavigators.routeReplace(
                              context,
                              CommentReach(
                                  postFeedModel: widget.postFeedModel));
                        }),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      // Navigator.pop(context);
                      final image = await MediaService()
                          .pickFromGallery(context: context, maxAssets: 1);
                      if (image == null) {
                        return;
                      } else {
                        for (var e in image) {
                          RouteNavigators.routeReplace(
                              context,
                              CommentReach(
                                postFeedModel: postFeedModel,
                                mediaList: [
                                  UploadFileDto(
                                      file: e.file,
                                      fileResult: e,
                                      id: Random().nextInt(100).toString())
                                ],
                              ));
                          // _mediaList.value.add(
                          //     UploadFileDto(
                          //         file: e.file,
                          //         fileResult: e,
                          //         id: Random()
                          //             .nextInt(100)
                          //             .toString()));
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                    ))
              ],
            ),
          ),
        );
      case "people_you_follow":
        debugPrint("ïsReaching $isReaching");
        if (widget.postFeedModel!.postOwnerId == globals.userId || isReaching) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomRoundTextField(
                      onTap: () {
                        RouteNavigators.routeReplace(
                            context,
                            CommentReach(
                              postFeedModel: postFeedModel!,
                            ));
                      },
                      verticalHeight: 0,
                      controller: controller,
                      hintText: 'Comment on this post...',
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          onPressed: () {
                            showEmoji.value = !showEmoji.value;
                          }),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                      ))
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }

      case "only_people_you_mention":
        if (widget.postFeedModel!.post!.mentionList!
                .contains(globals.user!.username) ||
            (widget.postFeedModel!.post!.postOwnerProfile!.authId ==
                globals.userId)) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomRoundTextField(
                      onTap: () {
                        RouteNavigators.routeReplace(
                            context,
                            CommentReach(
                              postFeedModel: postFeedModel!,
                            ));
                      },
                      verticalHeight: 0,
                      controller: controller,
                      hintText: 'Comment on this post...',
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          onPressed: () {
                            showEmoji.value = !showEmoji.value;
                          }),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                      ))
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }

      case "none":
        return const SizedBox.shrink();

      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomRoundTextField(
                    onTap: () {
                      RouteNavigators.routeReplace(
                          context,
                          CommentReach(
                            postFeedModel: postFeedModel!,
                          ));
                    },
                    verticalHeight: 0,
                    controller: controller,
                    hintText: 'Comment on this post...',
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined),
                        onPressed: () {
                          showEmoji.value = !showEmoji.value;
                        }),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                    ))
              ],
            ),
          ),
        );
    }
  }
}

class CommentsTile extends StatefulHookWidget {
  const CommentsTile({
    Key? key,
    required this.comment,
    this.onLike,
    this.onReply,
    required this.isLiked,
  }) : super(key: key);
  final Function()? onLike, onReply;
  final CommentModel comment;
  final String isLiked;

  @override
  State<CommentsTile> createState() => _CommentsTileState();
}

class _CommentsTileState extends State<CommentsTile> {
  final _ssBloc = SocialServiceBloc();

  @override
  Widget build(BuildContext context) {
    Future<String> saveImage(Uint8List? bytes) async {
      await [Permission.storage].request();
      String time = DateTime.now().microsecondsSinceEpoch.toString();
      final name = 'screenshot_${time}_reachme';
      final result = await ImageGallerySaver.saveImage(bytes!, name: name);
      debugPrint("Result ${result['filePath']}");
      Snackbars.success(context, message: 'Image saved to Gallery');
      RouteNavigators.pop(context);
      return result['filePath'];
    }

    var commentSrc = GlobalKey();

    void takeScreenShot() async {
      RenderRepaintBoundary boundary = commentSrc.currentContext!
          .findRenderObject() as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    final _replies = useState<List<CommentReplyModel>?>(null);
    final _likedReply = useState<CommentReplyModel?>(null);
    final _replyIndex = useState<int?>(null);
    final _repliesCount = useState<int>(widget.comment.nReplies ?? 0);
    final _loadingReplies = useState<bool>(false);

    return BlocConsumer<SocialServiceBloc, SocialServiceState>(
        bloc: _ssBloc,
        listener: (context, state) {
          if (state is GetCommentRepliesSuccess) {
            _replies.value = state.replies;
            _loadingReplies.value = false;
          }
          if (state is GetCommentRepliesError) {
            _loadingReplies.value = false;
            Snackbars.error(context, message: state.error);
          }
          if (state is LikeCommentReplyError) {
            Snackbars.error(context, message: state.error);
            _likedReply.value?.isLiked = false;
            _likedReply.value?.nLikes = (_likedReply.value?.nLikes ?? 0) - 1;

            _replies.value?[_replyIndex.value!] = _likedReply.value!;
          }
          if (state is UnlikeCommentReplyError) {
            Snackbars.error(context, message: state.error);
            _likedReply.value?.isLiked = true;
            _likedReply.value?.nLikes = (_likedReply.value?.nLikes ?? 0) + 1;
            _replies.value?[_replyIndex.value!] = _likedReply.value!;
          }
          if (state is DeleteCommentReplyError) {
            Snackbars.error(context, message: state.error);
          }
          if (state is DeleteCommentReplySuccess) {
            Snackbars.success(context, message: 'Reply Deleted!');
            _repliesCount.value = _repliesCount.value - 1;
            _replies.value = [..._replies.value!]..removeAt(_replyIndex.value!);
          }
        },
        builder: (context, state) {
          return RepaintBoundary(
            key: commentSrc,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.only(
                      bottom: 0,
                      top: 10,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColors.white,
                        border: Border.all(
                          color: const Color(0xFFF5F5F5),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoButton(
                                      minSize: 0,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        final progress =
                                            ProgressHUD.of(context);
                                        progress
                                            ?.showWithText('Viewing Reacher..');
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          globals.userBloc!.add(
                                              GetRecipientProfileEvent(
                                                  email:
                                                      widget.comment.authId));
                                          widget.comment.authId ==
                                                  globals.user!.id
                                              ? RouteNavigators.route(context,
                                                  const AccountScreen())
                                              : RouteNavigators.route(
                                                  context,
                                                  RecipientAccountProfile(
                                                    recipientEmail: 'email',
                                                    recipientImageUrl: widget
                                                        .comment
                                                        .commentOwnerProfile!
                                                        .profilePicture,
                                                    recipientId:
                                                        widget.comment.authId,
                                                  ));
                                          progress?.dismiss();
                                        });
                                      },
                                      child: Row(children: [
                                        Helper.renderProfilePicture(
                                          widget.comment.commentOwnerProfile!
                                              .profilePicture,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '@${widget.comment.commentOwnerProfile!.username!}',
                                              style: TextStyle(
                                                fontSize: getScreenHeight(15),
                                                fontFamily: 'Poppins',
                                                color: AppColors.textColor2,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await showCommentTimeLineCardBottomSheet(
                                          context,
                                          downloadPost: takeScreenShot,
                                          commentModel: widget.comment,
                                        );
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        width: 40,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svgs/kebab card.svg',
                                                color: const Color(0xff717F85),
                                              ),
                                            ]),
                                      ),
                                    )
                                  ]),
                              SizedBox(height: getScreenHeight(12)),
                              widget.comment.content == null
                                  ? const SizedBox.shrink()
                                  : Text(
                                      widget.comment.content.toString(),
                                      style: TextStyle(
                                        fontSize: getScreenHeight(14),
                                        color: AppColors.textColor2,
                                      ),
                                    ),
                              if ((((widget.comment.imageMediaItems ?? [])
                                          .isNotEmpty) &&
                                      widget.comment.audioMediaItem == null) ||
                                  (widget.comment.videoMediaItem ?? '')
                                      .isNotEmpty)
                                CommentMedia(comment: widget.comment)
                                    .paddingOnly(
                                        left: 0, right: 0, bottom: 10, top: 10),
                              //else
                              //const SizedBox.shrink(),
                              widget.comment.audioMediaItem != null
                                  ? Container(
                                      height: 48,
                                      margin: const EdgeInsets.only(
                                          bottom: 4, top: 8),
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xfff5f5f5)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: CommentAudioMedia(
                                            path:
                                                widget.comment.audioMediaItem ??
                                                    '',
                                            id: widget.comment.commentId,
                                          )),
                                        ],
                                      ))
                                  : const SizedBox.shrink(),
                              SizedBox(height: getScreenHeight(10)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CupertinoButton(
                                            onPressed: widget.onLike,
                                            minSize: 0,
                                            padding: EdgeInsets.zero,
                                            child: widget.comment.isLiked !=
                                                    "false"
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
                                              widget.comment.nLikes.toString(),
                                              style: TextStyle(
                                                fontSize: getScreenHeight(12),
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textColor3,
                                              ),
                                            ),
                                          ),
                                          // if (comment.authId != globals.user!.id!)
                                          //   SizedBox(width: getScreenWidth(15)),
                                          // if (comment.authId != globals.user!.id!)
                                          SizedBox(width: getScreenWidth(15)),
                                          CupertinoButton(
                                            onPressed: widget.onReply,
                                            minSize: 0,
                                            padding: EdgeInsets.zero,
                                            child: SvgPicture.asset(
                                              'assets/svgs/comment.svg',
                                              height: getScreenHeight(20),
                                              width: getScreenWidth(20),
                                            ),
                                          ),
                                          SizedBox(width: getScreenWidth(4)),
                                          FittedBox(
                                            child: Text(
                                              _repliesCount.value.toString(),
                                              style: TextStyle(
                                                fontSize: getScreenHeight(12),
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textColor3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: getScreenWidth(20)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if ((widget.comment.nReplies ?? 0) == 0)
                          const SizedBox(
                            height: 12,
                          ),
                        if ((widget.comment.nReplies ?? 0) > 0)
                          Container(
                            margin: EdgeInsets.only(
                              top: 16,
                            ),
                            height: 1,
                            color: const Color(0xFFF5F5F5),
                          ),
                        if ((widget.comment.nReplies ?? 0) > 0 &&
                            (_replies.value ?? []).isEmpty)
                          GestureDetector(
                              onTap: _loadingReplies.value
                                  ? null
                                  : () {
                                      _loadingReplies.value = true;
                                      _ssBloc.add(GetCommentRepliesEvent(
                                          postId: widget.comment.postId!,
                                          commentId: widget.comment.commentId!,
                                          pageLimit: 50,
                                          pageNumber: 1));
                                    },
                              child: Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: !_loadingReplies.value
                                      ? Text(
                                          'View Replies...',
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ))),
                        if ((_replies.value ?? []).isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Replies..'),
                              ),
                              ListView.separated(
                                padding: EdgeInsets.only(bottom: 10),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (_replies.value ?? []).length,
                                itemBuilder: (c, i) {
                                  final _reply = (_replies.value ?? [])[i];
                                  return CommentReplyItem(
                                      comment: _reply,
                                      onDelete: () {
                                        _likedReply.value = _reply;
                                        _replyIndex.value = i;
                                        Snackbars.success(context,
                                            message: 'Deleting Reply...');
                                        _ssBloc.add(DeleteCommentReplyEvent(
                                          postId: widget.comment.postId!,
                                          replyId: _reply.replyId!,
                                        ));
                                      },
                                      onLike: () {
                                        _likedReply.value = _reply;
                                        _replyIndex.value = i;
                                        if (_reply.isLiked ?? false) {
                                          _reply.isLiked = false;
                                          _replies.value![i] = _reply;
                                          _reply.nLikes =
                                              (_reply.nLikes ?? 0) - 1;
                                          _ssBloc.add(UnlikeCommentReplyEvent(
                                            replyId: _reply.replyId!,
                                          ));
                                        } else {
                                          _reply.isLiked = true;
                                          _reply.nLikes =
                                              (_reply.nLikes ?? 0) + 1;
                                          _replies.value![i] = _reply;
                                          _ssBloc.add(LikeCommentReplyEvent(
                                              postId: widget.comment.postId!,
                                              replyId: _reply.replyId!,
                                              commentId:
                                                  widget.comment.commentId!));
                                        }
                                      },
                                      isLiked: _reply.isLiked);
                                  // return CommentsTile(comment: comment, isLiked: '');
                                },
                                separatorBuilder: (c, i) => SizedBox(
                                  height: 4,
                                ),
                              ),
                            ],
                          )
                      ],
                    )).paddingOnly(bottom: 10, right: 16, left: 16),
              ],
            ),
          );
        });
  }
}

class CommentReplyItem extends StatelessWidget {
  const CommentReplyItem({
    Key? key,
    required this.comment,
    this.onLike,
    this.onDelete,
    required this.isLiked,
  }) : super(key: key);
  final Function()? onLike, onDelete;
  final CommentReplyModel comment;
  final bool? isLiked;
  @override
  Widget build(BuildContext context) {
    Future<String> saveImage(Uint8List? bytes) async {
      await [Permission.storage].request();
      String time = DateTime.now().microsecondsSinceEpoch.toString();
      final name = 'screenshot_${time}_reachme';
      final result = await ImageGallerySaver.saveImage(bytes!, name: name);
      debugPrint("Result ${result['filePath']}");
      Snackbars.success(context, message: 'Image saved to Gallery');
      RouteNavigators.pop(context);
      return result['filePath'];
    }

    var commentSrc = GlobalKey();

    void takeScreenShot() async {
      RenderRepaintBoundary boundary = commentSrc.currentContext!
          .findRenderObject() as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    return RepaintBoundary(
      key: commentSrc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(
                bottom: 10,
                top: 10,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.white,
                  border: Border.all(
                    color: const Color(0xFFF5F5F5),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  final progress = ProgressHUD.of(context);
                                  progress?.showWithText('Viewing Reacher..');
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    globals.userBloc!.add(
                                        GetRecipientProfileEvent(
                                            email: comment
                                                .replyOwnerProfile?.authId));
                                    comment.replyOwnerProfile?.authId ==
                                            globals.user!.id
                                        ? RouteNavigators.route(
                                            context, const AccountScreen())
                                        : RouteNavigators.route(
                                            context,
                                            RecipientAccountProfile(
                                              recipientEmail: 'email',
                                              recipientImageUrl: comment
                                                  .replyOwnerProfile!
                                                  .profilePicture,
                                              recipientId: comment
                                                  .replyOwnerProfile?.authId,
                                            ));
                                    progress?.dismiss();
                                  });
                                },
                                child: Row(children: [
                                  Helper.renderProfilePicture(
                                    comment.replyOwnerProfile?.profilePicture,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '@${comment.replyOwnerProfile?.username ?? 'no-username'}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          fontFamily: 'Poppins',
                                          color: AppColors.textColor2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                              if (comment.authId == globals.user!.id)
                                InkWell(
                                  onTap: () async {
                                    final res = await showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                KebabBottomTextButton(
                                                    label: 'Delete Reply',
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    }),
                                              ],
                                            ));
                                    if (res == null) return;
                                    if (onDelete != null) onDelete!();
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    width: 40,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svgs/kebab card.svg',
                                            color: const Color(0xff717F85),
                                          ),
                                        ]),
                                  ),
                                )
                            ]),
                        SizedBox(height: getScreenHeight(12)),
                        comment.content == null
                            ? const SizedBox.shrink()
                            : Text(
                                comment.content.toString(),
                                style: TextStyle(
                                  fontSize: getScreenHeight(14),
                                  color: AppColors.textColor2,
                                ),
                              ),
                        if ((((comment.imageMediaItems ?? []).isNotEmpty) &&
                                comment.audioMediaItem == null) ||
                            (comment.videoMediaItem ?? '').isNotEmpty)
                          CommentMedia(comment: comment.toCommentModel())
                              .paddingOnly(
                                  left: 0, right: 0, bottom: 8, top: 10),
                        //else
                        //const SizedBox.shrink(),
                        comment.audioMediaItem != null
                            ? Container(
                                height: 44,
                                margin:
                                    const EdgeInsets.only(bottom: 2, top: 8),
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xfff5f5f5)),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CommentAudioMedia(
                                      isCommentReply: true,
                                      path: comment.audioMediaItem ?? '',
                                      id: comment.commentId,
                                    )),
                                  ],
                                ))
                            : const SizedBox.shrink(),
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
                                      child: isLiked ?? false
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
                                    // if (comment.authId != globals.user!.id!)
                                    //   SizedBox(width: getScreenWidth(15)),
                                    // if (comment.authId != globals.user!.id!)
                                    SizedBox(width: getScreenWidth(15)),
                                    // CupertinoButton(
                                    //   onPressed: onReply,
                                    //   minSize: 0,
                                    //   padding: EdgeInsets.zero,
                                    //   child: SvgPicture.asset(
                                    //     'assets/svgs/comment.svg',
                                    //     height: getScreenHeight(20),
                                    //     width: getScreenWidth(20),
                                    //   ),
                                    // ),
                                    // SizedBox(width: getScreenWidth(4)),
                                    // FittedBox(
                                    //   child: Text(
                                    //     comment.nLikes.toString(),
                                    //     style: TextStyle(
                                    //       fontSize: getScreenHeight(12),
                                    //       fontWeight: FontWeight.w500,
                                    //       color: AppColors.textColor3,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: getScreenWidth(20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )).paddingOnly(bottom: 10, right: 16, left: 16),
        ],
      ),
    );
  }
}
