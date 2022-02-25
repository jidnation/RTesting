import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/utils/constants.dart';

class VideoCallingScreen extends StatelessWidget {
  static const String id = 'video_calling';
  const VideoCallingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/video-call-1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                height: 150,
                width: 130,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/video-call.png'),
                    fit: BoxFit.cover,
                  ),
                ),
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
