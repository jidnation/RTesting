import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/comment_reach.dart';
import 'package:reach_me/features/home/presentation/widgets/comment_media.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/components/bottom_sheet_list_tile.dart';
import '../../../../core/components/snackbar.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../account/presentation/views/account.dart';
import '../../../account/presentation/widgets/bottom_sheets.dart';
import '../../../chat/presentation/views/msg_chat_interface.dart';
import '../../../dictionary/presentation/widgets/view_words_dialog.dart';
import '../../data/models/comment_model.dart';
import '../widgets/post_media.dart';

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
    final likeId = useState<String?>(null);
    final reachingList = useState<List<VirtualReach>?>([]);
    final isReaching = useState(false);
    useMemoized(() {
      globals.userBloc!.add(GetReachRelationshipEvent(
          userIdToReach: widget.postFeedModel!.postOwnerId,
          type: ReachRelationshipType.reacher));
    });

    useMemoized(() {
      globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
          postId: widget.postFeedModel!.postId, pageLimit: 50, pageNumber: 1));
    });

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

    Widget buildEmoji() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: EmojiPicker(
          textEditingController: controller,
          config: Config(
            columns: 7,
            emojiSizeMax:
                32 * (!foundation.kIsWeb && Platform.isIOS ? 1.30 : 1.0),
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
            replaceEmojiOnLimitExceed: false,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
            checkPlatformCompatibility: true,
          ),
          onBackspacePressed: () {
            controller.text.substring(0, controller.text.length - 1);
          },
        ),
      );
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
              debugPrint("Shoutdown success");
              Snackbars.success(context,
                  message: 'You shouted down on this user\'s posts');
              RouteNavigators.pop(context);
              globals.socialServiceBloc!
                  .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
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
        return BlocConsumer<SocialServiceBloc, SocialServiceState>(
          bloc: globals.socialServiceBloc,
          listener: ((context, state) {
            if (state is VotePostSuccess) {
              if (!(state.isVoted!)) {
                Snackbars.success(context,
                    message: 'The post you shouted down has been removed!');
              } else {
                Snackbars.success(context, message: 'You shouted at this post');
              }
              globals.socialServiceBloc!
                  .add(GetPostEvent(postId: widget.postFeedModel!.postId));
            }
            if (state is LikePostSuccess || state is UnlikePostSuccess) {
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
                          RouteNavigators.pop(context);
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
                            child: ListView(
                              children: [
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
                                                          const AccountScreen())
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
                                                    ).paddingOnly(l: 13, t: 10),
                                                    SizedBox(
                                                        width:
                                                            getScreenWidth(9)),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                              widget
                                                                              .postFeedModel!
                                                                              .post!
                                                                              .location! ==
                                                                          'nil' ||
                                                                      widget.postFeedModel!.post!.location! ==
                                                                          'NIL' ||
                                                                      widget.postFeedModel!.post!
                                                                              .location ==
                                                                          null
                                                                  ? ''
                                                                  : widget.postFeedModel!.post!.location!
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
                                                        postFeedModel: widget
                                                            .postFeedModel!,
                                                      );
                                                    },
                                                    iconSize:
                                                        getScreenHeight(19),
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .primaryColor),
                                                  onPrefixTap: () {
                                                    tooltipkey.currentState
                                                        ?.ensureTooltipVisible();
                                                  },
                                                  expandText: 'see more',
                                                  maxLines: 2,
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
                                                    print('Tapped Url');
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
                                                  h: 16, v: 10),
                                          Tooltip(
                                            key: tooltipkey,
                                            triggerMode:
                                                TooltipTriggerMode.manual,
                                            showDuration:
                                                const Duration(seconds: 1),
                                            message:
                                                'This reach has been edited',
                                          ),
                                          if ((widget.postFeedModel?.post
                                                          ?.imageMediaItems ??
                                                      [])
                                                  .isNotEmpty ||
                                              (widget.postFeedModel?.post
                                                          ?.videoMediaItem ??
                                                      '')
                                                  .isNotEmpty)
                                            PostMedia(
                                                    post: widget
                                                        .postFeedModel!.post!)
                                                .paddingOnly(
                                                    r: 16, l: 16, b: 16, t: 10)
                                          else
                                            const SizedBox.shrink(),
                                          (widget.postFeedModel?.post
                                                          ?.audioMediaItem ??
                                                      '')
                                                  .isNotEmpty
                                              ? PostAudioMedia(
                                                      path: widget
                                                          .postFeedModel!
                                                          .post!
                                                          .audioMediaItem!)
                                                  .paddingOnly(
                                                      l: 16, r: 16, b: 10, t: 0)
                                              : const SizedBox.shrink(),

                                          // likes and message
                                          Row(
                                            children: [
                                              Container(
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
                                                        // Console.log(
                                                        //     'Like Data',
                                                        //     _posts.value[index]
                                                        //         .toJson());
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
                                                              widget
                                                                  .postFeedModel!
                                                                  .post!
                                                                  .isLiked!
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
                                                    ).paddingOnly(r: 8),
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
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  width: getScreenWidth(15)),
                                              Container(
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
                                                        BorderRadius.circular(
                                                            12),
                                                    color: widget.postFeedModel!
                                                                .postOwnerId !=
                                                            globals.userId
                                                        ? const Color(
                                                            0xFFF5F5F5)
                                                        : AppColors.disabled),
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
                                                        if (widget
                                                                .postFeedModel!
                                                                .postOwnerId !=
                                                            widget
                                                                .postFeedModel!
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
                                                          const EdgeInsets.all(
                                                              0),
                                                      child: SvgPicture.asset(
                                                        'assets/svgs/message.svg',
                                                        height:
                                                            getScreenHeight(20),
                                                        width:
                                                            getScreenWidth(20),
                                                      ),
                                                    ).paddingOnly(r: 8),
                                                    FittedBox(
                                                      child: Text(
                                                        widget.postFeedModel!
                                                                    .postOwnerId ==
                                                                globals.userId
                                                            ? "Message"
                                                            : 'Message user',
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
                                            ],
                                          ).paddingOnly(l: 16, b: 16),

                                          // shoutout and shoutdown
                                          Row(
                                            children: [
                                              Container(
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
                                                    ).paddingOnly(r: 6),
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
                                              SizedBox(
                                                  width: getScreenWidth(15)),
                                              Container(
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
                                                    ).paddingOnly(r: 8),
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
                                            ],
                                          ).paddingOnly(l: 16)
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
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down))
                                    ],
                                  ),
                                ),
                                const Divider(),
                                showCommentField.value
                                    ? Expanded(
                                        child: comments.value.isEmpty
                                            ? const Center(
                                                child: Text('No comments yet'))
                                            : ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                controller: scrollController,
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                itemCount:
                                                    comments.value.length,
                                                itemBuilder: (context, index) {
                                                  // if (comments
                                                  //         .value[index].audioMediaItem ==
                                                  //     null) {
                                                  //   comments.value[index].audioMediaItem =
                                                  //       ' ';
                                                  // }
                                                  return CommentsTile(
                                                    comment:
                                                        comments.value[index],
                                                    isLiked: comments
                                                                .value[index]
                                                                .isLiked ??
                                                            false
                                                        ? true
                                                        : false,
                                                    onLike: () {
                                                      print(
                                                          "${comments.value[index].isLiked}");
                                                      HapticFeedback
                                                          .mediumImpact();
                                                      handleTap(index);
                                                      if (active
                                                          .contains(index)) {
                                                        if (comments
                                                            .value[index]
                                                            .isLiked!) {
                                                          comments.value[index]
                                                              .isLiked = false;

                                                          comments.value[index]
                                                              .nLikes = (comments
                                                                      .value[
                                                                          index]
                                                                      .nLikes ??
                                                                  1) -
                                                              1;
                                                          globals
                                                              .socialServiceBloc!
                                                              .add(GetAllCommentLikesEvent(
                                                                  commentId: comments
                                                                      .value[
                                                                          index]
                                                                      .commentId));

                                                          if (likeId.value !=
                                                              null) {
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                              UnlikeCommentOnPostEvent(
                                                                  commentId: comments
                                                                      .value[
                                                                          index]
                                                                      .commentId!,
                                                                  likeId: likeId
                                                                      .value

                                                                  //commentLike
                                                                  //  .value!.likeId!,
                                                                  ),
                                                            );
                                                          }
                                                        } else {
                                                          comments.value[index]
                                                              .isLiked = true;
                                                          comments.value[index]
                                                              .nLikes = (comments
                                                                      .value[
                                                                          index]
                                                                      .nLikes ??
                                                                  0) +
                                                              1;
                                                          globals
                                                              .socialServiceBloc!
                                                              .add(
                                                                  LikeCommentOnPostEvent(
                                                            postId: comments
                                                                .value[index]
                                                                .postId,
                                                            commentId: comments
                                                                .value[index]
                                                                .commentId,
                                                          ));
                                                        }
                                                      }
                                                    },
                                                    onMessage: () {
                                                      HapticFeedback
                                                          .mediumImpact();
                                                      reachDM.value = true;
                                                      handleTap(index);
                                                      if (active
                                                          .contains(index)) {
                                                        globals.userBloc!.add(
                                                            GetRecipientProfileEvent(
                                                                email: comments
                                                                    .value[
                                                                        index]
                                                                    .authId!));
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                          Positioned(
                              //top: 670,
                              bottom:
                                  ((MediaQuery.of(context).size.height) * 0.01),
                              child: commentField(controller, showEmoji,
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
      foundation.ValueNotifier<bool> showEmoji,
      {required PostFeedModel? postFeedModel, bool isReaching = false}) {
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
                      RouteNavigators.route(
                          context,
                          CommentReach(
                            postFeedModel: postFeedModel,
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
                        RouteNavigators.route(
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
            .contains(globals.user!.username)) {
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
                        RouteNavigators.route(
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
                      RouteNavigators.route(
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
            border: Border.all(
              color: const Color(0xFFF5F5F5),
            )),
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
            if (comment.content!.isNotEmpty && comment.audioMediaItem == null)
              Text(
                comment.content!,
                style: TextStyle(
                  fontSize: getScreenHeight(14),
                  color: AppColors.textColor2,
                ),
              )
            else if (comment.audioMediaItem!.isNotEmpty)
              CommentAudioMedia(path: comment.audioMediaItem!)
                  .paddingOnly(r: 0, l: 0, b: 10, t: 0)
            else
              const SizedBox.shrink(),
            comment.imageMediaItems!.isNotEmpty
                ? CommentMedia(comment: comment)
                    .paddingOnly(l: 16, r: 16, b: 10, t: 0)
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
