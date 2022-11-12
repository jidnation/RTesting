import 'dart:io';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/components/refresher.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/helpers.dart';
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
    final postDuration = timeago.format(widget.postFeedModel!.post!.createdAt!);
    final size = MediaQuery.of(context).size;
    final controller = useTextEditingController();
    final showEmoji = useState(false);

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
          .add(GetLikesOnPostEvent(postId: widget.postFeedModel!.postId));
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
            if (state is VotePostSuccess) {
              // if (!(state.isVoted!)) {
              //   Snackbars.success(context,
              //       message: 'You shouted down on this post');
              // }
              globals.socialServiceBloc!
                  .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
              _refreshController.refreshCompleted();
            }

            if (state is LikePostSuccess || state is UnlikePostSuccess) {
              globals.socialServiceBloc!
                  .add(GetPostEvent(postId: widget.postFeedModel!.postId));
              _refreshController.refreshCompleted();
            }
          }),
          builder: ((context, state) {
            bool isLikingPosts = state is LikePostLoading;
            bool _unLikingPost = state is UnlikePostLoading;
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
                      // extendBodyBehindAppBar: true,
                      backgroundColor: const Color(0xffFFFFFF),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: getScreenWidth(16),
                                left: getScreenWidth(16),
                                bottom: getScreenHeight(16),
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
                                          onPressed: () {},
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
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '@${widget.postFeedModel!.username!}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              getScreenHeight(
                                                                  14),
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textColor2,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 3),
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
                                                          fontFamily: 'Poppins',
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
                                                          fontFamily: 'Poppins',
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
                                            SizedBox(width: getScreenWidth(9)),
                                            IconButton(
                                              onPressed: () async {
                                                await showReacherCardBottomSheet(
                                                  context,
                                                  downloadPost: () {},
                                                  postFeedModel:
                                                      widget.postFeedModel!,
                                                );
                                              },
                                              iconSize: getScreenHeight(19),
                                              padding: const EdgeInsets.all(0),
                                              icon: SvgPicture.asset(
                                                  'assets/svgs/kebab card.svg'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    widget.postFeedModel!.post!.content == null
                                        ? const SizedBox.shrink()
                                        : Flexible(
                                            child: ReadMoreText(
                                              widget.postFeedModel!.post!
                                                      .edited!
                                                  ? "${widget.postFeedModel!.post!.content ?? ''} (reach edited)"
                                                  : widget.postFeedModel!.post!
                                                          .content ??
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
                                                  fontSize: getScreenHeight(14),
                                                  fontFamily: "Roboto",
                                                  color:
                                                      const Color(0xff717F85)),
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
                                                  HapticFeedback.mediumImpact();
                                                  handleTap();
                                                  if (active.contains(
                                                      widget.postFeedModel)) {
                                                    if (widget.postFeedModel!
                                                        .like!.isNotEmpty) {
                                                      globals.socialServiceBloc!
                                                          .add(UnlikePostEvent(
                                                        postId: widget
                                                            .postFeedModel!
                                                            .postId,
                                                      ));
                                                    } else {
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
                                                padding: EdgeInsets.zero,
                                                child: widget.postFeedModel!
                                                        .like!.isNotEmpty
                                                    ? SvgPicture.asset(
                                                        'assets/svgs/like-active.svg',
                                                        height:
                                                            getScreenHeight(20),
                                                        width:
                                                            getScreenWidth(20),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/svgs/like.svg',
                                                        height:
                                                            getScreenHeight(20),
                                                        width:
                                                            getScreenWidth(20),
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
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor3,
                                                  ),
                                                ),
                                              ).paddingOnly(r: 8),
                                              FittedBox(
                                                child: Text(
                                                  'Likes',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(12),
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor3,
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
                                                    if (active.contains(
                                                        widget.postFeedModel)) {
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
                                                    height: getScreenHeight(20),
                                                    width: getScreenWidth(20),
                                                  ),
                                                ).paddingOnly(r: 8),
                                              FittedBox(
                                                child: Text(
                                                  'Message user',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(12),
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor3,
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
                                                  HapticFeedback.mediumImpact();
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
                                                },
                                                padding: EdgeInsets.zero,
                                                child: widget.postFeedModel!
                                                            .vote!.isNotEmpty &&
                                                        widget
                                                                .postFeedModel!
                                                                .vote![0]
                                                                .voteType ==
                                                            'Upvote'
                                                    ? SvgPicture.asset(
                                                        'assets/svgs/shoutup-active.svg',
                                                        height:
                                                            getScreenHeight(20),
                                                        width:
                                                            getScreenWidth(20),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/svgs/shoutup.svg',
                                                        height:
                                                            getScreenHeight(20),
                                                        width:
                                                            getScreenWidth(20),
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
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor3,
                                                  ),
                                                ),
                                              ).paddingOnly(r: 8),
                                              FittedBox(
                                                child: Text(
                                                  'Shoutout',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(12),
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor3,
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
                                                  HapticFeedback.mediumImpact();
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
                                                },
                                                padding: EdgeInsets.zero,
                                                child: widget.postFeedModel!
                                                            .vote!.isNotEmpty &&
                                                        widget
                                                                .postFeedModel!
                                                                .vote![0]
                                                                .voteType ==
                                                            'Downvote'
                                                    ? SvgPicture.asset(
                                                        'assets/svgs/shoutdown-active.svg',
                                                        height:
                                                            getScreenHeight(20),
                                                        width:
                                                            getScreenWidth(20),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/svgs/shoutdown.svg',
                                                        height:
                                                            getScreenHeight(20),
                                                        width:
                                                            getScreenWidth(20),
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
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor3,
                                                  ),
                                                ),
                                              ).paddingOnly(r: 8),
                                              FittedBox(
                                                child: Text(
                                                  'Shoutdown',
                                                  style: TextStyle(
                                                    fontSize:
                                                        getScreenHeight(12),
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor3,
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
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 21.0),
                              child: Row(
                                children: [
                                  const Text("Comments"),
                                  IconButton(
                                      onPressed: () {},
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down))
                                ],
                              ),
                            ),
                            const Divider(),
                            showEmoji.value
                                ? buildEmoji()
                                : const SizedBox.shrink(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 21.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CustomRoundTextField(
                                      controller: controller,
                                      hintText: 'Comment on this post...',
                                      suffixIcon: IconButton(
                                          icon: const Icon(
                                              Icons.emoji_emotions_outlined),
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
                            )
                          ],
                        ),
                      ))),
            );
          }),
        );
      },
    );
  }
}
