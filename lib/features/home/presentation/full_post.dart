import 'dart:io';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/views/view_comments.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/services/navigation/navigation_service.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/helpers.dart';
import '../../account/presentation/widgets/bottom_sheets.dart';

class FullPostScreen extends HookWidget {
  static String id = 'full_post_screen';

  final bool likingPost;
  final Function()? onLike, onMessage, onUpvote, onDownvote, routeProfile;
  final bool isLiked, isVoted;
  final String? voteType;
  final PostFeedModel? postFeedModel;
  const FullPostScreen(
      {this.routeProfile,
      required this.isLiked,
      required this.isVoted,
      this.voteType,
      required this.postFeedModel,
      required this.likingPost,
      required this.onLike,
      required this.onMessage,
      required this.onUpvote,
      required,
      this.onDownvote,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(postFeedModel!.post!.createdAt!);
    final size = MediaQuery.of(context).size;
    final controller = useTextEditingController();
    final showEmoji = useState(false);

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

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness:
                    Platform.isAndroid ? Brightness.dark : Brightness.light,
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
                onPressed: () {},
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
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Helper.renderProfilePicture(
                                      postFeedModel!.profilePicture,
                                      size: 33,
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
                                              '@${postFeedModel!.username!}',
                                              style: TextStyle(
                                                fontSize: getScreenHeight(14),
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textColor2,
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            postFeedModel!.verified!
                                                ? SvgPicture.asset(
                                                    'assets/svgs/verified.svg')
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              postFeedModel!.post!.location! ==
                                                      'nil'
                                                  ? ''
                                                  : postFeedModel!
                                                      .post!.location!,
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //  SvgPicture.asset('assets/svgs/starred.svg'),
                                  SizedBox(width: getScreenWidth(9)),
                                  IconButton(
                                    onPressed: () async {
                                      await showReacherCardBottomSheet(
                                        context,
                                        downloadPost: () {},
                                        postFeedModel: postFeedModel!,
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
                          postFeedModel!.post!.content == null
                              ? const SizedBox.shrink()
                              : Flexible(
                                  child: ReadMoreText(
                                    postFeedModel!.post!.edited!
                                        ? "${postFeedModel!.post!.content ?? ''} (reach edited)"
                                        : postFeedModel!.post!.content ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: getScreenHeight(14)),
                                    trimLines: 3,
                                    colorClickableText: const Color(0xff717F85),
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'See more',
                                    trimExpandedText: 'See less',
                                    moreStyle: TextStyle(
                                        fontSize: getScreenHeight(14),
                                        fontFamily: "Roboto",
                                        color: const Color(0xff717F85)),
                                  ).paddingSymmetric(h: 16, v: 10),
                                ),
                          if (postFeedModel!.post!.imageMediaItems!.isNotEmpty)
                            Helper.renderPostImages(
                                    postFeedModel!.post!, context)
                                .paddingOnly(r: 16, l: 16, b: 16, t: 10)
                          else
                            const SizedBox.shrink(),

                          // likes and message
                          Row(
                            children: [
                              Container(
                                width: size.width - (size.width - 124),
                                height: size.width - (size.width - 50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF5F5F5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CupertinoButton(
                                      minSize: 0,
                                      onPressed: onLike,
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
                                    SizedBox(width: getScreenWidth(8)),
                                    FittedBox(
                                      child: Text(
                                        '${postFeedModel!.post!.nLikes}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(12),
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor3,
                                        ),
                                      ),
                                    ).paddingOnly(r: 8),
                                    FittedBox(
                                      child: Text(
                                        'Likes',
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
                              SizedBox(width: getScreenWidth(15)),
                              Container(
                                width: size.width - (size.width - 163),
                                height: size.width - (size.width - 50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF5F5F5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (postFeedModel!.postOwnerId !=
                                        postFeedModel!.feedOwnerId)
                                      CupertinoButton(
                                        minSize: 0,
                                        onPressed: onMessage,
                                        padding: const EdgeInsets.all(0),
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
                                          fontSize: getScreenHeight(12),
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
                                width: size.width - (size.width - 124),
                                height: size.width - (size.width - 50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF5F5F5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      minSize: 0,
                                      onPressed: onUpvote,
                                      padding: EdgeInsets.zero,
                                      child: isVoted && voteType == 'Upvote'
                                          ? SvgPicture.asset(
                                              'assets/svgs/shoutup-active.svg',
                                              height: getScreenHeight(20),
                                              width: getScreenWidth(20),
                                            )
                                          : SvgPicture.asset(
                                              'assets/svgs/shoutup.svg',
                                              height: getScreenHeight(20),
                                              width: getScreenWidth(20),
                                            ),
                                    ),
                                    SizedBox(width: getScreenWidth(8)),
                                    FittedBox(
                                      child: Text(
                                        '${postFeedModel!.post!.nLikes}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(12),
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor3,
                                        ),
                                      ),
                                    ).paddingOnly(r: 8),
                                    FittedBox(
                                      child: Text(
                                        'Shoutout',
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
                              SizedBox(width: getScreenWidth(15)),
                              Container(
                                width: size.width - (size.width - 163),
                                height: size.width - (size.width - 50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFFF5F5F5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      minSize: 0,
                                      onPressed: onDownvote,
                                      padding: EdgeInsets.zero,
                                      child: isVoted && voteType == 'Downvote'
                                          ? SvgPicture.asset(
                                              'assets/svgs/shoutdown-active.svg',
                                              height: getScreenHeight(20),
                                              width: getScreenWidth(20),
                                            )
                                          : SvgPicture.asset(
                                              'assets/svgs/shoutdown.svg',
                                              height: getScreenHeight(20),
                                              width: getScreenWidth(20),
                                            ),
                                    ),
                                    SizedBox(width: getScreenWidth(8)),
                                    FittedBox(
                                      child: Text(
                                        '${postFeedModel!.post!.nLikes}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(12),
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor3,
                                        ),
                                      ),
                                    ).paddingOnly(r: 8),
                                    FittedBox(
                                      child: Text(
                                        'Shoutdown',
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
                            ],
                          ).paddingOnly(l: 16)
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.0),
                    child: Row(
                      children: [
                        const Text("Comments"),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.keyboard_arrow_down))
                      ],
                    ),
                  ),
                  const Divider(),
                  showEmoji.value ? buildEmoji() : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomRoundTextField(
                            hintText: 'Comment on this post...',
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.emoji_emotions),
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
            )));
  }
}
