import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/models/file_result.dart';
import 'package:reach_me/core/services/media_service.dart';
import 'package:reach_me/core/utils/file_utils.dart';
import 'package:reach_me/features/home/presentation/widgets/gallery_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/string_util.dart';
import '../../data/models/post_model.dart';

class PostMedia extends StatelessWidget {
  final PostModel post;
  const PostMedia({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imageVideoList = [];
    int nImages = (post.imageMediaItems ?? []).length;
    bool hasVideo = (post.videoMediaItem ?? '').isNotEmpty;
    bool hasAudio = (post.audioMediaItem ?? '').isNotEmpty;
    if (nImages > 0) imageVideoList.addAll(post.imageMediaItems ?? []);
    if (hasVideo) imageVideoList.add(post.videoMediaItem ?? '');
    int imageVideoTotal = imageVideoList.length;
    if (imageVideoTotal == 1) {
      debugPrint("Post Rating: ${post.postRating}");
      return FileUtils.isImagePath(imageVideoList.first)
          ? PostImageMedia(
              imageUrl: imageVideoList.first,
              allMediaUrls: imageVideoList,
              postModel: post,
              index: 0,
            )
          : PostVideoMedia(
              url: imageVideoList.first,
              allMediaUrls: imageVideoList,
              index: 0,
            );
    } else if (imageVideoTotal == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: PostImageMedia(
            postModel: post,
            imageUrl: imageVideoList[0],
            allMediaUrls: imageVideoList,
            index: 0,
          )),
          SizedBox(width: getScreenWidth(5)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PostImageMedia(
                  postModel: post,
                  imageUrl: imageVideoList[1],
                  height: 150,
                  allMediaUrls: imageVideoList,
                  index: 1,
                ),
                SizedBox(height: getScreenHeight(5)),
                FileUtils.isImagePath(imageVideoList[2])
                    ? PostImageMedia(
                        postModel: post,
                        imageUrl: imageVideoList[2],
                        height: 150,
                        allMediaUrls: imageVideoList,
                        index: 2,
                      )
                    : PostVideoMedia(
                        url: imageVideoList[2],
                        height: 150,
                        allMediaUrls: imageVideoList,
                        index: 2,
                      )
              ],
            ),
          )
        ],
      );
    } else if (imageVideoTotal > 4) {
      int remMedia = imageVideoTotal - 4;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PostImageMedia(
                  postModel: post,
                  imageUrl: imageVideoList[0],
                  height: 150,
                  allMediaUrls: imageVideoList,
                  index: 0,
                ),
                SizedBox(height: getScreenHeight(5)),
                PostImageMedia(
                  postModel: post,
                  index: 1,
                  imageUrl: imageVideoList[1],
                  height: 150,
                  allMediaUrls: imageVideoList,
                )
              ],
            ),
          ),
          SizedBox(width: getScreenWidth(5)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PostImageMedia(
                  postModel: post,
                  index: 2,
                  imageUrl: imageVideoList[2],
                  height: 150,
                  allMediaUrls: imageVideoList,
                ),
                SizedBox(height: getScreenHeight(5)),
                GestureDetector(
                  onTap: () => RouteNavigators.route(
                      context,
                      AppGalleryView(
                        mediaPaths: imageVideoList,
                        initialPage: 3,
                      )),
                  child: MediaWithCounter(
                    count: remMedia,
                    child: PostImageMedia(
                      postModel: post,
                      imageUrl: imageVideoList[3],
                      height: 150,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    } else {
      // return const Text('media display under construction');
      return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 178 / 164,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          shrinkWrap: true,
          itemCount: imageVideoList.length,
          itemBuilder: (context, index) {
            String path = imageVideoList[index];
            return Container(
              height: getScreenHeight(300),
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: FileUtils.isImagePath(path)
                  ? PostImageMedia(
                      postModel: post,
                      imageUrl: path,
                      allMediaUrls: imageVideoList,
                      index: index,
                    )
                  : PostVideoMedia(
                      url: path,
                      scaleIcon: 0.7,
                      allMediaUrls: imageVideoList,
                      index: index,
                    ),
            );
          });
    }
  }
}

class MediaWithCounter extends StatelessWidget {
  final Widget child;
  final int count;
  final double? left, right, width, height;
  const MediaWithCounter(
      {Key? key,
      required this.child,
      required this.count,
      this.left,
      this.right,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          right: right,
          left: left,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.black38),
            child: Text(
              "+$count",
              style: TextStyle(
                  fontSize: getScreenHeight(28),
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

class PostImageMedia extends StatefulWidget {
  final String imageUrl;
  final List<String>? allMediaUrls;
  final int? index;
  final double? height, width;
  final PostModel? postModel;

  const PostImageMedia(
      {Key? key,
      required this.imageUrl,
      this.height,
      this.width,
      this.allMediaUrls,
      this.postModel,
      this.index})
      : super(key: key);

  @override
  State<PostImageMedia> createState() => _PostImageMediaState();
}

class _PostImageMediaState extends State<PostImageMedia> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    // debugPrint("Post Rating ${widget.postModel!.postRating}");
    if (widget.postModel!.postRating == "sensitive") {
      if (show == true) {
        return GestureDetector(
          onTap: widget.allMediaUrls == null
              ? null
              : (() => RouteNavigators.route(
                  context,
                  AppGalleryView(
                    mediaPaths: widget.allMediaUrls!,
                    initialPage: widget.index,
                  ))),
          child: Container(
            height: getScreenHeight(widget.height ?? 300),
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Container(
                height: getScreenHeight(widget.height ?? 300),
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  child: Container(
                alignment: Alignment.center,
                height: getScreenHeight(50),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: getScreenWidth(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.disabled),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "This is a  sensitive content",
                      style: TextStyle(
                          fontSize: getScreenHeight(18),
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            show = true;
                          });
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text("Show",
                                style: TextStyle(
                                    fontSize: getScreenHeight(16),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        );
      }
    } else {
      return GestureDetector(
        onTap: widget.allMediaUrls == null
            ? null
            : (() => RouteNavigators.route(
                context,
                AppGalleryView(
                  mediaPaths: widget.allMediaUrls!,
                  initialPage: widget.index,
                ))),
        child: Container(
          height: getScreenHeight(widget.height ?? 300),
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}

// class PostVideoMedia extends HookWidget {
//   final String url;
//   final List<String>? allMediaUrls;
//   final int? index;
//   final double? scaleIcon, height, width;
//   const PostVideoMedia({
//     Key? key,
//     required this.url,
//     this.index,
//     this.allMediaUrls,
//     this.scaleIcon,
//     this.height,
//     this.width,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final thumbnail = useState<FileResult?>(null);
//
//     useAsyncEffect(() async {
//       final res = await MediaService().getVideoThumbnail(videoPath: url);
//       thumbnail.value = res;
//       return null;
//     }, []);
//
//     return Stack(
//       alignment: Alignment.topRight,
//       children: [
//         Container(
//             width: double.infinity,
//             height: getScreenHeight(height ?? 300),
//             clipBehavior: Clip.hardEdge,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: thumbnail.value == null
//                 ? Container(
//                     color: AppColors.black,
//                   )
//                 : Image.file(
//                     File(thumbnail.value!.path),
//                     fit: BoxFit.cover,
//                   )),
//         Positioned.fill(
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.black.withAlpha(50),
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//         ),
//         Positioned.fill(
//           child: Container(
//             decoration: const BoxDecoration(),
//             child: Icon(
//               Icons.play_arrow_rounded,
//               color: AppColors.white,
//               size: scaleIcon == null ? 64 : (scaleIcon! * 64),
//             ),
//           ),
//         ),
//         allMediaUrls != null
//             ? Positioned.fill(child: GestureDetector(onTap: () {
//                 RouteNavigators.route(
//                     context,
//                     AppGalleryView(
//                       mediaPaths: allMediaUrls!,
//                       initialPage: index,
//                     ));
//               }))
//             : Container(),
//       ],
//     );
//   }
//
//   void useAsyncEffect(Future<Dispose?> Function() effect,
//       [List<Object?>? keys]) {
//     useEffect(() {
//       final disposeFuture = Future.microtask(effect);
//       return () => disposeFuture.then((dispose) => dispose?.call());
//     }, keys);
//   }
// }
class PostVideoMedia extends StatefulWidget {
  final String url;
  final List<String>? allMediaUrls;
  final int? index;
  final double? scaleIcon, height, width;
  const PostVideoMedia({
    Key? key,
    required this.url,
    this.index,
    this.allMediaUrls,
    this.scaleIcon,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<PostVideoMedia> createState() => _PostVideoMediaState();
}

class _PostVideoMediaState extends State<PostVideoMedia> {
  FileResult? thumbnail;
  final MediaService _mediaService = MediaService();

  @override
  void initState() {
    super.initState();
  }

  getThumbnail() async {
    final res = await _mediaService.getVideoThumbnail(videoPath: widget.url);
    thumbnail = res;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.3 && thumbnail == null) {
          getThumbnail();
        }
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
              width: double.infinity,
              height: getScreenHeight(widget.height ?? 300),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: thumbnail == null
                  ? Container(
                      color: AppColors.black,
                    )
                  : Image.file(
                      File(thumbnail!.path),
                      fit: BoxFit.cover,
                    )),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Visibility(
            child: Positioned.fill(
              child: thumbnail == null
                  ? Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : Container(
                      decoration: const BoxDecoration(),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.white,
                        size: widget.scaleIcon == null
                            ? 64
                            : (widget.scaleIcon! * 64),
                      ),
                    ),
            ),
          ),
          widget.allMediaUrls != null
              ? Positioned.fill(child: GestureDetector(onTap: () {
                  RouteNavigators.route(
                      context,
                      AppGalleryView(
                        mediaPaths: widget.allMediaUrls!,
                        initialPage: widget.index,
                      ));
                }))
              : Container(),
        ],
      ),
    );
  }
}

class PostAudioMedia extends StatefulWidget {
  final String path;
  final EdgeInsets? margin, padding;
  const PostAudioMedia(
      {Key? key, required this.path, this.margin, this.padding})
      : super(key: key);

  @override
  State<PostAudioMedia> createState() => _PostAudioMediaState();
}

class _PostAudioMediaState extends State<PostAudioMedia> {
  PlayerController? playerController;
  bool isInitialised = false;
  bool isPlaying = false;
  final currentDurationStream = StreamController<int>();
  int currentDuration = 0;
  final MediaService _mediaService = MediaService();
  @override
  void initState() {
    super.initState();
    if (mounted) initPlayer();
  }

  Future<void> initPlayer() async {
    final res = await _mediaService.downloadFile(url: widget.path);
    if (res == null) return;
    playerController = PlayerController();
    // if(playerController == null) return;
    playerController!.onCurrentDurationChanged.listen((event) {
      currentDuration = event;
      if (mounted) setState(() {});
      // Console.log('<<AUDIO-DURATION>>', event.toString());
    });
    playerController!.addListener(() {
      Console.log('<<AUDIO-LISTENER>>', playerController!.playerState.name);
      if (playerController!.playerState == PlayerState.initialized) {
        isInitialised = true;
        if (mounted) setState(() {});
      } else if (playerController!.playerState == PlayerState.playing) {
        isPlaying = true;
        if (mounted) setState(() {});
      } else if (playerController!.playerState == PlayerState.paused ||
          playerController!.playerState == PlayerState.stopped) {
        isPlaying = false;
        if (mounted) setState(() {});
      }
    });
    await playerController!.preparePlayer(res.path);
    // await playerController.startPlayer();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: getScreenHeight(36),
      decoration: const BoxDecoration(
          color: AppColors.audioPlayerBg,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (playerController == null) return;
              if (isPlaying) {
                playerController!.pausePlayer();
              } else {
                playerController!.startPlayer();
              }
            },
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32,
              color: AppColors.black,
            ),
          ),
          SizedBox(
            width: getScreenWidth(8),
          ),
          isInitialised
              ? AudioFileWaveforms(
                  size: Size(MediaQuery.of(context).size.width / 1.7, 24),
                  playerController: playerController!,
                  density: 2,
                  enableSeekGesture: true,
                  playerWaveStyle: const PlayerWaveStyle(
                    scaleFactor: 0.2,
                    waveThickness: 3,
                    fixedWaveColor: AppColors.greyShade1,
                    liveWaveColor: Colors.black,
                    waveCap: StrokeCap.round,
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    color: AppColors.greyShade1,
                    backgroundColor: AppColors.greyShade1,
                  ),
                ),
          const Spacer(
            flex: 1,
          ),
          Text(
            StringUtil.formatDuration(Duration(milliseconds: currentDuration)),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: getScreenWidth(12),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController?.dispose();
  }
}
