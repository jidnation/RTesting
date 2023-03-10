// import 'package:expandable_text/expandable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
// import 'package:reach_me/core/components/custom_button.dart';
// import 'package:reach_me/core/components/empty_state.dart';
// import 'package:reach_me/core/components/profile_picture.dart';
// import 'package:reach_me/core/components/refresher.dart';
// import 'package:reach_me/core/components/rm_spinner.dart';
// import 'package:reach_me/core/components/snackbar.dart';
// import 'package:reach_me/core/services/navigation/navigation_service.dart';
// import 'package:reach_me/core/utils/app_globals.dart';
// import 'package:reach_me/core/utils/constants.dart';
// import 'package:reach_me/core/utils/dimensions.dart';
// import 'package:reach_me/core/utils/extensions.dart';
// import 'package:reach_me/core/utils/helpers.dart';
// import 'package:reach_me/features/account/presentation/views/account.details.dart';
// import 'package:reach_me/features/account/presentation/views/edit_profile_screen.dart';
// import 'package:reach_me/features/account/presentation/views/saved_post.dart';
// import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
// import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
// import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
// import 'package:reach_me/features/home/data/models/comment_model.dart';
// import 'package:reach_me/features/home/data/models/post_model.dart';
// import 'package:reach_me/features/home/data/models/status.model.dart';
// import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
// import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
// import 'package:reach_me/features/home/presentation/views/home_screen.dart';
// import 'package:reach_me/features/home/presentation/views/timeline.dart';
// import 'package:reach_me/features/home/presentation/widgets/reposted_post.dart';
// // import 'package:reach_me/features/timeline/image_loader.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:timeago/timeago.dart' as timeago;
//
// import '../../../../core/services/database/secure_storage.dart';
// import '../../../../core/utils/custom_text.dart';
// import '../../../auth/presentation/views/login_screen.dart';
// // import '../../../dictionary/presentation/widgets/view_words_dialog.dart';
// import '../../../home/presentation/views/comment_reach.dart';
// import '../../../home/presentation/views/post_reach.dart';
// import '../../../home/presentation/widgets/post_media.dart';
// // import '../../../moment/moment_audio_player.dart';
// // import '../../../moment/moment_feed.dart';
// // import '../../../timeline/timeline_feed.dart';
// // import '../../../timeline/video_player.dart';
//
//
// class _ReacherCard extends HookWidget {
//   _ReacherCard({
//     Key? key,
//     required this.postModel,
//     this.onComment,
//     this.onDownvote,
//     this.onLike,
//     this.onMessage,
//     this.onUpvote,
//     this.likeColour,
//   }) : super(key: key);
//
//   final PostModel? postModel;
//   final Function()? onLike, onComment, onMessage, onUpvote, onDownvote;
//   final Color? likeColour;
//   final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final postDuration = timeago.format(postModel!.createdAt!);
//     final isReaching = useState(false);
//
//     useMemoized(() {
//       globals.userBloc!.add(GetReachRelationshipEvent(
//           userIdToReach: postModel!.postOwnerProfile!.authId,
//           type: ReachRelationshipType.reacher));
//     });
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 13,
//         vertical: 7,
//       ),
//       child: Container(
//         width: size.width,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: BlocConsumer<UserBloc, UserState>(
//             bloc: globals.userBloc,
//             listener: (context, state) {
//               if (state is GetReachRelationshipSuccess) {
//                 isReaching.value = state.isReaching!;
//               }
//             },
//             builder: (context, snapshot) {
//               return BlocConsumer<SocialServiceBloc, SocialServiceState>(
//                   bloc: globals.socialServiceBloc,
//                   listener: (context, state) {},
//                   builder: (context, state) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Helper.renderProfilePicture(
//                                   postModel!.postOwnerProfile!.profilePicture,
//                                   size: 33,
//                                 ).paddingOnly(l: 13, t: 10),
//                                 SizedBox(width: getScreenWidth(9)),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           '@${postModel!.postOwnerProfile!.username}',
//                                           style: TextStyle(
//                                             fontSize: getScreenHeight(15),
//                                             fontWeight: FontWeight.w500,
//                                             color: AppColors.textColor2,
//                                           ),
//                                         ),
//                                         // const SizedBox(width: 3),
//                                         // SvgPicture.asset('assets/svgs/verified.svg')
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           postModel!.location!
//                                                       .toLowerCase()
//                                                       .trim()
//                                                       .toString() ==
//                                                   'nil'
//                                               ? ''
//                                               : postModel!.location!.length > 23
//                                                   ? postModel!.location!
//                                                       .substring(0, 23)
//                                                   : postModel!.location!,
//                                           style: TextStyle(
//                                             fontSize: getScreenHeight(10),
//                                             fontFamily: 'Poppins',
//                                             letterSpacing: 0.4,
//                                             fontWeight: FontWeight.w400,
//                                             color: AppColors.textColor2,
//                                           ),
//                                         ),
//                                         Text(
//                                           postDuration,
//                                           style: TextStyle(
//                                             fontSize: getScreenHeight(10),
//                                             fontFamily: 'Poppins',
//                                             letterSpacing: 0.4,
//                                             fontWeight: FontWeight.w400,
//                                             color: AppColors.textColor2,
//                                           ),
//                                         ).paddingOnly(l: 6),
//                                       ],
//                                     ),
//                                   ],
//                                 ).paddingOnly(t: 10),
//                               ],
//                             ),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SvgPicture.asset('assets/svgs/starred.svg'),
//                                 SizedBox(width: getScreenWidth(9)),
//                                 IconButton(
//                                   onPressed: () async {
//                                     await _showReacherCardBottomSheet(
//                                         context, postModel!);
//                                   },
//                                   iconSize: getScreenHeight(19),
//                                   padding: const EdgeInsets.all(0),
//                                   icon: SvgPicture.asset(
//                                       'assets/svgs/kebab card.svg'),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         Flexible(
//                           child: ExpandableText(
//                             "${postModel!.content}",
//                             prefixText: postModel!.edited!
//                                 ? "(Reach Edited ${Helper.parseUserLastSeen(postModel!.updatedAt.toString())})"
//                                 : null,
//                             prefixStyle: TextStyle(
//                                 fontSize: getScreenHeight(12),
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w400,
//                                 color: AppColors.primaryColor),
//                             onPrefixTap: () {
//                               tooltipkey.currentState?.ensureTooltipVisible();
//                             },
//                             expandText: 'see more',
//                             maxLines: 3,
//                             linkColor: Colors.blue,
//                             animation: true,
//                             expanded: false,
//                             collapseText: 'see less',
//                             onHashtagTap: (value) {
//                               showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return DictionaryDialog(
//                                       abbr: value,
//                                       meaning: '',
//                                       word: '',
//                                     );
//                                   });
//                             },
//                             onMentionTap: (value) {
//                               timeLineFeedStore.getUserByUsername(context,
//                                   username: value);
//
//                               debugPrint("Value $value");
//                             },
//                             mentionStyle: const TextStyle(
//                                 decoration: TextDecoration.underline,
//                                 color: Colors.blue),
//                             hashtagStyle: const TextStyle(
//                                 decoration: TextDecoration.underline,
//                                 color: Colors.blue),
//                           ).paddingSymmetric(h: 16, v: 10),
//                         ),
//                         Tooltip(
//                           key: tooltipkey,
//                           triggerMode: TooltipTriggerMode.manual,
//                           showDuration: const Duration(seconds: 1),
//                           message: 'This reach has been edited',
//                         ),
//                         if ((postModel!.imageMediaItems ?? []).isNotEmpty)
//                           PostMedia(post: postModel!)
//                               .paddingOnly(r: 16, l: 16, b: 16, t: 10)
//                         else
//                           const SizedBox.shrink(),
//                         if ((postModel!.videoMediaItem ?? '').isNotEmpty)
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height / 2,
//                             child: TimeLineVideoPlayer(
//                                 post: postModel!,
//                                 videoUrl: postModel!.videoMediaItem!),
//                           )
//                         else
//                           (postModel!.audioMediaItem ?? '').isNotEmpty
//                               ? Container(
//                                   height: 59,
//                                   margin: const EdgeInsets.only(bottom: 10),
//                                   width: SizeConfig.screenWidth,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: const Color(0xfff5f5f5)),
//                                   child: Row(children: [
//                                     Expanded(
//                                         child: MomentAudioPlayer(
//                                       audioPath: postModel!.audioMediaItem!,
//                                     )),
//                                   ]),
//                                 )
//                               : const SizedBox.shrink(),
//                         (postModel?.repostedPost != null)
//                             ? RepostedPost(
//                                 post: postModel!,
//                               ).paddingOnly(l: 0, r: 0, b: 10, t: 0)
//                             : const SizedBox.shrink(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Flexible(
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 11,
//                                   vertical: 7,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(15),
//                                   color: const Color(0xFFF5F5F5),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     GestureDetector(
//                                       onLongPress: () {
//                                         if ((postModel!.nLikes ?? 0) > 0) {
//                                           showPostReactors(context,
//                                               postId: postModel!.postId!,
//                                               reactionType: 'Like');
//                                         }
//                                       },
//                                       child: IconButton(
//                                         onPressed: () {
//                                           if (onLike != null) onLike!();
//                                         },
//                                         padding: EdgeInsets.zero,
//                                         constraints: const BoxConstraints(),
//                                         icon: SvgPicture.asset(
//                                           postModel!.isLiked ?? false
//                                               ? 'assets/svgs/like-active.svg'
//                                               : 'assets/svgs/like.svg',
//                                           color: likeColour,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: getScreenWidth(4)),
//                                     FittedBox(
//                                       child: Text(
//                                         '${postModel!.nLikes}',
//                                         style: TextStyle(
//                                           fontSize: getScreenHeight(12),
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.textColor3,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: getScreenWidth(15)),
//                                     commentIcon(context,
//                                         isReaching: isReaching.value),
//                                     Visibility(
//                                       visible:
//                                           postModel!.authId != globals.userId,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           SizedBox(width: getScreenWidth(15)),
//                                           IconButton(
//                                             onPressed: () {
//                                               if (onMessage != null)
//                                                 onMessage!();
//                                             },
//                                             padding: const EdgeInsets.all(0),
//                                             constraints: const BoxConstraints(),
//                                             icon: SvgPicture.asset(
//                                               'assets/svgs/message.svg',
//                                               height: 20,
//                                               width: 20,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: getScreenWidth(20)),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Flexible(
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 11,
//                                       vertical: 7,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color: const Color(0xFFF5F5F5),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GestureDetector(
//                                           onLongPress: () {
//                                             if ((postModel!.nUpvotes ?? 0) >
//                                                     0 &&
//                                                 (postModel!.authId ==
//                                                     globals.user!.id!)) {
//                                               showPostReactors(context,
//                                                   postId: postModel!.postId!,
//                                                   reactionType: 'Upvote');
//                                             }
//                                           },
//                                           child: IconButton(
//                                             onPressed: () {
//                                               if (onUpvote != null) onUpvote;
//                                             },
//                                             padding: EdgeInsets.zero,
//                                             constraints: const BoxConstraints(),
//                                             icon: SvgPicture.asset(
//                                               (postModel?.isVoted ?? '') ==
//                                                       'Upvote'
//                                                   ? 'assets/svgs/shoutup-active.svg'
//                                                   : 'assets/svgs/shoutup.svg',
//                                             ),
//                                           ),
//                                         ),
//                                         Flexible(
//                                             child: SizedBox(
//                                                 width: getScreenWidth(4))),
//                                         Flexible(
//                                             child: SizedBox(
//                                                 width: getScreenWidth(4))),
//                                         GestureDetector(
//                                           onLongPress: () {
//                                             if ((postModel!.nDownvotes ?? 0) >
//                                                     0 &&
//                                                 (postModel!.authId ==
//                                                     globals.user!.id!)) {
//                                               showPostReactors(context,
//                                                   postId: postModel!.postId!,
//                                                   reactionType: 'Downvote');
//                                             }
//                                           },
//                                           child: IconButton(
//                                             onPressed: () {
//                                               if (onDownvote != null)
//                                                 onDownvote;
//                                             },
//                                             padding: EdgeInsets.zero,
//                                             constraints: const BoxConstraints(),
//                                             icon: SvgPicture.asset(
//                                               'assets/svgs/downvote.svg',
//                                             ),
//                                           ),
//                                         ),
//                                         Flexible(
//                                             child: SizedBox(
//                                                 width: getScreenWidth(4))),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ).paddingOnly(b: 32, r: 16, l: 16, t: 5),
//                       ],
//                     );
//                   });
//             }),
//       ),
//     );
//   }
//
//   Widget commentIcon(BuildContext routeContext, {bool isReaching = false}) {
//     switch (postModel!.commentOption) {
//       case "everyone":
//         return InkWell(
//           onTap: () {
//             RouteNavigators.route(
//                 routeContext,
//                 CommentReach(
//                     postFeedModel: timeLineFeedStore
//                         .getPostModelById(postModel!.postId!, type: 'post')));
//           },
//           child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//             SvgPicture.asset(
//               'assets/svgs/comment.svg',
//             ),
//             const SizedBox(width: 3),
//             CustomText(
//               text: momentFeedStore.getCountValue(
//                 value: postModel!.nComments!,
//               ),
//               size: 15,
//               isCenter: true,
//               weight: FontWeight.w600,
//               color: const Color(0xff001824),
//             )
//           ]),
//         );
//
//       case "people_you_follow":
//         if (postModel!.postOwnerProfile!.authId == globals.userId ||
//             isReaching) {
//           return InkWell(
//             onTap: () {
//               RouteNavigators.route(
//                   routeContext,
//                   CommentReach(
//                       postFeedModel: timeLineFeedStore
//                           .getPostModelById(postModel!.postId!, type: 'post')));
//             },
//             child:
//                 Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//               SvgPicture.asset(
//                 'assets/svgs/comment.svg',
//               ),
//               const SizedBox(width: 3),
//               CustomText(
//                 text: momentFeedStore.getCountValue(
//                   value: postModel!.nComments!,
//                 ),
//                 size: 15,
//                 isCenter: true,
//                 weight: FontWeight.w600,
//                 color: const Color(0xff001824),
//               )
//             ]),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       case "only_people_you_mention":
//         if (postModel!.mentionList!.contains(globals.user!.username) ||
//             (postModel!.postOwnerProfile!.authId == globals.userId)) {
//           return InkWell(
//             onTap: () {
//               RouteNavigators.route(
//                   routeContext,
//                   CommentReach(
//                       postFeedModel: timeLineFeedStore
//                           .getPostModelById(postModel!.postId!, type: 'post')));
//             },
//             child:
//                 Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//               SvgPicture.asset(
//                 'assets/svgs/comment.svg',
//               ),
//               const SizedBox(width: 3),
//               CustomText(
//                 text: momentFeedStore.getCountValue(
//                   value: postModel!.nComments!,
//                 ),
//                 size: 15,
//                 isCenter: true,
//                 weight: FontWeight.w600,
//                 color: const Color(0xff001824),
//               )
//             ]),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       default:
//         return InkWell(
//           onTap: () {
//             RouteNavigators.route(
//                 routeContext,
//                 CommentReach(
//                     postFeedModel: timeLineFeedStore
//                         .getPostModelById(postModel!.postId!, type: 'post')));
//           },
//           child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//             SvgPicture.asset(
//               'assets/svgs/comment.svg',
//             ),
//             const SizedBox(width: 3),
//             CustomText(
//               text: momentFeedStore.getCountValue(
//                 value: postModel!.nComments!,
//               ),
//               size: 15,
//               isCenter: true,
//               weight: FontWeight.w600,
//               color: const Color(0xff001824),
//             )
//           ]),
//         );
//     }
//   }
// }
//
// class _CommentReachCard extends HookWidget {
//   const _CommentReachCard({
//     Key? key,
//     required this.commentModel,
//     this.onComment,
//     this.onDownvote,
//     this.onLike,
//     this.onMessage,
//     this.onUpvote,
//     this.likeColour,
//   }) : super(key: key);
//
//   final CommentModel? commentModel;
//   final Function()? onLike, onComment, onMessage, onUpvote, onDownvote;
//   final Color? likeColour;
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 13,
//         vertical: 7,
//       ),
//       child: Container(
//         width: size.width,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
//             bloc: globals.socialServiceBloc,
//             listener: (context, state) {},
//             builder: (context, state) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(children: [
//                         Helper.renderProfilePicture(
//                           commentModel!.commentOwnerProfile!.profilePicture,
//                           size: 33,
//                         ).paddingOnly(l: 13, t: 10),
//                         SizedBox(width: getScreenWidth(9)),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   '@${commentModel!.commentOwnerProfile!.username}',
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(15),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.textColor2,
//                                   ),
//                                 ),
//                                 // const SizedBox(width: 3),
//                                 // SvgPicture.asset('assets/svgs/verified.svg')
//                               ],
//                             ),
//                             Text(
//                               'Comment on @${commentModel!.commentOwnerProfile!.username}',
//                               style: TextStyle(
//                                 fontSize: getScreenHeight(11),
//                                 fontWeight: FontWeight.w400,
//                                 color: AppColors.textColor2,
//                               ),
//                             ),
//                           ],
//                         ).paddingOnly(t: 10),
//                       ]),
//                     ],
//                   ),
//                   Flexible(
//                     child: Text(
//                       commentModel!.content ?? '',
//                       style: TextStyle(
//                         fontSize: getScreenHeight(14),
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ).paddingSymmetric(v: 10, h: 16),
//                   ),
//                   SizedBox(height: getScreenHeight(10)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Flexible(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 11,
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: const Color(0xFFF5F5F5),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   if (onLike != null) onLike!();
//                                 },
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                                 icon: SvgPicture.asset(
//                                   (commentModel!.like ?? []).indexWhere((e) =>
//                                               e.authId == globals.userId) <
//                                           0
//                                       ? 'assets/svgs/like.svg'
//                                       : 'assets/svgs/like-active.svg',
//                                   color: likeColour,
//                                 ),
//                               ),
//                               SizedBox(width: getScreenWidth(4)),
//                               FittedBox(
//                                 child: Text(
//                                   '${commentModel!.nLikes}',
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(12),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.textColor3,
//                                   ),
//                                 ),
//                               ),
//                               // SizedBox(width: getScreenWidth(15)),
//                               // IconButton(
//                               //   onPressed: () {
//                               //     // RouteNavigators.route(
//                               //     //     context,  ViewCommentsScreen(post: postFeedModel!));
//                               //   },
//                               //   padding: EdgeInsets.zero,
//                               //   constraints: const BoxConstraints(),
//                               //   icon: SvgPicture.asset(
//                               //     'assets/svgs/comment.svg',
//                               //     height: 20,
//                               //     width: 20,
//                               //   ),
//                               // ),
//                               // SizedBox(width: getScreenWidth(4)),
//                               // FittedBox(
//                               //   child: Text(
//                               //     '${commentModel!.nComments}',
//                               //     style: TextStyle(
//                               //       fontSize: getScreenHeight(12),
//                               //       fontWeight: FontWeight.w500,
//                               //       color: AppColors.textColor3,
//                               //     ),
//                               //   ),
//                               // ),
//                               if (commentModel!.authId != globals.user!.id)
//                                 SizedBox(width: getScreenWidth(15)),
//                               if (commentModel!.authId != globals.user!.id)
//                                 IconButton(
//                                   onPressed: () {
//                                     if (onMessage != null) onMessage!();
//                                   },
//                                   padding: const EdgeInsets.all(0),
//                                   constraints: const BoxConstraints(),
//                                   icon: SvgPicture.asset(
//                                     'assets/svgs/message.svg',
//                                     height: getScreenHeight(20),
//                                     width: getScreenWidth(20),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ).paddingOnly(b: 10, r: 20, l: 20),
//                 ],
//               );
//             }),
//       ),
//     );
//   }
// }
//
// Future _showReacherCardBottomSheet(
//     BuildContext context, PostModel postModel) async {
//   return showModalBottomSheet(
//     backgroundColor: Colors.transparent,
//     context: context,
//     builder: (context) {
//       return BlocConsumer<SocialServiceBloc, SocialServiceState>(
//         bloc: globals.socialServiceBloc,
//         listener: (context, state) {
//           if (state is GetPostSuccess) {
//             RouteNavigators.pop(context);
//             RouteNavigators.route(context, EditReach(post: state.data!));
//           }
//           if (state is GetPostError) {
//             RouteNavigators.pop(context);
//             Snackbars.error(context, message: state.error);
//           }
//         },
//         builder: (context, state) {
//           return Container(
//               decoration: const BoxDecoration(
//                 color: AppColors.greyShade7,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                 ),
//               ),
//               child: ListView(shrinkWrap: true, children: [
//                 Center(
//                   child: Container(
//                       height: getScreenHeight(4),
//                       width: getScreenWidth(58),
//                       decoration: BoxDecoration(
//                           color: AppColors.greyShade4,
//                           borderRadius: BorderRadius.circular(40))),
//                 ).paddingOnly(t: 23),
//                 SizedBox(height: getScreenHeight(20)),
//                 Column(
//                   children: [
//                     if (postModel.authId == globals.user!.id)
//                       KebabBottomTextButton(
//                           label: 'Edit content',
//                           onPressed: () {
//                             globals.socialServiceBloc!
//                                 .add(GetPostEvent(postId: postModel.postId));
//                           }),
//                     if (postModel.authId == globals.user!.id)
//                       KebabBottomTextButton(
//                           label: 'Delete post',
//                           onPressed: () {
//                             globals.socialServiceBloc!
//                                 .add(DeletePostEvent(postId: postModel.postId));
//                             RouteNavigators.pop(context);
//                           }),
//                     KebabBottomTextButton(
//                         label: 'Share Post',
//                         onPressed: () {
//                           RouteNavigators.pop(context);
//                           Share.share(
//                               'Have fun viewing this: ${postModel.postSlug!}');
//                         }),
//                     KebabBottomTextButton(
//                       label: 'Copy link',
//                       onPressed: () {
//                         RouteNavigators.pop(context);
//                         Clipboard.setData(
//                             ClipboardData(text: postModel.postSlug!));
//                         Snackbars.success(context,
//                             message: 'Link copied to clipboard');
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: getScreenHeight(20)),
//               ]));
//         },
//       );
//     },
//   );
// }
//
// class RecipientAccountProfile extends StatefulHookWidget {
//   static const String id = "recipient_account_screen";
//   final String? recipientEmail,
//       recipientImageUrl,
//       recipientId,
//       recipientCoverImageUrl;
//   const RecipientAccountProfile(
//       {Key? key,
//       this.recipientEmail,
//       this.recipientImageUrl,
//       this.recipientCoverImageUrl,
//       this.recipientId})
//       : super(key: key);
//
//   @override
//   State<RecipientAccountProfile> createState() =>
//       _RecipientAccountProfileState();
// }
//
// class _RecipientAccountProfileState extends State<RecipientAccountProfile>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;
//
//   late final _reachoutsRefreshController =
//       RefreshController(initialRefresh: false);
//   late final _commentsRefreshController =
//       RefreshController(initialRefresh: false);
//   late final _savedPostsRefreshController =
//       RefreshController(initialRefresh: false);
//   late final _likesRefreshController = RefreshController(initialRefresh: false);
//   late final _shoutoutRefreshController =
//       RefreshController(initialRefresh: false);
//   late final _shoutdownRefreshController =
//       RefreshController(initialRefresh: false);
//   late final _shareRefreshController = RefreshController(initialRefresh: false);
//
//   Set active = {};
//
//   handleTap(index) {
//     if (active.isNotEmpty) active.clear();
//     setState(() {
//       active.add(index);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     debugPrint("UserId : ${widget.recipientId}");
//     _tabController = TabController(length: 7, vsync: this);
//     globals.socialServiceBloc!.add(GetAllPostsEvent(
//         pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
//     globals.socialServiceBloc!.add(GetPersonalCommentsEvent(
//         pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
//     globals.userBloc!.add(GetRecipientProfileEvent(email: widget.recipientId));
//     globals.userBloc!.add(GetReachRelationshipEvent(
//         userIdToReach: widget.recipientId,
//         type: ReachRelationshipType.reaching));
//     globals.userBloc!
//         .add(GetStarRelationshipEvent(userIdToStar: widget.recipientId));
//     globals.socialServiceBloc!.add(GetLikedPostsEvent(
//         pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
//     globals.socialServiceBloc!.add(GetVotedPostsEvent(
//         pageLimit: 50,
//         pageNumber: 1,
//         voteType: 'Upvote',
//         authId: widget.recipientId));
//     globals.socialServiceBloc!.add(GetVotedPostsEvent(
//         pageLimit: 50,
//         pageNumber: 1,
//         voteType: 'Downvote',
//         authId: widget.recipientId));
//
//     globals.socialServiceBloc!
//         .add(GetStatusFeedEvent(pageLimit: 50, pageNumber: 1));
//   }
//
//   TabBar get _tabBar => TabBar(
//         isScrollable: true,
//         controller: _tabController,
//         indicatorWeight: 1.5,
//         unselectedLabelColor: AppColors.textColor2,
//         indicatorColor: Colors.transparent,
//         labelColor: AppColors.white,
//         labelPadding: const EdgeInsets.symmetric(horizontal: 10),
//         overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
//         indicator: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           color: AppColors.textColor2,
//         ),
//         labelStyle: TextStyle(
//           fontSize: getScreenHeight(15),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         ),
//         unselectedLabelStyle: TextStyle(
//           fontSize: getScreenHeight(15),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w400,
//         ),
//         tabs: [
//           Tab(
//             child: GestureDetector(
//               onTap: () => setState(() {
//                 _tabController?.animateTo(0);
//                 collapseUserProfile();
//               }),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: FittedBox(
//                   child: Text(
//                     'Reaches',
//                     style: TextStyle(
//                       fontSize: getScreenHeight(15),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Tab(
//             child: GestureDetector(
//               onTap: () => setState(() {
//                 _tabController?.animateTo(1);
//                 collapseUserProfile();
//               }),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: FittedBox(
//                   child: Text(
//                     'Comments',
//                     style: TextStyle(
//                       fontSize: getScreenHeight(15),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Tab(
//             iconMargin: EdgeInsets.zero,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => setState(() {
//                     _tabController?.animateTo(2);
//                     collapseUserProfile();
//                   }),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 10),
//                     child: FittedBox(
//                       child: Text(
//                         'Likes',
//                         style: TextStyle(
//                           fontSize: getScreenHeight(15),
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Tab(
//             child: GestureDetector(
//               onTap: () => setState(() {
//                 _tabController?.animateTo(3);
//                 collapseUserProfile();
//               }),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: FittedBox(
//                   child: Text(
//                     'Shoutout',
//                     style: TextStyle(
//                       fontSize: getScreenHeight(15),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Tab(
//             child: GestureDetector(
//               onTap: () => setState(() {
//                 _tabController?.animateTo(4);
//                 collapseUserProfile();
//               }),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: FittedBox(
//                   child: Text(
//                     'Shoutdown',
//                     style: TextStyle(
//                       fontSize: getScreenHeight(15),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Tab(
//             child: GestureDetector(
//               onTap: () => setState(() {
//                 _tabController?.animateTo(5);
//                 collapseUserProfile();
//               }),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: FittedBox(
//                   child: Text(
//                     'Quote',
//                     style: TextStyle(
//                       fontSize: getScreenHeight(15),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Tab(
//             child: GestureDetector(
//               onTap: () => setState(() {
//                 _tabController?.animateTo(6);
//                 collapseUserProfile();
//               }),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: FittedBox(
//                   child: Text(
//                     'Saved',
//                     style: TextStyle(
//                       fontSize: getScreenHeight(15),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//   String message = '';
//
//   bool _isReaching = false;
//   bool _isStarring = false;
//   bool isUserCollapsed = true;
//
//   void collapseUserProfile() => setState(() {
//         isUserCollapsed = false;
//       });
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     final reachDM = useState(false);
//     final viewProfile = useState(false);
//     final _posts = useState<List<PostModel>>([]);
//     final _comments = useState<List<CommentModel>>([]);
//     final _likedPosts = useState<List<PostFeedModel>>([]);
//     final _shoutDowns = useState<List<PostFeedModel>>([]);
//     final _shoutOuts = useState<List<PostFeedModel>>([]);
//     final _sharedPosts = useState<List<PostFeedModel>>([]);
//     final _userStatus = useState<List<StatusFeedResponseModel>>([]);
//     return Scaffold(
//       body: BlocConsumer<SocialServiceBloc, SocialServiceState>(
//         bloc: globals.socialServiceBloc,
//         listener: (context, state) {
//           if (state is GetAllPostsSuccess) {
//             _posts.value = state.posts!;
//             _reachoutsRefreshController.refreshCompleted();
//           }
//           if (state is GetAllPostsError) {
//             Snackbars.error(context, message: state.error);
//             _reachoutsRefreshController.refreshFailed();
//           }
//
//           if (state is GetLikedPostsSuccess) {
//             debugPrint("LikedPosts ${state.posts}");
//             _likedPosts.value = state.posts!;
//             _likesRefreshController.refreshCompleted();
//           }
//           if (state is GetVotedPostsSuccess) {
//             if (state.voteType == "Downvote") {
//               debugPrint("Downvote: ${state.posts}");
//               _shoutDowns.value = state.posts!;
//             }
//             if (state.voteType == "Upvote") {
//               debugPrint("Upvote: ${state.posts}");
//               _shoutOuts.value = state.posts!;
//             }
//           }
//           if (state is GetPersonalCommentsSuccess) {
//             _comments.value = state.data!;
//             _commentsRefreshController.refreshCompleted();
//           }
//           if (state is GetPersonalCommentsError) {
//             Snackbars.error(context, message: state.error);
//             _commentsRefreshController.refreshFailed();
//           }
//           if (state is GetStatusFeedSuccess) {
//             _userStatus.value = state.status!;
//           }
//         },
//         builder: (context, state) {
//           return BlocConsumer<UserBloc, UserState>(
//             bloc: globals.userBloc,
//             listener: (context, state) {
//               if (state is RecipientUserData) {
//                 globals.recipientUser = state.user;
//                 setState(() {});
//               }
//
//               if (state is UserError) {
//                 Snackbars.error(context, message: state.error);
//                 if ((state.error ?? '')
//                     .toLowerCase()
//                     .contains('already reaching')) {
//                   _isReaching = true;
//                   setState(() {});
//                 }
//               }
//
//               if (state is GetStarRelationshipSuccess) {
//                 _isStarring = state.isStarring!;
//                 setState(() {});
//               }
//
//               if (state is StarUserSuccess) {
//                 _isStarring = true;
//                 Snackbars.success(context,
//                     message: 'You are now starring this profile!');
//                 setState(() {});
//               }
//
//               if (state is DelStarRelationshipSuccess) {
//                 _isStarring = false;
//                 setState(() {});
//               }
//
//               if (state is GetReachRelationshipSuccess) {
//                 _isReaching = state.isReaching!;
//                 setState(() {});
//               }
//
//               if (state is DelReachRelationshipSuccess) {
//                 _isReaching = false;
//                 globals.userBloc!
//                     .add(GetRecipientProfileEvent(email: widget.recipientId));
//                 setState(() {});
//               }
//
//               if (state is UserLoaded) {
//                 Snackbars.success(context,
//                     message: "Reached User Successfully");
//                 globals.userBloc!
//                     .add(GetRecipientProfileEvent(email: widget.recipientId));
//                 _isReaching = true;
//
//                 setState(() {});
//               }
//             },
//             builder: (context, state) {
//               bool _isLoadingPosts = state is GetAllPostsLoading;
//               bool _isLoadingLikes = state is GetLikedPostsLoading;
//               bool _isLoadingComments = state is GetPersonalCommentsLoading;
//               bool _isLoadingSavedPosts = state is GetAllSavedPostsLoading;
//               bool _isLoading = state is UserLoading;
//               bool timelineLoading = state is GetAllPostsLoading;
//               timelineLoading = state is GetPersonalCommentsLoading;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Visibility(
//                     visible: isUserCollapsed,
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       fit: StackFit.passthrough,
//                       clipBehavior: Clip.none,
//                       children: <Widget>[
//                         /// Banner image
//                         GestureDetector(
//                           child: SizedBox(
//                             height: getScreenHeight(190),
//                             width: size.width,
//                             child: RecipientCoverPicture(
//                               imageUrl: globals.recipientUser!.coverPicture,
//                             ),
//                           ),
//                           onTap: () {
//                             RouteNavigators.route(
//                                 context,
//                                 FullScreenWidget(
//                                   child: Stack(children: <Widget>[
//                                     Container(
//                                       color: AppColors
//                                           .black, // Your screen background color
//                                     ),
//                                     Column(children: <Widget>[
//                                       Container(height: getScreenHeight(100)),
//                                       RecipientCoverPicture(
//                                           imageUrl: globals
//                                               .recipientUser!.coverPicture),
//                                     ]),
//                                     Positioned(
//                                       top: 0.0,
//                                       left: 0.0,
//                                       right: 0.0,
//                                       child: AppBar(
//                                         title: const Text(
//                                             'Cover Photo'), // You can add title here
//                                         leading: IconButton(
//                                           icon: const Icon(Icons.arrow_back,
//                                               color: AppColors.white),
//                                           onPressed: () =>
//                                               Navigator.of(context).pop(),
//                                         ),
//                                         backgroundColor: AppColors
//                                             .black, //You can make this transparent
//                                         elevation: 0.0, //No shadow
//                                       ),
//                                     ),
//                                   ]),
//                                 ));
//                           },
//                         ),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               IconButton(
//                                 padding: EdgeInsets.zero,
//                                 icon: Container(
//                                   width: getScreenWidth(40),
//                                   height: getScreenHeight(40),
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color:
//                                         AppColors.textColor2.withOpacity(0.5),
//                                   ),
//                                   child: SvgPicture.asset(
//                                     'assets/svgs/back.svg',
//                                     color: AppColors.white,
//                                     width: getScreenWidth(50),
//                                     height: getScreenHeight(50),
//                                   ),
//                                 ),
//                                 onPressed: () => RouteNavigators.route(
//                                     context, const HomeScreen()),
//                               ),
//                               IconButton(
//                                 padding: EdgeInsets.zero,
//                                 icon: Container(
//                                   width: getScreenWidth(40),
//                                   height: getScreenHeight(40),
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color:
//                                         AppColors.textColor2.withOpacity(0.5),
//                                   ),
//                                   child: SvgPicture.asset(
//                                     'assets/svgs/pop-vertical.svg',
//                                     color: AppColors.white,
//                                     width: getScreenWidth(50),
//                                     height: getScreenHeight(50),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   await showProfileMenuBottomSheet(context,
//                                       user: globals.recipientUser!,
//                                       isStarring: _isStarring);
//                                 },
//                                 splashRadius: 20,
//                               )
//                             ]).paddingOnly(t: 40),
//
//                         Positioned(
//                           top: size.height * 0.2 - 30,
//                           child: AnimatedContainer(
//                             width: getScreenWidth(100),
//                             height: getScreenHeight(100),
//                             duration: const Duration(seconds: 1),
//                             child: globals.recipientUser!.profilePicture == null
//                                 ? ImagePlaceholder(
//                                     width: getScreenWidth(100),
//                                     height: getScreenHeight(100),
//                                     border: Border.all(
//                                         color: Colors.grey.shade50, width: 3.0),
//                                   )
//                                 : GestureDetector(
//                                     child: RecipientProfilePicture(
//                                       imageUrl:
//                                           globals.recipientUser!.profilePicture,
//                                       width: getScreenWidth(100),
//                                       height: getScreenHeight(100),
//                                       border: Border.all(
//                                           color: Colors.grey.shade50,
//                                           width: 3.0),
//                                     ),
//                                     onTap: () {
//                                       if (_userStatus.value.any((e) =>
//                                           e.username ==
//                                           globals.recipientUser!.username)) {
//                                         showProfilePictureOrViewStatus2(
//                                           context,
//                                           user: globals.recipientUser,
//                                           userStatus: _userStatus.value,
//                                         );
//                                       } else if (globals
//                                               .recipientUser!.profilePicture !=
//                                           null) {
//                                         RouteNavigators.route(
//                                             context,
//                                             pictureViewer2(context,
//                                                 ownerProfilePicture:
//                                                     globals.recipientUser));
//                                       } else {
//                                         Snackbars.error(context,
//                                             message: 'No Profile photo');
//                                       }
//                                     },
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Stack(
//                     children: [
//                       Visibility(
//                         visible: isUserCollapsed,
//                         child: Column(
//                           children: [
//                             SizedBox(height: getScreenHeight(15)),
//                             Text(
//                                 ('@${globals.recipientUser!.username}')
//                                     .toLowerCase(),
//                                 style: TextStyle(
//                                   fontSize: getScreenHeight(15),
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.textColor2,
//                                 )),
//                             // Text('@${globals.recipientUser!.username ?? 'username'}',
//                             //     style: TextStyle(
//                             //       fontSize: getScreenHeight(13),
//                             //       fontWeight: FontWeight.w400,
//                             //       color: AppColors.textColor2,
//                             //     )),
//                             SizedBox(height: getScreenHeight(15)),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Row(
//                                   children: [
//                                     InkWell(
//                                       onTap: () => RouteNavigators.route(
//                                           context,
//                                           RecipientAccountStatsInfo(
//                                             index: 0,
//                                             recipientId: widget.recipientId,
//                                             // recipientId: widget.recipientId,
//                                           )),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             globals.recipientUser!.nReachers
//                                                 .toString(),
//                                             style: TextStyle(
//                                                 fontSize: getScreenHeight(15),
//                                                 color: AppColors.textColor2,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           Text(
//                                             'Reachers',
//                                             style: TextStyle(
//                                                 fontSize: getScreenHeight(13),
//                                                 color: AppColors.greyShade2,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: getScreenWidth(20)),
//                                     InkWell(
//                                       onTap: () => RouteNavigators.route(
//                                           context,
//                                           RecipientAccountStatsInfo(
//                                             index: 1,
//                                             recipientId: widget.recipientId,
//                                           )),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             globals.recipientUser!.nReaching
//                                                 .toString(),
//                                             style: TextStyle(
//                                                 fontSize: getScreenHeight(15),
//                                                 color: AppColors.textColor2,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           Text(
//                                             'Reaching',
//                                             style: TextStyle(
//                                                 fontSize: getScreenHeight(13),
//                                                 color: AppColors.greyShade2,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     //SizedBox(width: getScreenWidth(20)),
//                                     /*InkWell(
//                                       onTap: () => RouteNavigators.route(
//                                           context, RecipientAccountStatsInfo(index: 2, recipientId: widget.recipientId)),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             globals.recipientUser!.nStaring
//                                                 .toString(),
//                                             style: TextStyle(
//                                                 fontSize: getScreenHeight(15),
//                                                 color: AppColors.textColor2,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           Text(
//                                             'Starring',
//                                             style: TextStyle(
//                                                 fontSize: getScreenHeight(13),
//                                                 color: AppColors.greyShade2,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                         ],
//                                       ),
//                                     )*/
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             globals.recipientUser!.bio != null &&
//                                     globals.recipientUser!.bio != ''
//                                 ? SizedBox(height: getScreenHeight(20))
//                                 : const SizedBox.shrink(),
//                             SizedBox(
//                                 width: getScreenWidth(290),
//                                 child: Text(
//                                   globals.recipientUser!.bio ?? '',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(13),
//                                     color: AppColors.greyShade2,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 )),
//                             globals.recipientUser!.bio != null &&
//                                     globals.recipientUser!.bio != ''
//                                 ? SizedBox(height: getScreenHeight(20))
//                                 : const SizedBox.shrink(),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: getScreenWidth(130),
//                                   height: getScreenHeight(41),
//                                   child: CustomButton(
//                                     isLoading: _isLoading,
//                                     loaderColor: _isReaching
//                                         ? AppColors.primaryColor
//                                         : AppColors.white,
//                                     label: _isReaching ? 'Reaching' : 'Reach',
//                                     color: _isReaching
//                                         ? AppColors.white
//                                         : AppColors.primaryColor,
//                                     onPressed: () {
//                                       if (!_isReaching) {
//                                         globals.userBloc!.add(ReachUserEvent(
//                                             userIdToReach:
//                                                 globals.recipientUser!.id));
//                                       } else {
//                                         globals.userBloc!.add(
//                                             DelReachRelationshipEvent(
//                                                 userIdToDelete:
//                                                     globals.recipientUser!.id));
//                                       }
//                                     },
//                                     size: size,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 9,
//                                       horizontal: 21,
//                                     ),
//                                     textColor: _isReaching
//                                         ? AppColors.black
//                                         : AppColors.white,
//                                     borderSide: _isReaching
//                                         ? const BorderSide(
//                                             color: AppColors.greyShade5)
//                                         : BorderSide.none,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 SizedBox(
//                                     width: getScreenWidth(130),
//                                     height: getScreenHeight(41),
//                                     child: CustomButton(
//                                       label: 'Reachout',
//                                       color: AppColors.white,
//                                       onPressed: () {
//                                         RouteNavigators.route(
//                                             context,
//                                             MsgChatInterface(
//                                               recipientUser:
//                                                   globals.recipientUser,
//                                             ));
//                                       },
//                                       size: size,
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 9,
//                                         horizontal: 21,
//                                       ),
//                                       textColor: AppColors.textColor2,
//                                       borderSide: const BorderSide(
//                                           color: AppColors.greyShade5),
//                                     )),
//                               ],
//                             ),
//                             SizedBox(height: getScreenHeight(15)),
//                           ],
//                         ).paddingOnly(t: 50),
//                       ),
//                       Visibility(
//                         visible: _isReaching,
//                         child: Positioned(
//                             top: size.height * 0.1 - 55,
//                             right: size.width * 0.4,
//                             //child: FractionalTranslation(
//                             //translation: const Offset(0.1, 0.1),
//                             child: InkWell(
//                               onTap: () {
//                                 print("User Tap for starring");
//                                 if (!_isStarring) {
//                                   globals.userBloc!.add(StarUserEvent(
//                                       userIdToStar: widget.recipientId));
//                                 } else {
//                                   globals.userBloc!.add(
//                                       DelStarRelationshipEvent(
//                                           starIdToDelete: widget.recipientId));
//                                 }
//                               },
//                               child: Container(
//                                 width: getScreenHeight(30),
//                                 height: getScreenHeight(30),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       color: !_isStarring
//                                           ? Colors.grey
//                                           : Colors.yellowAccent),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(Icons.star,
//                                     size: 19,
//                                     color: !_isStarring
//                                         ? Colors.grey
//                                         : Colors.yellowAccent),
//                               ),
//                             )
//                             //),
//                             ),
//                       ),
//                     ],
//                   ),
//                   Visibility(
//                     visible: isUserCollapsed ? true : false,
//                     child: Divider(
//                       color: const Color(0xFF767474).withOpacity(0.5),
//                       thickness: 0.5,
//                     ),
//                   ),
//                   Visibility(
//                     visible: isUserCollapsed ? false : true,
//                     child: GestureDetector(
//                       child: Stack(
//                         alignment: Alignment.topCenter,
//                         fit: StackFit.passthrough,
//                         clipBehavior: Clip.none,
//                         children: <Widget>[
//                           /// Banner image
//                           SizedBox(
//                             height: getScreenHeight(200),
//                             width: size.width,
//                             child: SvgPicture.asset(
//                               "assets/svgs/cover-banner.svg",
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 IconButton(
//                                   padding: EdgeInsets.zero,
//                                   icon: Container(
//                                     width: getScreenWidth(40),
//                                     height: getScreenHeight(40),
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color:
//                                           AppColors.textColor2.withOpacity(0.5),
//                                     ),
//                                     child: SvgPicture.asset(
//                                       'assets/svgs/back.svg',
//                                       color: AppColors.white,
//                                       width: getScreenWidth(50),
//                                       height: getScreenHeight(50),
//                                     ),
//                                   ),
//                                   onPressed: () => RouteNavigators.route(
//                                       context, const HomeScreen()),
//                                 ),
//                                 IconButton(
//                                   padding: EdgeInsets.zero,
//                                   icon: Container(
//                                     width: getScreenWidth(40),
//                                     height: getScreenHeight(40),
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color:
//                                           AppColors.textColor2.withOpacity(0.5),
//                                     ),
//                                     child: SvgPicture.asset(
//                                       'assets/svgs/pop-vertical.svg',
//                                       color: AppColors.white,
//                                       width: getScreenWidth(50),
//                                       height: getScreenHeight(50),
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     await showProfileMenuBottomSheet(context,
//                                         user: globals.recipientUser!,
//                                         isStarring: _isStarring);
//                                   },
//                                   splashRadius: 20,
//                                 )
//                               ]).paddingOnly(t: 40),
//                           Positioned(
//                             top: size.height * 0.2 - 100,
//                             child: Column(
//                               children: [
//                                 globals.recipientUser!.profilePicture == null
//                                     ? ImagePlaceholder(
//                                         width: 60,
//                                         height: 60,
//                                         border: Border.all(
//                                             color: Colors.grey.shade50,
//                                             width: 3.0),
//                                       )
//                                     : GestureDetector(
//                                         child: RecipientProfilePicture(
//                                           imageUrl: globals
//                                               .recipientUser!.profilePicture,
//                                           width: 60,
//                                           height: 60,
//                                           border: Border.all(
//                                               color: Colors.grey.shade50,
//                                               width: 3.0),
//                                         ),
//                                         onTap: () {
//                                           RouteNavigators.route(
//                                               context,
//                                               Stack(children: <Widget>[
//                                                 Container(
//                                                   color: AppColors
//                                                       .black, // Your screen background color
//                                                 ),
//                                                 Column(children: <Widget>[
//                                                   Container(
//                                                       height:
//                                                           getScreenHeight(100)),
//                                                   Container(
//                                                     height: size.height - 100,
//                                                     width: size.width,
//                                                     decoration: BoxDecoration(
//                                                       shape: BoxShape.rectangle,
//                                                       image: DecorationImage(
//                                                         image: NetworkImage(widget
//                                                             .recipientImageUrl!),
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ]),
//                                                 AppBar(
//                                                   title: const Text(
//                                                       'Profile Picture'), // You can add title here
//                                                   leading: IconButton(
//                                                     icon: const Icon(
//                                                         Icons.arrow_back,
//                                                         color: AppColors.white),
//                                                     onPressed: () =>
//                                                         Navigator.of(context)
//                                                             .pop(),
//                                                   ),
//                                                   backgroundColor: AppColors
//                                                       .black, //You can make this transparent
//                                                   elevation: 0.0, //No shadow
//                                                 ),
//                                               ]));
//                                         },
//                                       ),
//                                 SizedBox(height: getScreenHeight(20)),
//                                 Column(
//                                   children: [
//                                     Text(
//                                         ('${globals.recipientUser!.firstName} ${globals.recipientUser!.lastName}')
//                                             .toTitleCase(),
//                                         style: TextStyle(
//                                           fontSize: getScreenHeight(19),
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.white,
//                                         )),
//                                     Text(
//                                         '@${globals.recipientUser!.username ?? 'username'}',
//                                         style: TextStyle(
//                                           fontSize: getScreenHeight(13),
//                                           fontWeight: FontWeight.w400,
//                                           color: AppColors.white,
//                                         )),
//                                     SizedBox(height: getScreenHeight(15)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       onVerticalDragEnd: (dragEndDetails) {
//                         if (dragEndDetails.primaryVelocity! > 0) {
//                           setState(() {
//                             isUserCollapsed = !isUserCollapsed;
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                   SizedBox(height: getScreenHeight(10)),
//                   Visibility(
//                     visible: _isReaching,
//                     child: Expanded(
//                       child: Column(
//                         children: [
//                           Center(child: _tabBar),
//                           Expanded(
//                             child: NotificationListener<ScrollNotification>(
//                               onNotification: (scrollNotification) {
//                                 if (scrollNotification
//                                     is ScrollStartNotification) {
//                                   // setState(() {
//                                   //   collapseUserProfile();
//                                   // });
//                                   collapseUserProfile();
//                                 }
//                                 return false;
//                               },
//                               child: SingleChildScrollView(
//                                 child: SizedBox(
//                                   height: 600,
//                                   child: TabBarView(
//                                     controller: _tabController,
//                                     children: [
//                                       //REACHES TAB
//                                       if (timelineLoading)
//                                         const CircularLoader()
//                                       else
//                                         Refresher(
//                                           controller:
//                                               _reachoutsRefreshController,
//                                           onRefresh: () async {
//                                             globals.socialServiceBloc!
//                                                 .add(GetAllPostsEvent(
//                                               pageLimit: 50,
//                                               pageNumber: 1,
//                                               authId: widget.recipientId,
//                                             ));
//                                           },
//                                           child: _posts.value.isEmpty
//                                               ? ListView(
//                                                   padding: EdgeInsets.zero,
//                                                   shrinkWrap: true,
//                                                   children: const [
//                                                     EmptyTabWidget(
//                                                       title:
//                                                           "Reaches you???ve made",
//                                                       subtitle:
//                                                           "Find all posts or contributions you???ve made here ",
//                                                     )
//                                                   ],
//                                                 )
//                                               : ListView.builder(
//                                                   itemCount:
//                                                       _posts.value.length,
//                                                   itemBuilder:
//                                                       (context, index) {
//                                                     return _ReacherCard(
//                                                       postModel:
//                                                           _posts.value[index],
//                                                       onMessage: () {
//                                                         RouteNavigators.route(
//                                                             context,
//                                                             MsgChatInterface(
//                                                               recipientUser: globals
//                                                                   .recipientUser,
//                                                             ));
//                                                       },
//                                                       onComment: () {
//                                                         // RouteNavigators.route(
//                                                         //     context,
//                                                         //     ViewCommentsScreen(
//                                                         //       post: PostFeedModel(
//                                                         //           firstName: globals
//                                                         //               .recipientUser!
//                                                         //               .firstName,
//                                                         //           lastName: globals
//                                                         //               .recipientUser!
//                                                         //               .lastName,
//                                                         //           location: globals
//                                                         //               .recipientUser!
//                                                         //               .location,
//                                                         //           profilePicture: globals
//                                                         //               .recipientUser!
//                                                         //               .profilePicture,
//                                                         //           postId: _posts
//                                                         //               .value[index]
//                                                         //               .postId,
//                                                         //           postOwnerId: globals
//                                                         //               .recipientUser!
//                                                         //               .id,
//                                                         //           username: globals
//                                                         //               .recipientUser!
//                                                         //               .username,
//                                                         //           post: _posts
//                                                         //               .value[index]),
//                                                         //     ));
//                                                       },
//                                                     );
//                                                   },
//                                                 ),
//                                         ),
//
//                                       //COMMENTS TAB
//                                       if (timelineLoading)
//                                         const CircularLoader()
//                                       else
//                                         Refresher(
//                                           controller:
//                                               _commentsRefreshController,
//                                           onRefresh: () {
//                                             globals.socialServiceBloc!
//                                                 .add(GetPersonalCommentsEvent(
//                                               pageLimit: 50,
//                                               pageNumber: 1,
//                                               authId: widget.recipientId,
//                                             ));
//                                           },
//                                           child: _comments.value.isEmpty
//                                               ? ListView(
//                                                   padding: EdgeInsets.zero,
//                                                   shrinkWrap: true,
//                                                   children: const [
//                                                     EmptyTabWidget(
//                                                         title:
//                                                             'Comments you made on a post and comments made on your post',
//                                                         subtitle:
//                                                             'Here you will find all comments you???ve made on a post and also those made on your own posts')
//                                                   ],
//                                                 )
//                                               : ListView.builder(
//                                                   itemCount:
//                                                       _comments.value.length,
//                                                   itemBuilder:
//                                                       (context, index) {
//                                                     return _CommentReachCard(
//                                                       commentModel: _comments
//                                                           .value[index],
//                                                     );
//                                                   },
//                                                 ),
//                                         ),
//
//                                       // RECEPIENT LIKES TAB
//                                       if (timelineLoading)
//                                         const CircularLoader()
//                                       else
//                                         Refresher(
//                                           controller: _likesRefreshController,
//                                           onRefresh: () {
//                                             globals.socialServiceBloc!
//                                                 .add(GetLikedPostsEvent(
//                                               pageLimit: 50,
//                                               pageNumber: 1,
//                                               authId: widget.recipientId,
//                                             ));
//                                           },
//                                           child: _likedPosts.value.isEmpty
//                                               ? ListView(
//                                                   padding: EdgeInsets.zero,
//                                                   shrinkWrap: true,
//                                                   children: const [
//                                                     EmptyTabWidget(
//                                                       title: "Likes they made",
//                                                       subtitle:
//                                                           "Find post they liked",
//                                                     )
//                                                   ],
//                                                 )
//                                               : ListView.builder(
//                                                   itemCount:
//                                                       _likedPosts.value.length,
//                                                   itemBuilder:
//                                                       (context, index) {
//                                                     return PostFeedReacherCard(
//                                                       likingPost: false,
//                                                       postFeedModel: _likedPosts
//                                                           .value[index],
//                                                       isLiked: _likedPosts
//                                                               .value[index]
//                                                               .like!
//                                                               .isNotEmpty
//                                                           ? true
//                                                           : false,
//                                                       isVoted: _likedPosts
//                                                               .value[index]
//                                                               .vote!
//                                                               .isNotEmpty
//                                                           ? true
//                                                           : false,
//                                                       voteType: _likedPosts
//                                                               .value[index]
//                                                               .vote!
//                                                               .isNotEmpty
//                                                           ? _likedPosts
//                                                               .value[index]
//                                                               .vote![0]
//                                                               .voteType
//                                                           : null,
//                                                       onMessage: () {
//                                                         // reachDM.value = true;
//
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals.userBloc!.add(
//                                                               GetRecipientProfileEvent(
//                                                                   email: _likedPosts
//                                                                       .value[
//                                                                           index]
//                                                                       .postOwnerId!));
//                                                         }
//                                                       },
//                                                       onUpvote: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals
//                                                               .socialServiceBloc!
//                                                               .add(
//                                                                   VotePostEvent(
//                                                             voteType: 'Upvote',
//                                                             postId: _likedPosts
//                                                                 .value[index]
//                                                                 .postId,
//                                                           ));
//                                                         }
//                                                       },
//                                                       onDownvote: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals
//                                                               .socialServiceBloc!
//                                                               .add(
//                                                                   VotePostEvent(
//                                                             voteType:
//                                                                 'Downvote',
//                                                             postId: _likedPosts
//                                                                 .value[index]
//                                                                 .postId,
//                                                           ));
//                                                         }
//                                                       },
//                                                       onLike: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           if (_likedPosts
//                                                               .value[index]
//                                                               .like!
//                                                               .isNotEmpty) {
//                                                             globals
//                                                                 .socialServiceBloc!
//                                                                 .add(
//                                                                     UnlikePostEvent(
//                                                               postId:
//                                                                   _likedPosts
//                                                                       .value[
//                                                                           index]
//                                                                       .postId,
//                                                             ));
//                                                           } else {
//                                                             globals
//                                                                 .socialServiceBloc!
//                                                                 .add(
//                                                               LikePostEvent(
//                                                                   postId: _likedPosts
//                                                                       .value[
//                                                                           index]
//                                                                       .postId),
//                                                             );
//                                                           }
//                                                         }
//                                                       },
//                                                     );
//                                                   },
//                                                 ),
//                                         ),
//                                       //SHOUTOUTS TAB
//                                       if (timelineLoading)
//                                         const CircularLoader()
//                                       else
//                                         Refresher(
//                                           controller:
//                                               _shoutoutRefreshController,
//                                           onRefresh: () {
//                                             globals.socialServiceBloc!.add(
//                                                 GetVotedPostsEvent(
//                                                     pageLimit: 50,
//                                                     pageNumber: 1,
//                                                     voteType: 'Upvote',
//                                                     authId:
//                                                         widget.recipientId));
//                                           },
//                                           child: _shoutOuts.value.isEmpty
//                                               ? ListView(
//                                                   padding: EdgeInsets.zero,
//                                                   shrinkWrap: true,
//                                                   children: const [
//                                                     EmptyTabWidget(
//                                                         title:
//                                                             "Posts you've shouted out and your posts that has been shouted out",
//                                                         subtitle:
//                                                             "See posts you've shouted out and your post that has been shouted out")
//                                                   ],
//                                                 )
//                                               : ListView.builder(
//                                                   itemCount:
//                                                       _shoutOuts.value.length,
//                                                   itemBuilder:
//                                                       (context, index) {
//                                                     return PostFeedReacherCard(
//                                                       likingPost: false,
//                                                       postFeedModel: _shoutOuts
//                                                           .value[index],
//                                                       isLiked: _shoutOuts
//                                                               .value[index]
//                                                               .like!
//                                                               .isNotEmpty
//                                                           ? true
//                                                           : false,
//                                                       isVoted: _shoutOuts
//                                                               .value[index]
//                                                               .vote!
//                                                               .isNotEmpty
//                                                           ? true
//                                                           : false,
//                                                       voteType: _shoutOuts
//                                                               .value[index]
//                                                               .vote!
//                                                               .isNotEmpty
//                                                           ? _shoutOuts
//                                                               .value[index]
//                                                               .vote![0]
//                                                               .voteType
//                                                           : null,
//                                                       onMessage: () {
//                                                         reachDM.value = true;
//
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals.userBloc!.add(
//                                                               GetRecipientProfileEvent(
//                                                                   email: _shoutOuts
//                                                                       .value[
//                                                                           index]
//                                                                       .postOwnerId!));
//                                                         }
//                                                       },
//                                                       onUpvote: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals
//                                                               .socialServiceBloc!
//                                                               .add(
//                                                                   VotePostEvent(
//                                                             voteType: 'Upvote',
//                                                             postId: _shoutOuts
//                                                                 .value[index]
//                                                                 .postId,
//                                                           ));
//                                                         }
//                                                       },
//                                                       onDownvote: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals
//                                                               .socialServiceBloc!
//                                                               .add(
//                                                                   VotePostEvent(
//                                                             voteType:
//                                                                 'Downvote',
//                                                             postId: _shoutOuts
//                                                                 .value[index]
//                                                                 .postId,
//                                                           ));
//                                                         }
//                                                       },
//                                                       onLike: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           if (_shoutOuts
//                                                               .value[index]
//                                                               .like!
//                                                               .isNotEmpty) {
//                                                             globals
//                                                                 .socialServiceBloc!
//                                                                 .add(
//                                                                     UnlikePostEvent(
//                                                               postId: _shoutOuts
//                                                                   .value[index]
//                                                                   .postId,
//                                                             ));
//                                                           } else {
//                                                             globals
//                                                                 .socialServiceBloc!
//                                                                 .add(
//                                                               LikePostEvent(
//                                                                   postId: _shoutOuts
//                                                                       .value[
//                                                                           index]
//                                                                       .postId),
//                                                             );
//                                                           }
//                                                         }
//                                                       },
//                                                     );
//                                                   },
//                                                 ),
//                                         ),
//
//                                       //SHOUTDOWN TAB
//                                       if (timelineLoading)
//                                         const CircularLoader()
//                                       else
//                                         Refresher(
//                                           controller:
//                                               _shoutdownRefreshController,
//                                           onRefresh: () {
//                                             globals.socialServiceBloc!.add(
//                                                 GetVotedPostsEvent(
//                                                     pageLimit: 50,
//                                                     pageNumber: 1,
//                                                     voteType: 'Downvote',
//                                                     authId:
//                                                         widget.recipientId));
//                                           },
//                                           child: _shoutDowns.value.isEmpty
//                                               ? ListView(
//                                                   padding: EdgeInsets.zero,
//                                                   shrinkWrap: true,
//                                                   children: const [
//                                                     EmptyTabWidget(
//                                                         title:
//                                                             "Posts you've shouted down and your posts that has been shouted down",
//                                                         subtitle:
//                                                             "See posts you've shouted down and your post that has been shouted down")
//                                                   ],
//                                                 )
//                                               : ListView.builder(
//                                                   itemCount:
//                                                       _shoutDowns.value.length,
//                                                   itemBuilder:
//                                                       (context, index) {
//                                                     return PostFeedReacherCard(
//                                                       likingPost: false,
//                                                       postFeedModel: _shoutDowns
//                                                           .value[index],
//                                                       isLiked: _shoutDowns
//                                                               .value[index]
//                                                               .like!
//                                                               .isNotEmpty
//                                                           ? true
//                                                           : false,
//                                                       isVoted: _shoutDowns
//                                                               .value[index]
//                                                               .vote!
//                                                               .isNotEmpty
//                                                           ? true
//                                                           : false,
//                                                       voteType: _shoutDowns
//                                                               .value[index]
//                                                               .vote!
//                                                               .isNotEmpty
//                                                           ? _shoutDowns
//                                                               .value[index]
//                                                               .vote![0]
//                                                               .voteType
//                                                           : null,
//                                                       onMessage: () {
//                                                         reachDM.value = true;
//
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals.userBloc!.add(
//                                                               GetRecipientProfileEvent(
//                                                                   email: _shoutDowns
//                                                                       .value[
//                                                                           index]
//                                                                       .postOwnerId!));
//                                                         }
//                                                       },
//                                                       onUpvote: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals
//                                                               .socialServiceBloc!
//                                                               .add(
//                                                                   VotePostEvent(
//                                                             voteType: 'Upvote',
//                                                             postId: _shoutDowns
//                                                                 .value[index]
//                                                                 .postId,
//                                                           ));
//                                                         }
//                                                       },
//                                                       onDownvote: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           globals
//                                                               .socialServiceBloc!
//                                                               .add(
//                                                                   VotePostEvent(
//                                                             voteType:
//                                                                 'Downvote',
//                                                             postId: _shoutDowns
//                                                                 .value[index]
//                                                                 .postId,
//                                                           ));
//                                                         }
//                                                       },
//                                                       onLike: () {
//                                                         handleTap(index);
//                                                         if (active
//                                                             .contains(index)) {
//                                                           if (_shoutDowns
//                                                               .value[index]
//                                                               .like!
//                                                               .isNotEmpty) {
//                                                             globals
//                                                                 .socialServiceBloc!
//                                                                 .add(
//                                                                     UnlikePostEvent(
//                                                               postId:
//                                                                   _shoutDowns
//                                                                       .value[
//                                                                           index]
//                                                                       .postId,
//                                                             ));
//                                                           } else {
//                                                             globals
//                                                                 .socialServiceBloc!
//                                                                 .add(
//                                                               LikePostEvent(
//                                                                   postId: _shoutDowns
//                                                                       .value[
//                                                                           index]
//                                                                       .postId),
//                                                             );
//                                                           }
//                                                         }
//                                                       },
//                                                     );
//                                                   },
//                                                 ),
//                                         ),
//
//                                       // QUOTE TAB
//                                       if (timelineLoading)
//                                         const CircularLoader()
//                                       else
//                                         Refresher(
//                                           controller: _shareRefreshController,
//                                           onRefresh: () {
//                                             globals.socialServiceBloc!.add(
//                                                 GetAllPostsEvent(
//                                                     pageLimit: 50,
//                                                     pageNumber: 1,
//                                                     authId:
//                                                         widget.recipientId));
//                                           },
//                                           child: _posts.value.isEmpty
//                                               ? ListView(
//                                                   padding: EdgeInsets.zero,
//                                                   shrinkWrap: true,
//                                                   children: const [
//                                                     EmptyTabWidget(
//                                                       title:
//                                                           "Quotes you???ve made",
//                                                       subtitle:
//                                                           "Find all quoted posts you???ve made here ",
//                                                     )
//                                                   ],
//                                                 )
//                                               : ListView.builder(
//                                                   itemCount:
//                                                       _posts.value.length,
//                                                   itemBuilder:
//                                                       (context, index) {
//                                                     if (_posts.value[index]
//                                                             .repostedPost !=
//                                                         null) {
//                                                       return _ReacherCard(
//                                                         postModel:
//                                                             _posts.value[index],
//                                                         // onLike: () {
//                                                         //   _likePost(index);
//                                                         // },
//                                                       );
//                                                     } else {
//                                                       if (index ==
//                                                           ((_posts.value
//                                                                   .length) -
//                                                               1)) {
//                                                         return const EmptyTabWidget(
//                                                           title:
//                                                               "Quotes you???ve made",
//                                                           subtitle:
//                                                               "Find all quoted posts you???ve made here ",
//                                                         );
//                                                       } else {
//                                                         return const SizedBox
//                                                             .shrink();
//                                                       }
//                                                     }
//                                                   },
//                                                 ),
//                                         ),
//
//                                       //SAVED POSTS TAB
//                                       if (_isLoadingSavedPosts)
//                                         const CircularLoader()
//                                       else
//                                         Refresher(
//                                             controller:
//                                                 _savedPostsRefreshController,
//                                             onRefresh: () {
//                                               globals.socialServiceBloc!.add(
//                                                   GetAllSavedPostsEvent(
//                                                       pageLimit: 50,
//                                                       pageNumber: 1));
//                                             },
//                                             child: ListView(
//                                               padding: EdgeInsets.zero,
//                                               shrinkWrap: true,
//                                               children: const [
//                                                 EmptyTabWidget(
//                                                   title: "No saved posts",
//                                                   subtitle: "",
//                                                 )
//                                               ],
//                                             ))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
