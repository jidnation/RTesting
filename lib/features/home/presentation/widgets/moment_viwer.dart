import 'package:flutter/material.dart';

import '../../../momentControlRoom/models/get_moment_feed.dart';
import 'moment_videoplayer_item.dart';

class MomentViewer extends StatelessWidget {
  final GetMomentFeed momentFeed;
  const MomentViewer({
    Key? key, required this.momentFeed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      VideoPlayerItem(
        videoUrl: momentFeed.moment!.videoMediaItem!,
      ),
      Column(children: [
      ]),
    ]);
  }
}