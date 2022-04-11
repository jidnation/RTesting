import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/video-call/video_calling_screen.dart';
import 'package:reach_me/core/utils/constants.dart';

class VideoCallScreen extends StatelessWidget {
  static const String id = 'video_call';
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                RouteNavigators.route(context, const VideoCallingScreen());
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/video-call.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: size.width * 0.36,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  globals.user!.profilePicture == null
                      ? ImagePlaceholder(
                          width: getScreenWidth(100),
                          height: getScreenHeight(100),
                        )
                      : ProfilePicture(
                          width: getScreenWidth(100),
                          height: getScreenHeight(100),
                        ),
                  const Text('Bad Guy',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white)),
                  const SizedBox(height: 8),
                  const Text('Calling...',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 12,
        shape: const CircularNotchedRectangle(),
        child: Container(
            height: 100,
            decoration: const BoxDecoration(
              //   borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, Color(0xFF00CCD9)],
                stops: [0, 100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SizedBox(
                    height: 50,
                    width: 50,
                    child: SvgPicture.asset('assets/svgs/flip-camera.svg'),
                  ),
                ),
                SizedBox(
                  width: 65,
                  height: 65,
                  child: IconButton(
                    onPressed: () {},
                    icon: Container(
                      width: 65,
                      height: 65,
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                          color: Color(0xFFE91C43), shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        'assets/svgs/end-call.svg',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 44,
                  width: 44,
                  child: IconButton(
                    onPressed: () {},
                    icon: SizedBox(
                      height: 38,
                      width: 38,
                      child: SvgPicture.asset('assets/svgs/mute-call.svg'),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
