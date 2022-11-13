import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/utils/file_utils.dart';
import 'package:reach_me/features/home/presentation/widgets/video_preview.dart';

class AppGalleryView extends HookWidget {
  final List<String> mediaPaths;
  final int? initialPage;
  const AppGalleryView({Key? key, required this.mediaPaths, this.initialPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: initialPage ?? 0);
    return SafeArea(
      child: PageView.builder(
          itemCount: mediaPaths.length,
          scrollDirection: Axis.horizontal,
          pageSnapping: true,
          controller: pageController,
          itemBuilder: (context, index) {
            String path = mediaPaths[index];
            if (FileUtils.isImagePath(path)) {
              return PhotoView(
                  imageProvider: NetworkImage(path),
                  loadingBuilder: (context, event) => const Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                        ),
                      ));
            } else {
              return VideoPreview(
                path: path,
                isLocalVideo: false,
              );
            }
          }),
    );
  }
}
