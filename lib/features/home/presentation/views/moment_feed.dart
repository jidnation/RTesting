import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../momentControlRoom/control_room.dart';
import '../../../momentControlRoom/models/get_moment_feed.dart';
import '../widgets/moment_appbar.dart';
import '../widgets/moment_videoplayer_item.dart';
import '../widgets/video_loader.dart';

class MomentFeed extends StatefulWidget {
  final PageController pageController;
  const MomentFeed({Key? key, required this.pageController}) : super(key: key);

  @override
  State<MomentFeed> createState() => _MomentFeedState();
}

final MomentFeedStore momentFeedStore = MomentFeedStore();

// const colors = [Colors.green, Colors.blue, Colors.red, Colors.yellow];

class _MomentFeedState extends State<MomentFeed> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff001824),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(children: [
            MomentsAppBar(
              pageController: widget.pageController,
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: MomentFeedStore(),
              builder: (context, List<GetMomentFeed> value, child) {
                print('from the feed room.........??? $value }');
                final List<GetMomentFeed> momentFeeds = value;
                return momentFeedStore.gettingMoments
                    ? const VideoLoader()
                    : CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: size.height,
                          scrollDirection: Axis.vertical,
                        ),
                        items: List<Widget>.generate(
                            momentFeedStore.momentCount,
                            (index) => Builder(builder: (context) {
                                  final GetMomentFeed getMomentFeed =
                                      value[index];
                                  return VideoPlayerItem(
                                      momentFeed: getMomentFeed);
                                })));
              },
            )),
          ]),
        ),
      ),
    );
  }
}
