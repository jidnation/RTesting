import 'dart:io';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/comment_reach.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:reach_me/features/home/presentation/views/view_comments.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:ui' as ui;

import '../../../../core/components/bottom_sheet_list_tile.dart';
import '../../../../core/components/refresher.dart';
import '../../../../core/components/snackbar.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../account/presentation/views/account.dart';
import '../../../account/presentation/widgets/bottom_sheets.dart';
import '../../../chat/presentation/views/msg_chat_interface.dart';

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
  Widget build(BuildContext context) {
    final post = useState<PostFeedModel>(widget.postFeedModel!);
    final postDuration = timeago.format(widget.postFeedModel!.post!.createdAt!);
    final size = MediaQuery.of(context).size;
    final controller = useTextEditingController();
    final showEmoji = useState(false);
    final showCommentField = useState(true);
    final reachUser = useState(false);
    final starUser = useState(false);
    final likePost = useState(false);
    final shoutoutPost = useState(false);
    final shoutdownPost = useState(false);
    Set active = {};

    handleTap() {
      if (active.isNotEmpty) active.clear();
      setState(() {
        active.add(widget.postFeedModel);
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

    Future showFullPostReacherCardBottomSheet(BuildContext context,
        {required PostFeedModel postFeedModel, void Function()? downloadPost}) {
      return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return BlocConsumer<SocialServiceBloc, SocialServiceState>(
            bloc: globals.socialServiceBloc,
            listener: (context, state) {
              if (state is GetPostSuccess) {
                globals.socialServiceBloc!
                    .add(GetPostEvent(postId: widget.postFeedModel!.postId));
                _refreshController.refreshCompleted();
              }
              if (state is GetPostError) {
                RouteNavigators.pop(context);
                Snackbars.error(context, message: state.error);
              }
              if (state is SavePostSuccess) {
                RouteNavigators.pop(context);
                Snackbars.success(context, message: 'Post saved successfully');
              }
              if (state is SavePostError) {
                RouteNavigators.pop(context);
                Snackbars.error(context, message: state.error);
              }
              if (state is DeleteSavedPostSuccess) {
                RouteNavigators.pop(context);
                Snackbars.success(context,
                    message: 'Post removed successfully');
              }
              if (state is DeleteSavedPostError) {
                RouteNavigators.pop(context);
                Snackbars.error(context, message: state.error);
              }
            },
            builder: (context, state) {
              bool _isLoading = state is GetPostLoading;
              return BlocConsumer<UserBloc, UserState>(
                bloc: globals.userBloc,
                listener: (context, state) {
                  if (state is UserLoading) {
                    // globals.showLoader(context);
                  }
                  if (state is UserError) {
                    RouteNavigators.pop(context);
                    RouteNavigators.pop(context);
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is StarUserSuccess) {
                    RouteNavigators.pop(context);
                    Snackbars.success(context,
                        message: 'User starred successfully!');
                  }
                },
                builder: (context, state) {
                  return Container(
                      decoration: const BoxDecoration(
                        color: AppColors.greyShade7,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: ListView(shrinkWrap: true, children: [
                        Center(
                          child: Container(
                              height: getScreenHeight(4),
                              width: getScreenWidth(58),
                              decoration: BoxDecoration(
                                  color: AppColors.greyShade4,
                                  borderRadius: BorderRadius.circular(40))),
                        ).paddingOnly(t: 23),
                        SizedBox(height: getScreenHeight(20)),
                        if (postFeedModel.postOwnerId !=
                            postFeedModel.feedOwnerId)
                          Column(
                            children: [
                              KebabBottomTextButton(
                                  label: 'Share post',
                                  onPressed: () {
                                    RouteNavigators.pop(context);
                                    Share.share(
                                        'Have fun viewing this: ${postFeedModel.post!.postSlug!}');
                                  }),
                              KebabBottomTextButton(
                                  label: 'Save post',
                                  onPressed: () {
                                    globals.socialServiceBloc!.add(
                                        SavePostEvent(
                                            postId: postFeedModel.postId));
                                  }),
                              KebabBottomTextButton(
                                  label: 'takeScreenShot',
                                  onPressed: takeScreenShot),
                              KebabBottomTextButton(
                                label: reachUser.value
                                    ? "Unreach user"
                                    : 'Reach user',
                                onPressed: () {
                                  globals.showLoader(context);
                                  if (reachUser.value) {
                                  } else {
                                    globals.userBloc!.add(ReachUserEvent(
                                        userIdToReach:
                                            postFeedModel.postOwnerId));
                                  }
                                },
                              ),
                              KebabBottomTextButton(
                                label: starUser.value
                                    ? 'Unstar user'
                                    : 'Star user',
                                onPressed: () {
                                  if (starUser.value) {
                                    setState(() {
                                      starUser.value = true;
                                    });
                                  } else {
                                    globals.showLoader(context);
                                    globals.userBloc!.add(StarUserEvent(
                                        userIdToStar:
                                            postFeedModel.postOwnerId));
                                    setState(() {
                                      starUser.value = false;
                                    });
                                  }
                                },
                              ),
                              KebabBottomTextButton(
                                label: 'Copy link',
                                onPressed: () {
                                  RouteNavigators.pop(context);
                                  Clipboard.setData(ClipboardData(
                                      text: postFeedModel.post!.postSlug!));
                                  Snackbars.success(context,
                                      message: 'Link copied to clipboard');
                                },
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              KebabBottomTextButton(
                                  label: 'Edit content',
                                  isLoading: _isLoading,
                                  onPressed: () {
                                    globals.socialServiceBloc!.add(GetPostEvent(
                                        postId: postFeedModel.postId));
                                  }),
                              KebabBottomTextButton(
                                  label: 'Delete post',
                                  onPressed: () {
                                    globals.socialServiceBloc!.add(
                                        DeletePostEvent(
                                            postId: postFeedModel.postId));
                                    RouteNavigators.pop(context);
                                  }),
                              KebabBottomTextButton(
                                label: 'Share Post',
                                onPressed: () {
                                  RouteNavigators.pop(context);
                                  Share.share(
                                      'Have fun viewing this: ${postFeedModel.post!.postSlug!}');
                                },
                              ),
                              KebabBottomTextButton(
                                  label: 'take ScreenShot',
                                  onPressed: takeScreenShot),
                              KebabBottomTextButton(
                                label: 'Copy link',
                                onPressed: () {
                                  RouteNavigators.pop(context);
                                  Clipboard.setData(ClipboardData(
                                      text: postFeedModel.post!.postSlug!));
                                  Snackbars.success(context,
                                      message: 'Link copied to clipboard');
                                },
                              ),
                            ],
                          ),
                        SizedBox(height: getScreenHeight(20)),
                      ]));
                },
              );
            },
          );
        },
      );
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
      },
      builder: (context, state) {
        return BlocConsumer<SocialServiceBloc, SocialServiceState>(
          bloc: globals.socialServiceBloc,
          listener: ((context, state) {
            if (state is VotePostSuccess) {}

            if (state is LikePostSuccess || state is UnlikePostSuccess) {
              debugPrint("Like Post Success");
              globals.socialServiceBloc!
                  .add(GetPostEvent(postId: widget.postFeedModel!.postId));
            }
            if (state is GetPostSuccess) {
              debugPrint("Get Post Success");
              post.value.post!.nLikes = state.data!.nLikes;
              post.value.post!.nUpvotes = state.data!.nUpvotes;
              post.value.post!.nDownvotes = state.data!.nDownvotes;
            }
          }),
          builder: ((context, state) {
            return Refresher(
              onRefresh: onRefresh,
              controller: _refreshController,
              child: SafeArea(
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
                      body: SingleChildScrollView(
                        child: Column(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                progress?.dismiss();
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Helper.renderProfilePicture(
                                                  widget.postFeedModel!
                                                      .profilePicture,
                                                  size: 33,
                                                ).paddingOnly(l: 13, t: 10),
                                                SizedBox(
                                                    width: getScreenWidth(9)),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                FontWeight.w500,
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
                                                          widget.postFeedModel!.post!
                                                                      .location! ==
                                                                  'nil'
                                                              ? ''
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
                                                            letterSpacing: 0.4,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                                            letterSpacing: 0.4,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                                  await showFullPostReacherCardBottomSheet(
                                                      context,
                                                      postFeedModel: widget
                                                          .postFeedModel!);
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
                                          : Flexible(
                                              child: ReadMoreText(
                                                widget.postFeedModel!.post!
                                                        .edited!
                                                    ? "${widget.postFeedModel!.post!.content ?? ''} (reach edited)"
                                                    : widget.postFeedModel!
                                                            .post!.content ??
                                                        '',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        getScreenHeight(14)),
                                                trimLines: 3,
                                                colorClickableText:
                                                    const Color(0xff717F85),
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: 'See more',
                                                trimExpandedText: 'See less',
                                                moreStyle: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(14),
                                                    fontFamily: "Roboto",
                                                    color: const Color(
                                                        0xff717F85)),
                                              ).paddingSymmetric(h: 16, v: 10),
                                            ),
                                      if (widget.postFeedModel!.post!
                                          .imageMediaItems!.isNotEmpty)
                                        Helper.renderPostImages(
                                                widget.postFeedModel!.post!,
                                                context)
                                            .paddingOnly(
                                                r: 16, l: 16, b: 16, t: 10)
                                      else
                                        const SizedBox.shrink(),

                                      // likes and message
                                      Row(
                                        children: [
                                          Container(
                                            width:
                                                size.width - (size.width - 124),
                                            height:
                                                size.width - (size.width - 50),
                                            padding: const EdgeInsets.symmetric(
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
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CupertinoButton(
                                                  minSize: 0,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .mediumImpact();
                                                    handleTap();
                                                    if (active.contains(
                                                        widget.postFeedModel)) {
                                                      if (widget.postFeedModel!
                                                          .like!.isNotEmpty) {
                                                        globals
                                                            .socialServiceBloc!
                                                            .add(
                                                                UnlikePostEvent(
                                                          postId: widget
                                                              .postFeedModel!
                                                              .postId,
                                                        ));
                                                        setState(() {
                                                          likePost.value =
                                                              false;
                                                        });
                                                      } else {
                                                        globals
                                                            .socialServiceBloc!
                                                            .add(
                                                          LikePostEvent(
                                                              postId: widget
                                                                  .postFeedModel!
                                                                  .postId),
                                                        );
                                                        setState(() {
                                                      likePost.value =
                                                          true;
                                                    });
                                                      }
                                                    }
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  child: !likePost.value
                                                      ? SvgPicture.asset(
                                                          'assets/svgs/like-active.svg',
                                                          height:
                                                              getScreenHeight(
                                                                  20),
                                                          width: getScreenWidth(
                                                              20),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svgs/like.svg',
                                                          height:
                                                              getScreenHeight(
                                                                  20),
                                                          width: getScreenWidth(
                                                              20),
                                                        ),
                                                ),
                                                SizedBox(
                                                    width: getScreenWidth(8)),
                                                FittedBox(
                                                  child: Text(
                                                    '${post.value.post!.nLikes}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          getScreenHeight(12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor3,
                                                    ),
                                                  ),
                                                ).paddingOnly(r: 8),
                                                FittedBox(
                                                  child: Text(
                                                    'Likes',
                                                    style: TextStyle(
                                                      fontSize:
                                                          getScreenHeight(12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor3,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: getScreenWidth(15)),
                                          Container(
                                            width:
                                                size.width - (size.width - 163),
                                            height:
                                                size.width - (size.width - 50),
                                            padding: const EdgeInsets.symmetric(
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
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (widget.postFeedModel!
                                                        .postOwnerId !=
                                                    widget.postFeedModel!
                                                        .feedOwnerId)
                                                  CupertinoButton(
                                                    minSize: 0,
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .mediumImpact();
                                                      reachDM.value = true;

                                                      handleTap();
                                                      if (active.contains(widget
                                                          .postFeedModel)) {
                                                        globals.userBloc!.add(
                                                            GetRecipientProfileEvent(
                                                                email: widget
                                                                    .postFeedModel!
                                                                    .postOwnerId!));
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
                                                  ).paddingOnly(r: 8),
                                                FittedBox(
                                                  child: Text(
                                                    'Message user',
                                                    style: TextStyle(
                                                      fontSize:
                                                          getScreenHeight(12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor3,
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
                                            width:
                                                size.width - (size.width - 124),
                                            height:
                                                size.width - (size.width - 50),
                                            padding: const EdgeInsets.symmetric(
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
                                                  MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CupertinoButton(
                                                  minSize: 0,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .mediumImpact();
                                                    handleTap();
                                                    if (active.contains(
                                                        widget.postFeedModel)) {
                                                      globals.socialServiceBloc!
                                                          .add(VotePostEvent(
                                                        voteType: 'Upvote',
                                                        postId: widget
                                                            .postFeedModel!
                                                            .postId,
                                                      ));
                                                    }
                                                    setState(() {
                                                      shoutoutPost.value =
                                                          !shoutoutPost.value;
                                                    });
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  child: !shoutoutPost.value
                                                      ? SvgPicture.asset(
                                                          'assets/svgs/shoutup-active.svg',
                                                          height:
                                                              getScreenHeight(
                                                                  20),
                                                          width: getScreenWidth(
                                                              20),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svgs/shoutup.svg',
                                                          height:
                                                              getScreenHeight(
                                                                  20),
                                                          width: getScreenWidth(
                                                              20),
                                                        ),
                                                ),
                                                SizedBox(
                                                    width: getScreenWidth(8)),
                                                FittedBox(
                                                  child: Text(
                                                    '${post.value.post!.nUpvotes}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          getScreenHeight(12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor3,
                                                    ),
                                                  ),
                                                ).paddingOnly(r: 6),
                                                FittedBox(
                                                  child: Text(
                                                    'Shoutout',
                                                    style: TextStyle(
                                                      fontSize:
                                                          getScreenHeight(12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor3,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: getScreenWidth(15)),
                                          Container(
                                            width:
                                                size.width - (size.width - 163),
                                            height:
                                                size.width - (size.width - 50),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 11,
                                              vertical: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xFFF5F5F5),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CupertinoButton(
                                                  minSize: 0,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .mediumImpact();
                                                    handleTap();
                                                    if (active.contains(
                                                        widget.postFeedModel)) {
                                                      globals.socialServiceBloc!
                                                          .add(VotePostEvent(
                                                        voteType: 'Downvote',
                                                        postId: widget
                                                            .postFeedModel!
                                                            .postId,
                                                      ));
                                                    }
                                                    setState(() {
                                                      shoutdownPost.value =
                                                          !shoutdownPost.value;
                                                    });
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  child: !shoutdownPost.value
                                                      ? SvgPicture.asset(
                                                          'assets/svgs/shoutdown-active.svg',
                                                          height:
                                                              getScreenHeight(
                                                                  20),
                                                          width: getScreenWidth(
                                                              20),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svgs/shoutdown.svg',
                                                          height:
                                                              getScreenHeight(
                                                                  20),
                                                          width: getScreenWidth(
                                                              20),
                                                        ),
                                                ),
                                                SizedBox(
                                                    width: getScreenWidth(8)),
                                                FittedBox(
                                                  child: Text(
                                                    '${widget.postFeedModel!.post!.nLikes}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          getScreenHeight(12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor3,
                                                    ),
                                                  ),
                                                ).paddingOnly(r: 8),
                                                FittedBox(
                                                  child: Text(
                                                    'Shoutdown',
                                                    style: TextStyle(
                                                      fontSize:
                                                          getScreenHeight(12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor3,
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
                            if (widget
                                .postFeedModel!.post!.imageMediaItems!.isEmpty)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              )
                            else
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 21.0),
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
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down))
                                ],
                              ),
                            ),
                            const Divider(),
                            showEmoji.value
                                ? buildEmoji()
                                : const SizedBox.shrink(),
                            showCommentField.value
                                ? commentField(controller, showEmoji,
                                    postFeedModel: widget.postFeedModel!)
                                : const SizedBox.shrink()
                          ],
                        ),
                      ))),
            );
          }),
        );
      },
    );
  }

  Padding commentField(TextEditingController controller,
      foundation.ValueNotifier<bool> showEmoji,
      {required PostFeedModel postFeedModel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21.0),
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
    );
  }
}
