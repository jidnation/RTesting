import 'dart:ui' as ui;

import 'package:expandable_text/expandable_text.dart';
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
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../chat/presentation/views/msg_chat_interface.dart';
import '../../../dictionary/presentation/widgets/view_words_dialog.dart';
import '../../../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../../../home/presentation/widgets/post_media.dart';
import '../../../home/presentation/widgets/reposted_post.dart';
import '../../../moment/moment_audio_player.dart';
import '../../../timeline/video_player.dart';

class SavedPostScreen extends StatefulHookWidget {
  static const String id = "saved_post_screen";
  const SavedPostScreen({Key? key}) : super(key: key);

  @override
  State<SavedPostScreen> createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends State<SavedPostScreen> {
  TabBar get _tabBar => const TabBar(
        isScrollable: false,
        indicatorWeight: 1.5,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: 20.0),
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.black,
          ),
        ),
        indicatorColor: AppColors.black,
        unselectedLabelColor: AppColors.greyShade4,
        labelColor: AppColors.black,
        labelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(child: Text('All Posts')),
          Tab(child: Text('Videos')),
          Tab(child: Text('Audios')),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final _savedPosts = useState<List<SavePostModel>>([]);
    final reachDM = useState(false);
    final viewProfile = useState(false);
    final shoutingDown = useState(false);
    final _currentPost = useState<SavePostModel?>(null);
    useMemoized(() {
      globals.socialServiceBloc!
          .add(GetAllSavedPostsEvent(pageLimit: 50, pageNumber: 1));
    });
    Set active = {};

    handleTap(index) {
      if (active.isNotEmpty) active.clear();
      setState(() {
        active.add(index);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/back.svg',
              width: 19,
              height: 12,
              color: AppColors.black,
            ),
            onPressed: () => RouteNavigators.pop(context)),
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        title: Text(
          'Saved Posts',
          style: TextStyle(
            fontSize: getScreenHeight(16),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: DefaultTabController(
        length: 3,
        child: BlocListener<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, state) {
            if (state is RecipientUserData) {
              if (reachDM.value) {
                reachDM.value = false;
                RouteNavigators.route(
                    context, MsgChatInterface(recipientUser: state.user));
              } else if (viewProfile.value) {
                viewProfile.value = false;
                ProgressHUD.of(context)?.dismiss();
                globals.recipientUser = state.user;
                state.user!.id == globals.user!.id
                    ? RouteNavigators.route(context, const AccountScreen())
                    : RouteNavigators.route(
                        context,
                        RecipientAccountProfile(
                          recipientEmail: 'email',
                          recipientImageUrl: state.user!.profilePicture,
                          recipientId: state.user!.id,
                        ));
              }
            }
          },
          child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
            bloc: globals.socialServiceBloc,
            listener: (context, state) {
              if (state is GetAllSavedPostsSuccess) {
                _savedPosts.value = state.data!;
              }
              if (state is GetAllSavedPostsError) {
                Snackbars.error(context, message: state.error);
              }
            },
            builder: (context, state) {
              bool _isLoading = state is GetAllSavedPostsLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AppColors.greyShade5, width: 1.0),
                          ),
                        ),
                      ),
                      _tabBar
                    ],
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      if (_isLoading)
                        const CircularLoader()
                      else
                        _savedPosts.value.isEmpty
                            ? ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: const [
                                  EmptyTabWidget(
                                    title: "No saved posts",
                                    subtitle: "",
                                  )
                                ],
                              )
                            : ListView.builder(
                                itemCount: _savedPosts.value.length,
                                itemBuilder: (context, index) {
                                  return SavedPostReacherCard(
                                    likingPost: false,
                                    isLiked: (_savedPosts
                                                .value[index].post.isLiked ??
                                            false)
                                        ? true
                                        : false,
                                    isVoted: (_savedPosts
                                                .value[index].post.isVoted ??
                                            '')
                                        .isNotEmpty,
                                    voteType:
                                        _savedPosts.value[index].post.isVoted,
                                    onViewProfile: () {
                                      viewProfile.value = true;
                                      ProgressHUD.of(context)
                                          ?.showWithText('Viewing Profile');
                                      globals.userBloc!.add(
                                          GetRecipientProfileEvent(
                                              email: _savedPosts
                                                  .value[index]
                                                  .post
                                                  .postOwnerProfile!
                                                  .authId));
                                    },
                                    onMessage: () {
                                      HapticFeedback.mediumImpact();
                                      reachDM.value = true;

                                      handleTap(index);
                                      if (active.contains(index)) {
                                        globals.userBloc!.add(
                                            GetRecipientProfileEvent(
                                                email: _savedPosts
                                                    .value[index]
                                                    .post
                                                    .postOwnerProfile!
                                                    .authId));
                                      }
                                    },
                                    onUpvote: () {
                                      HapticFeedback.mediumImpact();
                                      handleTap(index);

                                      if (active.contains(index)) {
                                        if ((_savedPosts
                                                    .value[index].post.vote ??
                                                [])
                                            .isEmpty) {
                                          globals.socialServiceBloc!
                                              .add(VotePostEvent(
                                            voteType: 'Upvote',
                                            postId: _savedPosts
                                                .value[index].post.postId,
                                          ));
                                        } else {
                                          globals.socialServiceBloc!
                                              .add(DeletePostVoteEvent(
                                            voteId: _savedPosts
                                                .value[index].post.postId,
                                          ));
                                        }
                                      }
                                    },
                                    onDownvote: () {
                                      HapticFeedback.mediumImpact();
                                      handleTap(index);
                                      _currentPost.value =
                                          _savedPosts.value[index];
                                      if (active.contains(index)) {
                                        shoutingDown.value = true;
                                        globals.userBloc!.add(
                                            GetReachRelationshipEvent(
                                                userIdToReach: _savedPosts
                                                    .value[index]
                                                    .post
                                                    .postOwnerProfile!
                                                    .authId,
                                                type: ReachRelationshipType
                                                    .reacher));
                                      }
                                    },
                                    onLike: () {
                                      HapticFeedback.mediumImpact();
                                      handleTap(index);
                                      // Console.log(
                                      //     'Like Data',
                                      //     _posts.value[index]
                                      //         .toJson());
                                      if (active.contains(index)) {
                                        if (_savedPosts
                                                .value[index].post.isLiked ??
                                            false) {
                                          _savedPosts.value[index].post
                                              .isLiked = false;
                                          _savedPosts.value[index].post.nLikes =
                                              (_savedPosts.value[index].post
                                                          .nLikes ??
                                                      1) -
                                                  1;
                                          globals.socialServiceBloc!
                                              .add(UnlikePostEvent(
                                            postId: _savedPosts
                                                .value[index].post.postId,
                                          ));
                                        } else {
                                          _savedPosts
                                              .value[index].post.isLiked = true;
                                          _savedPosts.value[index].post.nLikes =
                                              (_savedPosts.value[index].post
                                                          .nLikes ??
                                                      0) +
                                                  1;
                                          globals.socialServiceBloc!.add(
                                            LikePostEvent(
                                                postId: _savedPosts
                                                    .value[index].post.postId),
                                          );
                                        }
                                      }
                                    },
                                    savedPostModel: _savedPosts.value[index],
                                    onDelete: () {
                                      handleTap(index);
                                      if (active.contains(index)) {
                                        globals.socialServiceBloc!.add(
                                            DeleteSavedPostEvent(
                                                postId: _savedPosts
                                                    .value[index].post.postId));
                                      }
                                    },
                                  );
                                },
                              ),
                      if (_isLoading)
                        const CircularLoader()
                      else
                        _savedPosts.value.isEmpty
                            ? ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: const [
                                  EmptyTabWidget(
                                    title: "No  video posts",
                                    subtitle: "",
                                  )
                                ],
                              )
                            : ListView.builder(
                                itemCount: _savedPosts.value.length,
                                itemBuilder: (context, index) {
                                  if ((_savedPosts.value[index].post
                                              .videoMediaItem ??
                                          '')
                                      .isNotEmpty) {
                                    return VideoOnlySavedPostReacherCard(
                                      likingPost: false,
                                      isLiked: (_savedPosts
                                                  .value[index].post.isLiked ??
                                              false)
                                          ? true
                                          : false,
                                      isVoted: (_savedPosts
                                                  .value[index].post.isVoted ??
                                              '')
                                          .isNotEmpty,
                                      voteType:
                                          _savedPosts.value[index].post.isVoted,
                                      onViewProfile: () {
                                        viewProfile.value = true;
                                        ProgressHUD.of(context)
                                            ?.showWithText('Viewing Profile');
                                        globals.userBloc!.add(
                                            GetRecipientProfileEvent(
                                                email: _savedPosts
                                                    .value[index]
                                                    .post
                                                    .postOwnerProfile!
                                                    .authId));
                                      },
                                      onMessage: () {
                                        HapticFeedback.mediumImpact();
                                        reachDM.value = true;

                                        handleTap(index);
                                        if (active.contains(index)) {
                                          globals.userBloc!.add(
                                              GetRecipientProfileEvent(
                                                  email: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postOwnerProfile!
                                                      .authId));
                                        }
                                      },
                                      onUpvote: () {
                                        HapticFeedback.mediumImpact();
                                        handleTap(index);

                                        if (active.contains(index)) {
                                          if ((_savedPosts
                                                      .value[index].post.vote ??
                                                  [])
                                              .isEmpty) {
                                            globals.socialServiceBloc!
                                                .add(VotePostEvent(
                                              voteType: 'Upvote',
                                              postId: _savedPosts
                                                  .value[index].post.postId,
                                            ));
                                          } else {
                                            globals.socialServiceBloc!
                                                .add(DeletePostVoteEvent(
                                              voteId: _savedPosts
                                                  .value[index].post.postId,
                                            ));
                                          }
                                        }
                                      },
                                      onDownvote: () {
                                        HapticFeedback.mediumImpact();
                                        handleTap(index);
                                        _currentPost.value =
                                            _savedPosts.value[index];
                                        if (active.contains(index)) {
                                          shoutingDown.value = true;
                                          globals.userBloc!.add(
                                              GetReachRelationshipEvent(
                                                  userIdToReach: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postOwnerProfile!
                                                      .authId,
                                                  type: ReachRelationshipType
                                                      .reacher));
                                        }
                                      },
                                      onLike: () {
                                        HapticFeedback.mediumImpact();
                                        handleTap(index);
                                        // Console.log(
                                        //     'Like Data',
                                        //     _posts.value[index]
                                        //         .toJson());
                                        if (active.contains(index)) {
                                          if (_savedPosts
                                                  .value[index].post.isLiked ??
                                              false) {
                                            _savedPosts.value[index].post
                                                .isLiked = false;
                                            _savedPosts.value[index].post
                                                .nLikes = (_savedPosts
                                                        .value[index]
                                                        .post
                                                        .nLikes ??
                                                    1) -
                                                1;
                                            globals.socialServiceBloc!
                                                .add(UnlikePostEvent(
                                              postId: _savedPosts
                                                  .value[index].post.postId,
                                            ));
                                          } else {
                                            _savedPosts.value[index].post
                                                .isLiked = true;
                                            _savedPosts.value[index].post
                                                .nLikes = (_savedPosts
                                                        .value[index]
                                                        .post
                                                        .nLikes ??
                                                    0) +
                                                1;
                                            globals.socialServiceBloc!.add(
                                              LikePostEvent(
                                                  postId: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postId),
                                            );
                                          }
                                        }
                                      },
                                      savedPostModel: _savedPosts.value[index],
                                      onDelete: () {
                                        handleTap(index);
                                        if (active.contains(index)) {
                                          globals.socialServiceBloc!.add(
                                              DeleteSavedPostEvent(
                                                  postId: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postId));
                                        }
                                      },
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                      if (_isLoading)
                        const CircularLoader()
                      else
                        _savedPosts.value.isEmpty
                            ? ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: const [
                                  EmptyTabWidget(
                                    title: "No audio posts",
                                    subtitle: "",
                                  )
                                ],
                              )
                            : ListView.builder(
                                itemCount: _savedPosts.value.length,
                                itemBuilder: (context, index) {
                                  if ((_savedPosts.value[index].post
                                              .audioMediaItem ??
                                          '')
                                      .isNotEmpty) {
                                    return AudioOnlySavedPostReacherCard(
                                      likingPost: false,
                                      isLiked: (_savedPosts
                                                  .value[index].post.isLiked ??
                                              false)
                                          ? true
                                          : false,
                                      isVoted: (_savedPosts
                                                  .value[index].post.isVoted ??
                                              '')
                                          .isNotEmpty,
                                      voteType:
                                          _savedPosts.value[index].post.isVoted,
                                      onViewProfile: () {
                                        viewProfile.value = true;
                                        ProgressHUD.of(context)
                                            ?.showWithText('Viewing Profile');
                                        globals.userBloc!.add(
                                            GetRecipientProfileEvent(
                                                email: _savedPosts
                                                    .value[index]
                                                    .post
                                                    .postOwnerProfile!
                                                    .authId));
                                      },
                                      onMessage: () {
                                        HapticFeedback.mediumImpact();
                                        reachDM.value = true;

                                        handleTap(index);
                                        if (active.contains(index)) {
                                          globals.userBloc!.add(
                                              GetRecipientProfileEvent(
                                                  email: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postOwnerProfile!
                                                      .authId));
                                        }
                                      },
                                      onUpvote: () {
                                        HapticFeedback.mediumImpact();
                                        handleTap(index);

                                        if (active.contains(index)) {
                                          if ((_savedPosts
                                                      .value[index].post.vote ??
                                                  [])
                                              .isEmpty) {
                                            globals.socialServiceBloc!
                                                .add(VotePostEvent(
                                              voteType: 'Upvote',
                                              postId: _savedPosts
                                                  .value[index].post.postId,
                                            ));
                                          } else {
                                            globals.socialServiceBloc!
                                                .add(DeletePostVoteEvent(
                                              voteId: _savedPosts
                                                  .value[index].post.postId,
                                            ));
                                          }
                                        }
                                      },
                                      onDownvote: () {
                                        HapticFeedback.mediumImpact();
                                        handleTap(index);
                                        _currentPost.value =
                                            _savedPosts.value[index];
                                        if (active.contains(index)) {
                                          shoutingDown.value = true;
                                          globals.userBloc!.add(
                                              GetReachRelationshipEvent(
                                                  userIdToReach: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postOwnerProfile!
                                                      .authId,
                                                  type: ReachRelationshipType
                                                      .reacher));
                                        }
                                      },
                                      onLike: () {
                                        HapticFeedback.mediumImpact();
                                        handleTap(index);
                                        // Console.log(
                                        //     'Like Data',
                                        //     _posts.value[index]
                                        //         .toJson());
                                        if (active.contains(index)) {
                                          if (_savedPosts
                                                  .value[index].post.isLiked ??
                                              false) {
                                            _savedPosts.value[index].post
                                                .isLiked = false;
                                            _savedPosts.value[index].post
                                                .nLikes = (_savedPosts
                                                        .value[index]
                                                        .post
                                                        .nLikes ??
                                                    1) -
                                                1;
                                            globals.socialServiceBloc!
                                                .add(UnlikePostEvent(
                                              postId: _savedPosts
                                                  .value[index].post.postId,
                                            ));
                                          } else {
                                            _savedPosts.value[index].post
                                                .isLiked = true;
                                            _savedPosts.value[index].post
                                                .nLikes = (_savedPosts
                                                        .value[index]
                                                        .post
                                                        .nLikes ??
                                                    0) +
                                                1;
                                            globals.socialServiceBloc!.add(
                                              LikePostEvent(
                                                  postId: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postId),
                                            );
                                          }
                                        }
                                      },
                                      savedPostModel: _savedPosts.value[index],
                                      onDelete: () {
                                        handleTap(index);
                                        if (active.contains(index)) {
                                          globals.socialServiceBloc!.add(
                                              DeleteSavedPostEvent(
                                                  postId: _savedPosts
                                                      .value[index]
                                                      .post
                                                      .postId));
                                        }
                                      },
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                    ]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SavedPostReacherCard extends HookWidget {
  final bool likingPost;
  final Function()? onLike, onMessage, onUpvote, onDownvote, onViewProfile;
  final bool isLiked, isVoted;
  final String? voteType;
  final PostProfileModel? voterProfile;
  const SavedPostReacherCard({
    Key? key,
    required this.savedPostModel,
    required this.likingPost,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.onViewProfile,
    this.voterProfile,
    required this.isVoted,
    required this.voteType,
    required this.isLiked,
    this.onDelete,
  }) : super(key: key);

  final SavePostModel? savedPostModel;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(savedPostModel!.post.createdAt!);
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

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
    void takeScreenShot() async {
      RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()
          as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: getScreenWidth(16),
        left: getScreenWidth(16),
        bottom: getScreenHeight(16),
      ),
      child: RepaintBoundary(
        key: scr,
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: voterProfile != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: RichText(
                        text: TextSpan(
                            text:
                                '@${voterProfile?.authId != globals.userId ? voterProfile?.username?.appendOverflow(15) : 'You'}',
                            style: const TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            children: const [
                              TextSpan(
                                  text: ' shouted out this reach',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w500))
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: getScreenHeight(8),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (onViewProfile != null) {
                          onViewProfile!();
                        } else {
                          final progress = ProgressHUD.of(context);
                          progress?.showWithText('Viewing Reacher...');
                          Future.delayed(const Duration(seconds: 3), () {
                            globals.userBloc!.add(GetRecipientProfileEvent(
                                email: savedPostModel!
                                    .post.postOwnerProfile!.authId));
                            savedPostModel!.post.postOwnerProfile!.authId ==
                                    globals.user!.id
                                ? RouteNavigators.route(
                                    context, const AccountScreen())
                                : RouteNavigators.route(
                                    context,
                                    RecipientAccountProfile(
                                      recipientEmail: 'email',
                                      recipientImageUrl: savedPostModel!.post
                                          .postOwnerProfile!.profilePicture,
                                      recipientId: savedPostModel!
                                          .post.postOwnerProfile!.authId,
                                    ));
                            progress?.dismiss();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Helper.renderProfilePicture(
                            savedPostModel!
                                .post.postOwnerProfile!.profilePicture,
                            size: 33,
                          ).paddingOnly(l: 13, t: 10),
                          SizedBox(width: getScreenWidth(9)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '@${savedPostModel!.post.postOwnerProfile!.username ?? ''}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  savedPostModel!.post.postOwnerProfile!
                                              .verified ??
                                          false
                                      ? SvgPicture.asset(
                                          'assets/svgs/verified.svg')
                                      : const SizedBox.shrink()
                                ],
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      savedPostModel!.post.postOwnerProfile!
                                                      .location ==
                                                  'nil' ||
                                              savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location ==
                                                  'NIL' ||
                                              savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location ==
                                                  null
                                          ? ''
                                          : savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location!
                                                      .length >
                                                  23
                                              ? savedPostModel!.post
                                                  .postOwnerProfile!.location!
                                                  .substring(0, 23)
                                              : savedPostModel!.post
                                                  .postOwnerProfile!.location!,
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
                                ),
                              )
                            ],
                          ).paddingOnly(t: 10),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  SvgPicture.asset('assets/svgs/starred.svg'),
                      SizedBox(width: getScreenWidth(9)),
                      // IconButton(
                      //   onPressed: () async {
                      //     await showReacherCardBottomSheet(
                      //       context,
                      //       downloadPost: takeScreenShot,
                      //       postFeedModel: postFeedModel!,
                      //     );
                      //   },
                      //   iconSize: getScreenHeight(19),
                      //   padding: const EdgeInsets.all(0),
                      //   icon: SvgPicture.asset('assets/svgs/kebab card.svg'),
                      // ),
                    ],
                  )
                ],
              ),
              savedPostModel!.post.content == null
                  ? const SizedBox.shrink()
                  : ExpandableText(
                      "${savedPostModel!.post.content}",
                      prefixText: savedPostModel!.post.edited!
                          ? "(Reach Edited)"
                          : null,
                      prefixStyle: TextStyle(
                          fontSize: getScreenHeight(12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor),
                      onPrefixTap: () {
                        tooltipkey.currentState?.ensureTooltipVisible();
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
                            builder: (BuildContext context) {
                              return DictionaryDialog(
                                abbr: value,
                                meaning: '',
                                word: '',
                              );
                            });
                      },
                      onMentionTap: (value) {},
                      mentionStyle: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                      hashtagStyle: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ).paddingSymmetric(h: 16, v: 10),
              Tooltip(
                key: tooltipkey,
                triggerMode: TooltipTriggerMode.manual,
                showDuration: const Duration(seconds: 1),
                message: 'This reach has been edited',
              ),
              if ((savedPostModel!.post.imageMediaItems ?? []).isNotEmpty)
                PostMedia(post: savedPostModel!.post)
                    .paddingOnly(r: 16, l: 16, b: 16, t: 10)
              else
                const SizedBox.shrink(),
              if ((savedPostModel!.post.videoMediaItem ?? '').isNotEmpty)
                TimeLineVideoPlayer(
                  post: savedPostModel!.post,
                  videoUrl: savedPostModel!.post.videoMediaItem ?? '',
                )
              else
                const SizedBox.shrink(),
              (savedPostModel!.post.audioMediaItem ?? '').isNotEmpty
                  ? Container(
                      height: 59,
                      margin: const EdgeInsets.only(bottom: 10),
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xfff5f5f5)),
                      child: Row(children: [
                        Expanded(
                            child: MomentAudioPlayer(
                                audioPath:
                                    savedPostModel!.post.audioMediaItem ?? '')),
                      ]),
                    )
                  : const SizedBox.shrink(),
              (savedPostModel!.post.repostedPost != null)
                  ? RepostedPost(post: savedPostModel!.post)
                      .paddingOnly(l: 0, r: 0, b: 10, t: 0)
                  : const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Container(
                      height: 40,
                      width: getScreenWidth(160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF5F5F5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoButton(
                            minSize: 0,
                            onPressed: onLike,
                            padding: EdgeInsets.zero,
                            child: isLiked
                                ? SvgPicture.asset(
                                    'assets/svgs/like-active.svg',
                                  )
                                : SvgPicture.asset(
                                    'assets/svgs/like.svg',
                                  ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nLikes}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(15)),
                          CupertinoButton(
                            minSize: 0,
                            onPressed: () {
                              // RouteNavigators.route(context,
                              //     ViewCommentsScreen(post: savedPostModel!));
                            },
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              'assets/svgs/comment.svg',
                            ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nComments}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            SizedBox(width: getScreenWidth(15)),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            CupertinoButton(
                              minSize: 0,
                              onPressed: onMessage,
                              padding: const EdgeInsets.all(0),
                              child: SvgPicture.asset(
                                'assets/svgs/message.svg',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getScreenWidth(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onUpvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Upvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutup-active.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutup.svg',
                                      ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nUpvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onDownvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Downvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutdown-active.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutdown.svg',
                                      ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nDownvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(b: 15, r: 16, l: 16, t: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class TextOnlySavedPostReacherCard extends HookWidget {
  final bool likingPost;
  final Function()? onLike, onMessage, onUpvote, onDownvote, onViewProfile;
  final bool isLiked, isVoted;
  final String? voteType;
  final PostProfileModel? voterProfile;
  const TextOnlySavedPostReacherCard({
    Key? key,
    required this.savedPostModel,
    required this.likingPost,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.onViewProfile,
    this.voterProfile,
    required this.isVoted,
    required this.voteType,
    required this.isLiked,
    this.onDelete,
  }) : super(key: key);

  final SavePostModel? savedPostModel;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(savedPostModel!.post.createdAt!);
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

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
    void takeScreenShot() async {
      RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()
          as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: getScreenWidth(16),
        left: getScreenWidth(16),
        bottom: getScreenHeight(16),
      ),
      child: RepaintBoundary(
        key: scr,
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: voterProfile != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: RichText(
                        text: TextSpan(
                            text:
                                '@${voterProfile?.authId != globals.userId ? voterProfile?.username?.appendOverflow(15) : 'You'}',
                            style: const TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            children: const [
                              TextSpan(
                                  text: ' shouted out this reach',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w500))
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: getScreenHeight(8),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (onViewProfile != null) {
                          onViewProfile!();
                        } else {
                          final progress = ProgressHUD.of(context);
                          progress?.showWithText('Viewing Reacher...');
                          Future.delayed(const Duration(seconds: 3), () {
                            globals.userBloc!.add(GetRecipientProfileEvent(
                                email: savedPostModel!
                                    .post.postOwnerProfile!.authId));
                            savedPostModel!.post.postOwnerProfile!.authId ==
                                    globals.user!.id
                                ? RouteNavigators.route(
                                    context, const AccountScreen())
                                : RouteNavigators.route(
                                    context,
                                    RecipientAccountProfile(
                                      recipientEmail: 'email',
                                      recipientImageUrl: savedPostModel!.post
                                          .postOwnerProfile!.profilePicture,
                                      recipientId: savedPostModel!
                                          .post.postOwnerProfile!.authId,
                                    ));
                            progress?.dismiss();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Helper.renderProfilePicture(
                            savedPostModel!
                                .post.postOwnerProfile!.profilePicture,
                            size: 33,
                          ).paddingOnly(l: 13, t: 10),
                          SizedBox(width: getScreenWidth(9)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '@${savedPostModel!.post.postOwnerProfile!.username ?? ''}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  savedPostModel!.post.postOwnerProfile!
                                              .verified ??
                                          false
                                      ? SvgPicture.asset(
                                          'assets/svgs/verified.svg')
                                      : const SizedBox.shrink()
                                ],
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      savedPostModel!.post.postOwnerProfile!
                                                  .location!
                                                  .toLowerCase()
                                                  .trim()
                                                  .toString() ==
                                              'nil'
                                          ? ''
                                          : savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location!
                                                      .length >
                                                  23
                                              ? savedPostModel!.post
                                                  .postOwnerProfile!.location!
                                                  .substring(0, 23)
                                              : savedPostModel!.post
                                                  .postOwnerProfile!.location!,
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
                                ),
                              )
                            ],
                          ).paddingOnly(t: 10),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  SvgPicture.asset('assets/svgs/starred.svg'),
                      SizedBox(width: getScreenWidth(9)),
                      // IconButton(
                      //   onPressed: () async {
                      //     await showReacherCardBottomSheet(
                      //       context,
                      //       downloadPost: takeScreenShot,
                      //       postFeedModel: postFeedModel!,
                      //     );
                      //   },
                      //   iconSize: getScreenHeight(19),
                      //   padding: const EdgeInsets.all(0),
                      //   icon: SvgPicture.asset('assets/svgs/kebab card.svg'),
                      // ),
                    ],
                  )
                ],
              ),
              savedPostModel!.post.content == null
                  ? const SizedBox.shrink()
                  : ExpandableText(
                      "${savedPostModel!.post.content}",
                      prefixText: savedPostModel!.post.edited!
                          ? "(Reach Edited)"
                          : null,
                      prefixStyle: TextStyle(
                          fontSize: getScreenHeight(12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor),
                      onPrefixTap: () {
                        tooltipkey.currentState?.ensureTooltipVisible();
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
                            builder: (BuildContext context) {
                              return DictionaryDialog(
                                abbr: value,
                                meaning: '',
                                word: '',
                              );
                            });
                      },
                      onMentionTap: (value) {},
                      mentionStyle: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                      hashtagStyle: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ).paddingSymmetric(h: 16, v: 10),
              Tooltip(
                key: tooltipkey,
                triggerMode: TooltipTriggerMode.manual,
                showDuration: const Duration(seconds: 1),
                message: 'This reach has been edited',
              ),
              if ((savedPostModel!.post.imageMediaItems ?? []).isNotEmpty)
                PostMedia(post: savedPostModel!.post)
                    .paddingOnly(r: 16, l: 16, b: 16, t: 10)
              else
                const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Container(
                      height: 40,
                      width: getScreenWidth(160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF5F5F5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoButton(
                            minSize: 0,
                            onPressed: onLike,
                            padding: EdgeInsets.zero,
                            child: isLiked
                                ? SvgPicture.asset(
                                    'assets/svgs/like-active.svg',
                                  )
                                : SvgPicture.asset(
                                    'assets/svgs/like.svg',
                                  ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nLikes}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(15)),
                          CupertinoButton(
                            minSize: 0,
                            onPressed: () {
                              // RouteNavigators.route(context,
                              //     ViewCommentsScreen(post: savedPostModel!));
                            },
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              'assets/svgs/comment.svg',
                            ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nComments}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            SizedBox(width: getScreenWidth(15)),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            CupertinoButton(
                              minSize: 0,
                              onPressed: onMessage,
                              padding: const EdgeInsets.all(0),
                              child: SvgPicture.asset(
                                'assets/svgs/message.svg',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getScreenWidth(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onUpvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Upvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutup-active.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutup.svg',
                                      ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nUpvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onDownvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Downvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutdown-active.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutdown.svg',
                                      ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nDownvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(b: 15, r: 16, l: 16, t: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoOnlySavedPostReacherCard extends HookWidget {
  final bool likingPost;
  final Function()? onLike, onMessage, onUpvote, onDownvote, onViewProfile;
  final bool isLiked, isVoted;
  final String? voteType;
  final PostProfileModel? voterProfile;
  const VideoOnlySavedPostReacherCard({
    Key? key,
    required this.savedPostModel,
    required this.likingPost,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.onViewProfile,
    this.voterProfile,
    required this.isVoted,
    required this.voteType,
    required this.isLiked,
    this.onDelete,
  }) : super(key: key);

  final SavePostModel? savedPostModel;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(savedPostModel!.post.createdAt!);
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

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
    void takeScreenShot() async {
      RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()
          as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: getScreenWidth(16),
        left: getScreenWidth(16),
        bottom: getScreenHeight(16),
      ),
      child: RepaintBoundary(
        key: scr,
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: voterProfile != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: RichText(
                        text: TextSpan(
                            text:
                                '@${voterProfile?.authId != globals.userId ? voterProfile?.username?.appendOverflow(15) : 'You'}',
                            style: const TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            children: const [
                              TextSpan(
                                  text: ' shouted out this reach',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w500))
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: getScreenHeight(8),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (onViewProfile != null) {
                          onViewProfile!();
                        } else {
                          final progress = ProgressHUD.of(context);
                          progress?.showWithText('Viewing Reacheexr...');
                          Future.delayed(const Duration(seconds: 3), () {
                            globals.userBloc!.add(GetRecipientProfileEvent(
                                email: savedPostModel!
                                    .post.postOwnerProfile!.authId));
                            savedPostModel!.post.postOwnerProfile!.authId ==
                                    globals.user!.id
                                ? RouteNavigators.route(
                                    context, const AccountScreen())
                                : RouteNavigators.route(
                                    context,
                                    RecipientAccountProfile(
                                      recipientEmail: 'email',
                                      recipientImageUrl: savedPostModel!.post
                                          .postOwnerProfile!.profilePicture,
                                      recipientId: savedPostModel!
                                          .post.postOwnerProfile!.authId,
                                    ));
                            progress?.dismiss();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Helper.renderProfilePicture(
                            savedPostModel!
                                .post.postOwnerProfile!.profilePicture,
                            size: 33,
                          ).paddingOnly(l: 13, t: 10),
                          SizedBox(width: getScreenWidth(9)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '@${savedPostModel!.post.postOwnerProfile!.username ?? ''}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  savedPostModel!.post.postOwnerProfile!
                                              .verified ??
                                          false
                                      ? SvgPicture.asset(
                                          'assets/svgs/verified.svg')
                                      : const SizedBox.shrink()
                                ],
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      savedPostModel!.post.postOwnerProfile!
                                                      .location ==
                                                  'nil' ||
                                              savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location ==
                                                  'NIL' ||
                                              savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location ==
                                                  null
                                          ? ''
                                          : savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location!
                                                      .length >
                                                  23
                                              ? savedPostModel!.post
                                                  .postOwnerProfile!.location!
                                                  .substring(0, 23)
                                              : savedPostModel!.post
                                                  .postOwnerProfile!.location!,
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
                                ),
                              )
                            ],
                          ).paddingOnly(t: 10),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  SvgPicture.asset('assets/svgs/starred.svg'),
                      SizedBox(width: getScreenWidth(9)),
                      // IconButton(
                      //   onPressed: () async {
                      //     await showReacherCardBottomSheet(
                      //       context,
                      //       downloadPost: takeScreenShot,
                      //       postFeedModel: postFeedModel!,
                      //     );
                      //   },
                      //   iconSize: getScreenHeight(19),
                      //   padding: const EdgeInsets.all(0),
                      //   icon: SvgPicture.asset('assets/svgs/kebab card.svg'),
                      // ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              if ((savedPostModel!.post.videoMediaItem ?? '').isNotEmpty)
                TimeLineVideoPlayer(
                  post: savedPostModel!.post,
                  videoUrl: savedPostModel!.post.videoMediaItem ?? '',
                )
              else
                const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Container(
                      height: 40,
                      width: getScreenWidth(160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF5F5F5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoButton(
                            minSize: 0,
                            onPressed: onLike,
                            padding: EdgeInsets.zero,
                            child: isLiked
                                ? SvgPicture.asset(
                                    'assets/svgs/like-active.svg',
                                  )
                                : SvgPicture.asset(
                                    'assets/svgs/like.svg',
                                  ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nLikes}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(15)),
                          CupertinoButton(
                            minSize: 0,
                            onPressed: () {
                              // RouteNavigators.route(context,
                              //     ViewCommentsScreen(post: savedPostModel!));
                            },
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              'assets/svgs/comment.svg',
                            ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nComments}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            SizedBox(width: getScreenWidth(15)),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            CupertinoButton(
                              minSize: 0,
                              onPressed: onMessage,
                              padding: const EdgeInsets.all(0),
                              child: SvgPicture.asset(
                                'assets/svgs/message.svg',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getScreenWidth(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onUpvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Upvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutup-active.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutup.svg',
                                      ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nUpvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onDownvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Downvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutdown-active.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutdown.svg',
                                      ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nDownvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(b: 15, r: 16, l: 16, t: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioOnlySavedPostReacherCard extends HookWidget {
  final bool likingPost;
  final Function()? onLike, onMessage, onUpvote, onDownvote, onViewProfile;
  final bool isLiked, isVoted;
  final String? voteType;
  final PostProfileModel? voterProfile;
  const AudioOnlySavedPostReacherCard({
    Key? key,
    required this.savedPostModel,
    required this.likingPost,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.onViewProfile,
    this.voterProfile,
    required this.isVoted,
    required this.voteType,
    required this.isLiked,
    this.onDelete,
  }) : super(key: key);

  final SavePostModel? savedPostModel;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(savedPostModel!.post.createdAt!);
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

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
    void takeScreenShot() async {
      RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()
          as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: getScreenWidth(16),
        left: getScreenWidth(16),
        bottom: getScreenHeight(16),
      ),
      child: RepaintBoundary(
        key: scr,
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: voterProfile != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: RichText(
                        text: TextSpan(
                            text:
                                '@${voterProfile?.authId != globals.userId ? voterProfile?.username?.appendOverflow(15) : 'You'}',
                            style: const TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            children: const [
                              TextSpan(
                                  text: ' shouted out this reach',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w500))
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: getScreenHeight(8),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (onViewProfile != null) {
                          onViewProfile!();
                        } else {
                          final progress = ProgressHUD.of(context);
                          progress?.showWithText('Viewing Reacher...');
                          Future.delayed(const Duration(seconds: 3), () {
                            globals.userBloc!.add(GetRecipientProfileEvent(
                                email: savedPostModel!
                                    .post.postOwnerProfile!.authId));
                            savedPostModel!.post.postOwnerProfile!.authId ==
                                    globals.user!.id
                                ? RouteNavigators.route(
                                    context, const AccountScreen())
                                : RouteNavigators.route(
                                    context,
                                    RecipientAccountProfile(
                                      recipientEmail: 'email',
                                      recipientImageUrl: savedPostModel!.post
                                          .postOwnerProfile!.profilePicture,
                                      recipientId: savedPostModel!
                                          .post.postOwnerProfile!.authId,
                                    ));
                            progress?.dismiss();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Helper.renderProfilePicture(
                            savedPostModel!
                                .post.postOwnerProfile!.profilePicture,
                            size: 33,
                          ).paddingOnly(l: 13, t: 10),
                          SizedBox(width: getScreenWidth(9)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '@${savedPostModel!.post.postOwnerProfile!.username ?? ''}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  savedPostModel!.post.postOwnerProfile!
                                              .verified ??
                                          false
                                      ? SvgPicture.asset(
                                          'assets/svgs/verified.svg')
                                      : const SizedBox.shrink()
                                ],
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      savedPostModel!.post.postOwnerProfile!
                                                      .location ==
                                                  'nil' ||
                                              savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location ==
                                                  'NIL' ||
                                              savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location ==
                                                  null
                                          ? ''
                                          : savedPostModel!
                                                      .post
                                                      .postOwnerProfile!
                                                      .location!
                                                      .length >
                                                  23
                                              ? savedPostModel!.post
                                                  .postOwnerProfile!.location!
                                                  .substring(0, 23)
                                              : savedPostModel!.post
                                                  .postOwnerProfile!.location!,
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
                                ),
                              )
                            ],
                          ).paddingOnly(t: 10),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  SvgPicture.asset('assets/svgs/starred.svg'),
                      SizedBox(width: getScreenWidth(9)),
                      // IconButton(
                      //   onPressed: () async {
                      //     await showReacherCardBottomSheet(
                      //       context,
                      //       downloadPost: takeScreenShot,
                      //       postFeedModel: postFeedModel!,
                      //     );
                      //   },
                      //   iconSize: getScreenHeight(19),
                      //   padding: const EdgeInsets.all(0),
                      //   icon: SvgPicture.asset('assets/svgs/kebab card.svg'),
                      // ),
                    ],
                  )
                ],
              ),
              (savedPostModel!.post.audioMediaItem ?? '').isNotEmpty
                  ? Container(
                      height: 59,
                      margin: const EdgeInsets.only(bottom: 10),
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xfff5f5f5)),
                      child: Row(children: [
                        Expanded(
                            child: MomentAudioPlayer(
                                audioPath:
                                    savedPostModel!.post.audioMediaItem ?? '')),
                      ]),
                    )
                  : const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Container(
                      height: 40,
                      width: getScreenWidth(160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF5F5F5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              if ((savedPostModel!.post.nLikes ?? 0) > 0) {
                                showPostReactors(context,
                                    postId: savedPostModel!.post.postId!,
                                    reactionType: 'Like');
                              }
                            },
                            child: CupertinoButton(
                              minSize: 0,
                              onPressed: onLike,
                              padding: EdgeInsets.zero,
                              child: isLiked
                                  ? SvgPicture.asset(
                                      'assets/svgs/like-active.svg',
                                    )
                                  : SvgPicture.asset(
                                      'assets/svgs/like.svg',
                                    ),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nLikes}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(15)),
                          CupertinoButton(
                            minSize: 0,
                            onPressed: () {
                              // RouteNavigators.route(context,
                              //     ViewCommentsScreen(post: savedPostModel!));
                            },
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              'assets/svgs/comment.svg',
                            ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${savedPostModel!.post.nComments}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            SizedBox(width: getScreenWidth(15)),
                          if (savedPostModel!.post.postOwnerProfile!.authId !=
                              globals.userId)
                            CupertinoButton(
                              minSize: 0,
                              onPressed: onMessage,
                              padding: const EdgeInsets.all(0),
                              child: SvgPicture.asset(
                                'assets/svgs/message.svg',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getScreenWidth(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  if ((savedPostModel!.post.nUpvotes ?? 0) >
                                          0 &&
                                      (savedPostModel!.post.authId ==
                                          globals.user!.id!)) {
                                    showPostReactors(context,
                                        postId: savedPostModel!.post.postId!,
                                        reactionType: 'Upvote');
                                  }
                                },
                                child: CupertinoButton(
                                  minSize: 0,
                                  onPressed: onUpvote,
                                  padding: EdgeInsets.zero,
                                  child: isVoted && voteType == 'Upvote'
                                      ? SvgPicture.asset(
                                          'assets/svgs/shoutup-active.svg',
                                        )
                                      : SvgPicture.asset(
                                          'assets/svgs/shoutup.svg',
                                        ),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nUpvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              GestureDetector(
                                onLongPress: () {
                                  if ((savedPostModel!.post.nDownvotes ?? 0) >
                                          0 &&
                                      (savedPostModel!.post.authId ==
                                          globals.user!.id!)) {
                                    showPostReactors(context,
                                        postId: savedPostModel!.post.postId!,
                                        reactionType: 'Downvote');
                                  }
                                },
                                child: CupertinoButton(
                                  minSize: 0,
                                  onPressed: onDownvote,
                                  padding: EdgeInsets.zero,
                                  child: isVoted && voteType == 'Downvote'
                                      ? SvgPicture.asset(
                                          'assets/svgs/shoutdown-active.svg',
                                        )
                                      : SvgPicture.asset(
                                          'assets/svgs/shoutdown.svg',
                                        ),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${savedPostModel!.post.nDownvotes ?? 0}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(b: 15, r: 16, l: 16, t: 5),
            ],
          ),
        ),
      ),
    );
  }
}

Future showSavedPostBottomSheet(BuildContext context,
    {required SavePostModel savePostModel}) async {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return BlocConsumer<SocialServiceBloc, SocialServiceState>(
        bloc: globals.socialServiceBloc,
        listener: (context, state) {
          if (state is DeleteSavedPostSuccess) {
            RouteNavigators.pop(context);
            Snackbars.success(context, message: 'Post removed successfully');
            globals.socialServiceBloc!
                .add(GetAllSavedPostsEvent(pageLimit: 30, pageNumber: 1));
          }
          if (state is DeleteSavedPostError) {
            RouteNavigators.pop(context);
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          bool _isLoading = state is DeleteSavedPostLoading;
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
                Column(
                  children: [
                    KebabBottomTextButton(
                        label: 'Remove from Saved Posts',
                        isLoading: _isLoading,
                        onPressed: () {
                          globals.socialServiceBloc!.add(DeleteSavedPostEvent(
                              postId: savePostModel.post.postId));
                        }),
                    KebabBottomTextButton(
                        label: 'Share Post', onPressed: () {}),
                    const KebabBottomTextButton(label: 'Copy link'),
                  ],
                ),
                SizedBox(height: getScreenHeight(20)),
              ]));
        },
      );
    },
  );
}
