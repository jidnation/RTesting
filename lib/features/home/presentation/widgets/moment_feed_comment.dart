import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reach_me/features/home/presentation/widgets/user_comment_input_layout.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../momentControlRoom/control_room.dart';
import '../views/moment_feed.dart';
import 'moment_comment_box.dart';

class MomentFeedComment extends StatefulWidget {
  final MomentModel momentFeed;
  const MomentFeedComment({
    Key? key,
    required this.momentFeed,
  }) : super(key: key);

  @override
  State<MomentFeedComment> createState() => _MomentFeedCommentState();
}

class _MomentFeedCommentState extends State<MomentFeedComment> {
  @override
  void initState() {
    super.initState();
    momentFeedStore.getMomentComments(momentId: widget.momentFeed.momentId);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          Stack(children: [
            Container(
              height: SizeConfig.screenHeight - getScreenHeight(300),
              width: SizeConfig.screenWidth,
              color: const Color(0xffE6E6E6),
              child: Column(children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: getScreenHeight(100),
                  decoration: const BoxDecoration(
                      color: Color(0xff001824),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 68,
                          width: getScreenWidth(150),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                CustomText(
                                  text: 'Drag down to close',
                                  color: Colors.white,
                                  size: 13.28,
                                  weight: FontWeight.w500,
                                ),
                                // SizedBox(height: 3),
                                Icon(
                                  Icons.arrow_downward_sharp,
                                  color: Colors.white,
                                ),
                              ]),
                        )
                      ]),
                ),
                Expanded(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: const Color(0xffE6E6E6),
                    child: Column(children: [
                      const SizedBox(height: 20),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(30),
                                      image: widget.momentFeed.profilePicture
                                              .isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(widget
                                                  .momentFeed.profilePicture),
                                              fit: BoxFit.cover,
                                            )
                                          : null),
                                  child:
                                      widget.momentFeed.profilePicture.isEmpty
                                          ? Image.asset(
                                              "assets/images/app-logo.png")
                                          : null,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: widget
                                            .momentFeed.momentOwnerUserName,
                                        color: Colors.black,
                                        size: 16.28,
                                        weight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 1.5),
                                      CustomText(
                                        text: Helper.parseUserLastSeen(widget
                                            .momentFeed.momentCreatedTime),
                                        color: const Color(0xff252525)
                                            .withOpacity(0.5),
                                        size: 11.44,
                                        weight: FontWeight.w600,
                                      ),
                                    ])
                              ]),
                              const SizedBox(height: 10),
                              Visibility(
                                visible:
                                    widget.momentFeed.caption != 'No Caption',
                                child: CustomText(
                                  text: widget.momentFeed.caption,
                                  size: 13.28,
                                ),
                              )
                            ]),
                      ),
                      const SizedBox(height: 5),

                      //////////////////////////////////others
                      Expanded(
                          child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 70),
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          CustomMomentCommentModel commentData =
                              momentFeedStore.momentComments[index];
                          return MomentCommentBox(
                            momentFeed: widget.momentFeed,
                            commentInfo: commentData,
                          );
                        },
                        itemCount: momentFeedStore.momentComments.length,
                      ))
                    ]),
                  ),
                ),
              ]),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: UserCommentBox(momentFeed: widget.momentFeed),
            )
          ]),
          isScrollControlled: true,
        );
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SvgPicture.asset(
          'assets/svgs/comment.svg',
          color: Colors.white,
        ),
        const SizedBox(height: 5),
        CustomText(
          text:
              momentFeedStore.getCountValue(value: widget.momentFeed.nComment),
          weight: FontWeight.w500,
          color: Colors.white,
          size: 13.28,
        )
      ]),
    );
  }
}
