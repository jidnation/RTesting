import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

class ViewCommentsScreen extends StatefulHookWidget {
  static String id = 'view_comments_screen';
  const ViewCommentsScreen({Key? key, required this.post}) : super(key: key);

  final PostFeedModel post;

  @override
  State<ViewCommentsScreen> createState() => _ViewCommentsScreenState();
}

class _ViewCommentsScreenState extends State<ViewCommentsScreen> {
  Set active = {};

  handleTap(index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reachDM = useState(false);
    final controller = useTextEditingController();
    final triggerProgressIndicator = useState(true);
    final comments = useState<List<CommentModel>>([]);
    final scrollController = useScrollController();
    useEffect(() {
      globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
          postId: widget.post.postId, pageLimit: 50, pageNumber: 1));
      return null;
    }, []);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, statee) {
            if (statee is RecipientUserData) {
              if (reachDM.value) {
                RouteNavigators.route(
                    context, MsgChatInterface(recipientUser: statee.user));
              }
              reachDM.value = false;
            }
            if (statee is UserError) {
              reachDM.value = false;
              Snackbars.error(context, message: statee.error);
            }
          },
          builder: (context, statee) {
            return BlocConsumer<SocialServiceBloc, SocialServiceState>(
                bloc: globals.socialServiceBloc,
                listener: (context, state) {
                  if (state is CommentOnPostSuccess) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 10),
                        curve: Curves.easeOut,
                      );
                    });
                    Snackbars.success(context,
                        message: "Your commment has been posted");
                    triggerProgressIndicator.value = false;
                    globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
                        postId: widget.post.postId,
                        pageLimit: 50,
                        pageNumber: 1));
                  }
                  if (state is CommentOnPostError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is CommentOnPostLoading) {
                    toast('Posting comment...',
                        duration: const Duration(milliseconds: 100));
                  }
                  if (state is GetAllCommentsOnPostSuccess) {
                    comments.value = state.data!.reversed.toList();
                  }

                  if (state is GetAllCommentsOnPostError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is UnlikeCommentOnPostSuccess ||
                      state is LikeCommentOnPostSuccess) {
                    globals.socialServiceBloc!.add(GetAllCommentsOnPostEvent(
                        postId: widget.post.postId,
                        pageLimit: 50,
                        pageNumber: 1));
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is GetAllCommentsOnPostLoading;

                  return ProgressHUD(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => RouteNavigators.pop(context),
                              icon: Transform.rotate(
                                angle: 3.142,
                                child: const Icon(
                                  Icons.arrow_right_alt,
                                ),
                              ),
                            ),
                            Text(
                              'View comments',
                              style: TextStyle(
                                fontSize: getScreenHeight(16),
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Opacity(
                              opacity: 0,
                              child: IconButton(
                                onPressed: null,
                                icon: Transform.rotate(
                                  angle: 3.142,
                                  child: const Icon(
                                    Icons.arrow_right_alt,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(h: 16),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, bottom: 20, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Helper.renderProfilePicture(
                                    widget.post.profilePicture,
                                    size: 35,
                                  ),
                                  SizedBox(width: getScreenHeight(12)),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '@${widget.post.username!}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          color: AppColors.textColor2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      widget.post.location == null
                                          ? const SizedBox.shrink()
                                          : Text(
                                              '',
                                              style: TextStyle(
                                                fontSize: getScreenHeight(12),
                                                color: AppColors.textColor2
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: getScreenHeight(12)),
                              widget.post.post!.content == null
                                  ? const SizedBox()
                                  : Text(
                                      widget.post.post!.content!,
                                      style: TextStyle(
                                        fontSize: getScreenHeight(14),
                                        color: AppColors.textColor2,
                                      ),
                                    ),
                              if (widget.post.post!.imageMediaItems!.isNotEmpty)
                                Helper.renderPostImages(
                                        widget.post.post!, context)
                                    .paddingOnly(r: 16, l: 16, b: 16, t: 10)
                              else
                                const SizedBox(),
                            ],
                          ),
                        ).paddingOnly(t: 16, b: 7, r: 20, l: 20),
                        const SizedBox(height: 20),
                        if (isLoading && triggerProgressIndicator.value)
                          const Expanded(child: CupertinoActivityIndicator())
                        else
                          Expanded(
                            child: comments.value.isEmpty
                                ? const Center(child: Text('No comments yet'))
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    itemCount: comments.value.length,
                                    itemBuilder: (context, index) {
                                      return CommentsTile(
                                        comment: comments.value[index],
                                        isLiked: comments
                                                .value[index].like!.isNotEmpty
                                            ? true
                                            : false,
                                        onLike: () {
                                          HapticFeedback.mediumImpact();
                                          handleTap(index);
                                          if (active.contains(index)) {
                                            if (comments.value[index].like!
                                                .isNotEmpty) {
                                              globals.socialServiceBloc!
                                                  .add(UnlikeCommentOnPostEvent(
                                                commentId: comments
                                                    .value[index].commentId,
                                                postId: comments
                                                    .value[index].postId,
                                              ));
                                            } else {
                                              globals.socialServiceBloc!.add(
                                                LikeCommentOnPostEvent(
                                                  postId: comments
                                                      .value[index].postId,
                                                  commentId: comments
                                                      .value[index].commentId,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        onMessage: () {
                                          HapticFeedback.mediumImpact();
                                          reachDM.value = true;
                                          handleTap(index);
                                          if (active.contains(index)) {
                                            globals.userBloc!.add(
                                                GetRecipientProfileEvent(
                                                    email: comments
                                                        .value[index].authId!));
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ),
                        Container(
                          color: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText:
                                  'Comment as ${globals.user!.username!}...',
                              hintStyle:
                                  TextStyle(fontSize: getScreenHeight(14)),
                              suffixIcon: IconButton(
                                icon: SvgPicture.asset('assets/svgs/send.svg'),
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    globals.socialServiceBloc!.add(
                                        CommentOnPostEvent(
                                            postId: widget.post.postId,
                                            content: controller.text,
                                            userId: globals.user!.id));
                                    controller.clear();
                                  }
                                },
                              ),
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Helper.renderProfilePicture(
                                    globals.user!.profilePicture,
                                    size: 35,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              border: null,
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ).paddingOnly(t: 10)
                      ],
                    ).paddingOnly(t: 30),
                  );
                });
          }),
    );
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
        ),
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
                                comment.commentProfile!.profilePicture,
                            recipientId: comment.authId,
                          ));
                  progress?.dismiss();
                });
              },
              child: Row(
                children: [
                  Helper.renderProfilePicture(
                    comment.commentProfile!.profilePicture,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${comment.commentProfile!.username!}',
                        style: TextStyle(
                          fontSize: getScreenHeight(15),
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
            Text(
              comment.content!,
              style: TextStyle(
                fontSize: getScreenHeight(14),
                color: AppColors.textColor2,
              ),
            ),
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
