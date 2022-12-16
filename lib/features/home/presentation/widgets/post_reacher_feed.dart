// import 'package:expandable_text/expandable_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../../../../core/components/snackbar.dart';
// import '../../../../core/services/navigation/navigation_service.dart';
// import '../../../../core/utils/app_globals.dart';
// import '../../../../core/utils/constants.dart';
// import '../../../../core/utils/dimensions.dart';
// import '../../../account/presentation/views/account.dart';
// import '../../../account/presentation/widgets/bottom_sheets.dart';
// import '../../data/models/post_model.dart';
// import 'dart:ui' as ui;
//
// import '../bloc/user-bloc/user_bloc.dart';
// import '../views/full_post.dart';
//
// class PostFeedReacherCard extends HookWidget {
//   const PostFeedReacherCard({
//     Key? key,
//     required this.postFeedModel,
//     required this.likingPost,
//     this.onDownvote,
//     this.onLike,
//     this.onMessage,
//     this.onUpvote,
//     this.onViewProfile,
//     this.voterProfile,
//     required this.isVoted,
//     required this.voteType,
//     required this.isLiked,
//   }) : super(key: key);
//
//   final PostFeedModel? postFeedModel;
//   final bool likingPost;
//   final Function()? onLike, onMessage, onUpvote, onDownvote, onViewProfile;
//   final bool isLiked, isVoted;
//   final String? voteType;
//   final PostProfileModel? voterProfile;
//
//   @override
//   Widget build(BuildContext context) {
//     final postDuration = timeago.format(postFeedModel!.post!.createdAt!);
//     var scr = GlobalKey();
//
//     Future<String> saveImage(Uint8List? bytes) async {
//       await [Permission.storage].request();
//       String time = DateTime.now().microsecondsSinceEpoch.toString();
//       final name = 'screenshot_${time}_reachme';
//       final result = await ImageGallerySaver.saveImage(bytes!, name: name);
//       debugPrint("Result ${result['filePath']}");
//       Snackbars.success(context, message: 'Image saved to Gallery');
//       RouteNavigators.pop(context);
//       return result['filePath'];
//     }
//
//     final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
//     void takeScreenShot() async {
//       RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()
//       as RenderRepaintBoundary; // the key provided
//       ui.Image image = await boundary.toImage();
//       ByteData? byteData =
//       await image.toByteData(format: ui.ImageByteFormat.png);
//       debugPrint("Byte Data: $byteData");
//       await saveImage(byteData!.buffer.asUint8List());
//     }
//
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: EdgeInsets.only(
//         right: getScreenWidth(16),
//         left: getScreenWidth(16),
//         bottom: getScreenHeight(16),
//       ),
//       child: RepaintBoundary(
//         key: scr,
//         child: Container(
//           width: size.width,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Visibility(
//                 visible: voterProfile != null,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//                       child: RichText(
//                         text: TextSpan(
//                             text:
//                             '@${voterProfile?.authId != globals.userId ? voterProfile?.username?.appendOverflow(15) : 'You'}',
//                             style: const TextStyle(
//                                 color: AppColors.black,
//                                 fontFamily: 'Poppins',
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500),
//                             children: const [
//                               TextSpan(
//                                   text: ' shouted out this reach',
//                                   style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       color: AppColors.grey,
//                                       fontWeight: FontWeight.w500))
//                             ]),
//                       ),
//                     ),
//                     SizedBox(
//                       height: getScreenHeight(8),
//                     ),
//                     const Divider(
//                       height: 1,
//                       thickness: 1,
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: CupertinoButton(
//                       minSize: 0,
//                       padding: EdgeInsets.zero,
//                       onPressed: () {
//                         if (onViewProfile != null) {
//                           onViewProfile!();
//                         } else {
//                           final progress = ProgressHUD.of(context);
//                           progress?.showWithText('Viewing Reacher...');
//                           Future.delayed(const Duration(seconds: 3), () {
//                             globals.userBloc!.add(GetRecipientProfileEvent(
//                                 email: postFeedModel!.postOwnerId));
//                             postFeedModel!.postOwnerId == globals.user!.id
//                                 ? RouteNavigators.route(
//                                 context, const AccountScreen())
//                                 : RouteNavigators.route(
//                                 context,
//                                 RecipientAccountProfile(
//                                   recipientEmail: 'email',
//                                   recipientImageUrl:
//                                   postFeedModel!.profilePicture,
//                                   recipientId: postFeedModel!.postOwnerId,
//                                 ));
//                             progress?.dismiss();
//                           });
//                         }
//                       },
//                       child: Row(
//                         children: [
//                           Helper.renderProfilePicture(
//                             postFeedModel!.profilePicture,
//                             size: 33,
//                           ).paddingOnly(l: 13, t: 10),
//                           SizedBox(width: getScreenWidth(9)),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     '@${postFeedModel!.username ?? ''}',
//                                     style: TextStyle(
//                                       fontSize: getScreenHeight(14),
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.textColor2,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 3),
//                                   postFeedModel!.verified ?? false
//                                       ? SvgPicture.asset(
//                                       'assets/svgs/verified.svg')
//                                       : const SizedBox.shrink()
//                                 ],
//                               ),
//                               GestureDetector(
//                                 onTap: () => Navigator.of(context)
//                                     .push(MaterialPageRoute(
//                                     builder: (builder) => FullPostScreen(
//                                       postFeedModel: postFeedModel,
//                                     ))),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       postFeedModel!.post!.location! == 'nil' ||
//                                           postFeedModel!.post!.location! ==
//                                               'NIL' ||
//                                           postFeedModel!.post!.location ==
//                                               null
//                                           ? ''
//                                           : postFeedModel!
//                                           .post!.location!.length >
//                                           23
//                                           ? postFeedModel!.post!.location!
//                                           .substring(0, 23)
//                                           : postFeedModel!.post!.location!,
//                                       style: TextStyle(
//                                         fontSize: getScreenHeight(10),
//                                         fontFamily: 'Poppins',
//                                         letterSpacing: 0.4,
//                                         fontWeight: FontWeight.w400,
//                                         color: AppColors.textColor2,
//                                       ),
//                                     ),
//                                     Text(
//                                       postDuration,
//                                       style: TextStyle(
//                                         fontSize: getScreenHeight(10),
//                                         fontFamily: 'Poppins',
//                                         letterSpacing: 0.4,
//                                         fontWeight: FontWeight.w400,
//                                         color: AppColors.textColor2,
//                                       ),
//                                     ).paddingOnly(left: 6),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ).paddingOnly(left: 10),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //  SvgPicture.asset('assets/svgs/starred.svg'),
//                       SizedBox(width: getScreenWidth(9)),
//                       IconButton(
//                         onPressed: () async {
//                           await showReacherCardBottomSheet(
//                             context,
//                             downloadPost: takeScreenShot,
//                             postFeedModel: postFeedModel!,
//                           );
//                         },
//                         iconSize: getScreenHeight(19),
//                         padding: const EdgeInsets.all(0),
//                         icon: SvgPicture.asset('assets/svgs/kebab card.svg'),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               postFeedModel!.post!.content == null
//                   ? const SizedBox.shrink()
//                   : ExpandableText(
//                 "${postFeedModel!.post!.content}",
//                 prefixText: postFeedModel!.post!.edited!
//                     ? "(Reach Edited)"
//                     : null,
//                 prefixStyle: TextStyle(
//                     fontSize: getScreenHeight(12),
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.primaryColor),
//                 onPrefixTap: () {
//                   tooltipkey.currentState?.ensureTooltipVisible();
//                 },
//                 expandText: 'see more',
//                 maxLines: 2,
//                 linkColor: Colors.blue,
//                 animation: true,
//                 expanded: false,
//                 collapseText: 'see less',
//                 onHashtagTap: (value) {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return DictionaryDialog(
//                           abbr: value,
//                           meaning: '',
//                           word: '',
//                         );
//                       });
//                 },
//                 onMentionTap: (value) {},
//                 mentionStyle: const TextStyle(
//                     decoration: TextDecoration.underline,
//                     color: Colors.blue),
//                 hashtagStyle: const TextStyle(
//                     decoration: TextDecoration.underline,
//                     color: Colors.blue),
//               ).paddingSymmetric(h: 16, v: 10),
//               Tooltip(
//                 key: tooltipkey,
//                 triggerMode: TooltipTriggerMode.manual,
//                 showDuration: const Duration(seconds: 1),
//                 message: 'This reach has been edited',
//               ),
//               if ((postFeedModel?.post?.imageMediaItems ?? []).isNotEmpty ||
//                   (postFeedModel?.post?.videoMediaItem ?? '').isNotEmpty)
//                 PostMedia(post: postFeedModel!.post!)
//                     .paddingOnly(r: 16, l: 16, b: 16, t: 10)
//               else
//                 const SizedBox.shrink(),
//               (postFeedModel?.post?.audioMediaItem ?? '').isNotEmpty
//                   ? PostAudioMedia(path: postFeedModel!.post!.audioMediaItem!)
//                   .paddingOnly(l: 16, r: 16, b: 10, t: 0)
//                   : const SizedBox.shrink(),
//               (postFeedModel?.post?.repostedPost != null)
//                   ? RepostedPost(
//                 post: postFeedModel!.post!,
//               ).paddingOnly(l: 0, r: 0, b: 10, t: 0)
//                   : const SizedBox.shrink(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Flexible(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 11,
//                         vertical: 7,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: const Color(0xFFF5F5F5),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CupertinoButton(
//                             minSize: 0,
//                             onPressed: onLike,
//                             padding: EdgeInsets.zero,
//                             child: isLiked
//                                 ? SvgPicture.asset(
//                               'assets/svgs/like-active.svg',
//                               height: getScreenHeight(20),
//                               width: getScreenWidth(20),
//                             )
//                                 : SvgPicture.asset(
//                               'assets/svgs/like.svg',
//                               height: getScreenHeight(20),
//                               width: getScreenWidth(20),
//                             ),
//                           ),
//                           SizedBox(width: getScreenWidth(4)),
//                           FittedBox(
//                             child: Text(
//                               '${postFeedModel!.post!.nLikes}',
//                               style: TextStyle(
//                                 fontSize: getScreenHeight(12),
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.textColor3,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: getScreenWidth(15)),
//                           CupertinoButton(
//                             minSize: 0,
//                             onPressed: () {
//                               RouteNavigators.route(context,
//                                   ViewCommentsScreen(post: postFeedModel!));
//                             },
//                             padding: EdgeInsets.zero,
//                             child: SvgPicture.asset(
//                               'assets/svgs/comment.svg',
//                               height: getScreenHeight(20),
//                               width: getScreenWidth(20),
//                             ),
//                           ),
//                           SizedBox(width: getScreenWidth(4)),
//                           FittedBox(
//                             child: Text(
//                               '${postFeedModel!.post!.nComments}',
//                               style: TextStyle(
//                                 fontSize: getScreenHeight(12),
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.textColor3,
//                               ),
//                             ),
//                           ),
//                           if (postFeedModel!.postOwnerId != globals.userId)
//                             SizedBox(width: getScreenWidth(15)),
//                           if (postFeedModel!.postOwnerId != globals.userId)
//                             CupertinoButton(
//                               minSize: 0,
//                               onPressed: onMessage,
//                               padding: const EdgeInsets.all(0),
//                               child: SvgPicture.asset(
//                                 'assets/svgs/message.svg',
//                                 height: getScreenHeight(20),
//                                 width: getScreenWidth(20),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: getScreenWidth(20)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Flexible(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 11,
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: const Color(0xFFF5F5F5),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CupertinoButton(
//                                 minSize: 0,
//                                 onPressed: onUpvote,
//                                 padding: EdgeInsets.zero,
//                                 child: isVoted && voteType == 'Upvote'
//                                     ? SvgPicture.asset(
//                                   'assets/svgs/shoutup-active.svg',
//                                   height: getScreenHeight(20),
//                                   width: getScreenWidth(20),
//                                 )
//                                     : SvgPicture.asset(
//                                   'assets/svgs/shoutup.svg',
//                                   height: getScreenHeight(20),
//                                   width: getScreenWidth(20),
//                                 ),
//                               ),
//                               FittedBox(
//                                 child: Text(
//                                   '${postFeedModel!.post!.nUpvotes ?? 0}',
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(12),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.textColor3,
//                                   ),
//                                 ),
//                               ),
//                               Flexible(
//                                   child: SizedBox(width: getScreenWidth(4))),
//                               Flexible(
//                                   child: SizedBox(width: getScreenWidth(4))),
//                               CupertinoButton(
//                                 minSize: 0,
//                                 onPressed: onDownvote,
//                                 padding: EdgeInsets.zero,
//                                 child: isVoted && voteType == 'Downvote'
//                                     ? SvgPicture.asset(
//                                   'assets/svgs/shoutdown-active.svg',
//                                   height: getScreenHeight(20),
//                                   width: getScreenWidth(20),
//                                 )
//                                     : SvgPicture.asset(
//                                   'assets/svgs/shoutdown.svg',
//                                   height: getScreenHeight(20),
//                                   width: getScreenWidth(20),
//                                 ),
//                               ),
//                               FittedBox(
//                                 child: Text(
//                                   '${postFeedModel!.post!.nDownvotes ?? 0}',
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(12),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.textColor3,
//                                   ),
//                                 ),
//                               ),
//                               Flexible(
//                                   child: SizedBox(width: getScreenWidth(4))),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ).paddingOnly(b: 15, r: 16, l: 16, t: 5),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
