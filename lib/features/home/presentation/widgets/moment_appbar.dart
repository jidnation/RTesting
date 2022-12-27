import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../views/moment_feed.dart';
import '../views/status/widgets/user_posting.dart';

class MomentsAppBar extends StatelessWidget {
  final PageController pageController;
  const MomentsAppBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        color: Colors.black,
        height: 58,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0.0, 0.2),
                        blurRadius: 20,
                        color: AppColors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset('assets/svgs/back.svg',
                      color: Colors.white),
                ),
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(),
                onPressed: () {
                  pageController.jumpToPage(0);
                  // RouteNavigators.pop(context);
                },
              ),
              SizedBox(width: getScreenWidth(24)),
              Text(
                'Moments',
                style: TextStyle(
                    fontSize: getScreenHeight(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white),
              ),
            ],
          ),
          Row(children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0.0, 0.2),
                    blurRadius: 20,
                    color: AppColors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/fluent_live-24-regular.svg',
                ),
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(),
                onPressed: () async {
                  var cameras = await availableCameras();
                  Get.to(
                    () => UserPosting(
                      initialIndex: 2,
                      phoneCameras: cameras,
                    ),
                    transition: Transition.fadeIn,
                  );
                  momentFeedStore.currentVideoController.pause();
                },
              ),
            ),
            SizedBox(width: getScreenWidth(40)),
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0.0, 0.2),
                      blurRadius: 20,
                      color: AppColors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/svgs/Camera.svg',
                ),
              ),
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
              onPressed: () async {
                var cameras = await availableCameras();
                Get.to(
                  () => UserPosting(
                    initialIndex: 0,
                    phoneCameras: cameras,
                  ),
                  transition: Transition.fadeIn,
                );
                momentFeedStore.currentVideoController.pause();
              },
            ),
          ]),
        ]),
      ),
    ]);
  }
}
