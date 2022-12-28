import 'package:flutter/material.dart';
import 'package:reach_me/features/home/presentation/widgets/user_comment_input_layout.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../momentControlRoom/control_room.dart';
import 'moment_comment_box.dart';

class MomentCommentStation extends StatelessWidget {
  final MomentModel momentFeed;
  const MomentCommentStation({
    Key? key,
    required this.momentFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                                image: momentFeed.profilePicture.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            momentFeed.profilePicture),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                            child: momentFeed.profilePicture.isEmpty
                                ? Image.asset("assets/images/app-logo.png")
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: momentFeed.momentOwnerUserName,
                                  color: Colors.black,
                                  size: 16.28,
                                  weight: FontWeight.w600,
                                ),
                                const SizedBox(height: 1.5),
                                CustomText(
                                  text: Helper.parseUserLastSeen(
                                      momentFeed.momentCreatedTime),
                                  color:
                                      const Color(0xff252525).withOpacity(0.5),
                                  size: 11.44,
                                  weight: FontWeight.w600,
                                ),
                              ])
                        ]),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: momentFeed.caption != 'No Caption',
                          child: CustomText(
                            text: momentFeed.caption,
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
                    print(
                        '::::::::::::::::::::::::::::::::::::::::::::::::: are we updating ::::::::::::::::::::::::::::');
                    CustomMomentCommentModel commentData =
                        momentFeed.momentComments[index];
                    return MomentCommentBox(
                      momentFeed: momentFeed,
                      commentInfo: commentData,
                    );
                  },
                  itemCount: momentFeed.nComment,
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
        child: UserCommentBox(momentFeed: momentFeed),
      )
    ]);
  }
}

class MomentCommentStation2 extends StatelessWidget {
  final MomentModel momentFeed;
  const MomentCommentStation2({
    Key? key,
    required this.momentFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          color: const Color(0xffe6e6e6),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            Container(
              height: getScreenHeight(336),
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff001824),
              ),
            ),
            const SizedBox(height: 10),
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
                            image: momentFeed.profilePicture.isNotEmpty
                                ? DecorationImage(
                                    image:
                                        NetworkImage(momentFeed.profilePicture),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                        child: momentFeed.profilePicture.isEmpty
                            ? Image.asset("assets/images/app-logo.png")
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: momentFeed.momentOwnerUserName,
                              color: Colors.black,
                              size: 16.28,
                              weight: FontWeight.w600,
                            ),
                            const SizedBox(height: 1.5),
                            CustomText(
                              text: Helper.parseUserLastSeen(
                                  momentFeed.momentCreatedTime),
                              color: const Color(0xff252525).withOpacity(0.5),
                              size: 11.44,
                              weight: FontWeight.w600,
                            ),
                          ])
                    ]),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: momentFeed.caption != 'No Caption',
                      child: CustomText(
                        text: momentFeed.caption,
                        size: 13.28,
                      ),
                    )
                  ]),
            ),
            const SizedBox(height: 5),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 70),
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                print(
                    '::::::::::::::::::::::::::::::::::::::::::::::::: are we updating ::::::::::::::::::::::::::::');
                CustomMomentCommentModel commentData =
                    momentFeed.momentComments[index];
                return MomentCommentBox(
                  momentFeed: momentFeed,
                  commentInfo: commentData,
                );
              },
              itemCount: momentFeed.nComment,
            )),
          ]),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: UserCommentBox(momentFeed: momentFeed),
        )
      ]),
    ));

    //   Stack(children: [
    //   Container(
    //     height: SizeConfig.screenHeight,
    //     width: SizeConfig.screenWidth,
    //     color: const Color(0xffE6E6E6),
    //     child: Column(children: [
    //       Container(
    //         width: SizeConfig.screenWidth,
    //         height: getScreenHeight(100),
    //         decoration: const BoxDecoration(
    //             color: Color(0xff001824),
    //             borderRadius: BorderRadius.only(
    //               bottomRight: Radius.circular(20),
    //               bottomLeft: Radius.circular(20),
    //             )),
    //         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    //           Container(
    //             height: 68,
    //             width: getScreenWidth(150),
    //             alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               color: Colors.black.withOpacity(0.5),
    //               borderRadius: BorderRadius.circular(60),
    //             ),
    //             child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: const [
    //                   CustomText(
    //                     text: 'Drag down to close',
    //                     color: Colors.white,
    //                     size: 13.28,
    //                     weight: FontWeight.w500,
    //                   ),
    //                   // SizedBox(height: 3),
    //                   Icon(
    //                     Icons.arrow_downward_sharp,
    //                     color: Colors.white,
    //                   ),
    //                 ]),
    //           )
    //         ]),
    //       ),
    //       Expanded(
    //         child: Container(
    //           width: SizeConfig.screenWidth,
    //           padding: const EdgeInsets.symmetric(horizontal: 10),
    //           color: const Color(0xffE6E6E6),
    //           child: Column(children: [
    //             const SizedBox(height: 20),
    //             Container(
    //               width: SizeConfig.screenWidth,
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 12,
    //                 vertical: 5,
    //               ),
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(8),
    //                 color: Colors.white,
    //               ),
    //               child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Row(children: [
    //                       Container(
    //                         height: 50,
    //                         width: 50,
    //                         padding: const EdgeInsets.all(12),
    //                         decoration: BoxDecoration(
    //                             color: AppColors.primaryColor,
    //                             borderRadius: BorderRadius.circular(30),
    //                             image: momentFeed.profilePicture.isNotEmpty
    //                                 ? DecorationImage(
    //                                     image: NetworkImage(
    //                                         momentFeed.profilePicture),
    //                                     fit: BoxFit.cover,
    //                                   )
    //                                 : null),
    //                         child: momentFeed.profilePicture.isEmpty
    //                             ? Image.asset("assets/images/app-logo.png")
    //                             : null,
    //                       ),
    //                       const SizedBox(width: 10),
    //                       Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             CustomText(
    //                               text: momentFeed.momentOwnerUserName,
    //                               color: Colors.black,
    //                               size: 16.28,
    //                               weight: FontWeight.w600,
    //                             ),
    //                             const SizedBox(height: 1.5),
    //                             CustomText(
    //                               text: Helper.parseUserLastSeen(
    //                                   momentFeed.momentCreatedTime),
    //                               color:
    //                                   const Color(0xff252525).withOpacity(0.5),
    //                               size: 11.44,
    //                               weight: FontWeight.w600,
    //                             ),
    //                           ])
    //                     ]),
    //                     const SizedBox(height: 10),
    //                     Visibility(
    //                       visible: momentFeed.caption != 'No Caption',
    //                       child: CustomText(
    //                         text: momentFeed.caption,
    //                         size: 13.28,
    //                       ),
    //                     )
    //                   ]),
    //             ),
    //             const SizedBox(height: 5),
    //
    //             //////////////////////////////////others
    //             Expanded(
    //                 child: ListView.builder(
    //               shrinkWrap: true,
    //               padding: const EdgeInsets.only(bottom: 70),
    //               physics: const ScrollPhysics(),
    //               itemBuilder: (context, index) {
    //                 print(
    //                     '::::::::::::::::::::::::::::::::::::::::::::::::: are we updating ::::::::::::::::::::::::::::');
    //                 CustomMomentCommentModel commentData =
    //                     momentFeed.momentComments[index];
    //                 return MomentCommentBox(
    //                   momentFeed: momentFeed,
    //                   commentInfo: commentData,
    //                 );
    //               },
    //               itemCount: momentFeed.nComment,
    //             ))
    //           ]),
    //         ),
    //       ),
    //     ]),
    //   ),
    //   Positioned(
    //     bottom: 0,
    //     left: 0,
    //     right: 0,
    //     child: UserCommentBox(momentFeed: momentFeed),
    //   )
    // ]);
  }
}
