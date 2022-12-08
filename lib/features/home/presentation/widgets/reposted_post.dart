import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/view_words_dialog.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class RepostedPost extends StatelessWidget {
  final PostModel post;
  const RepostedPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(post.repostedPost!.createdAt!);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
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
                  // final progress = ProgressHUD.of(context);
                  // progress
                  //     ?.showWithText('Viewing Reacher...');
                  // Future.delayed(const Duration(seconds: 3),
                  //         () {
                  //       globals.userBloc!.add(
                  //           GetRecipientProfileEvent(
                  //               email: widget
                  //                   .postFeedModel.postOwnerId));
                  //       widget.postFeedModel.postOwnerId ==
                  //           globals.user!.id
                  //           ? RouteNavigators.route(
                  //           context, const AccountScreen())
                  //           : RouteNavigators.route(
                  //           context,
                  //           RecipientAccountProfile(
                  //             recipientEmail: 'email',
                  //             recipientImageUrl: widget
                  //                 .postFeedModel
                  //                 .profilePicture,
                  //             recipientId: widget
                  //                 .postFeedModel.postOwnerId,
                  //           ));
                  //       progress?.dismiss();
                  //     });
                },
                child: Row(
                  children: [
                    Helper.renderProfilePicture(
                      post.repostedPostOwnerProfile?.profilePicture,
                      size: 40,
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
                              '@${post.repostedPostOwnerProfile?.username ?? ''}',
                              style: TextStyle(
                                fontSize: getScreenHeight(14),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor2,
                              ),
                            ),
                            const SizedBox(width: 3),
                            post.repostedPostOwnerProfile?.verified ?? false
                                ? SvgPicture.asset('assets/svgs/verified.svg')
                                : const SizedBox.shrink()
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              post.repostedPost!.location! == 'nil'
                                  ? ''
                                  : post.repostedPost!.location!,
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
          post.repostedPost!.content == null
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    Flexible(
                      child: ExpandableText(
                        "${post.repostedPost!.content}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: getScreenHeight(14)),
                        maxLines: 3,
                        animation: true,
                        collapseText: 'see less',
                        expandText: 'see more',
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
                      ),
                    ),
                    SizedBox(width: getScreenWidth(2)),
                    Tooltip(
                      message: 'This Reach has been edited by the Reacher',
                      waitDuration: const Duration(seconds: 1),
                      showDuration: const Duration(seconds: 2),
                      child: Text(
                        post.repostedPost!.edited! ? "(Reach Edited)" : "",
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
          if ((post.repostedPost?.imageMediaItems ?? []).isNotEmpty)
            Helper.renderPostImages(post.repostedPost!, context)
                .paddingOnly(r: 16, l: 16, b: 16, t: 10)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
