import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/models/file_result.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/file_utils.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:reach_me/features/home/presentation/widgets/post_media.dart';
import 'package:reach_me/features/home/presentation/widgets/video_preview.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/string_util.dart';
import 'gallery_view.dart';

class PostReachMediaGrid extends HookWidget {
  final List<UploadFileDto> mediaList;
  final Function(int)? onRemove;
  final Function(List<UploadFileDto>)? onUpdateList;
  const PostReachMediaGrid(
      {Key? key, required this.mediaList, this.onRemove, this.onUpdateList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final imageVideoList = useState(mediaList);
    // int imageVideoTotal = imageVideoList.value.length;
    if (mediaList.length == 1) {
      return Row(
        children: [
          PostReachMedia(
            onClose: () {
              onRemove!(0);
            },
            fileResult: mediaList.first.fileResult!,
          ),
        ],
      );
    } else if (mediaList.length == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: PostReachMedia(
            onClose: () {
              onRemove!(0);
            },
            fileResult: mediaList[0].fileResult!,
            size: 400,
          )),
          SizedBox(width: getScreenWidth(0)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PostReachMedia(
                  onClose: () {
                    onRemove!(1);
                  },
                  fileResult: mediaList[1].fileResult!,
                  size: 195,
                ),
                SizedBox(height: getScreenHeight(10)),
                PostReachMedia(
                  onClose: () {
                    onRemove!(2);
                  },
                  fileResult: mediaList[2].fileResult!,
                  size: 195,
                )
              ],
            ),
          )
        ],
      );
    } else if (mediaList.length > 4) {
      int remMedia = mediaList.length - 4;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PostReachMedia(
                  onClose: () {
                    onRemove!(0);
                  },
                  fileResult: mediaList[0].fileResult!,
                ),
                SizedBox(height: getScreenHeight(5)),
                PostReachMedia(
                  onClose: () {
                    onRemove!(1);
                  },
                  fileResult: mediaList[1].fileResult!,
                )
              ],
            ),
          ),
          SizedBox(width: getScreenWidth(0)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PostReachMedia(
                  onClose: () {
                    onRemove!(2);
                  },
                  fileResult: mediaList[2].fileResult!,
                ),
                SizedBox(height: getScreenHeight(10)),
                GestureDetector(
                  onTap: () async {
                    final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => PostReachGalleryView(
                                  mediaList: mediaList,
                                  initialPage: 3,
                                )));
                    if (onUpdateList == null || res == null) return;
                    onUpdateList!(res);
                  },
                  child: MediaWithCounter(
                    count: remMedia,
                    left: 0,
                    width: getScreenWidth(178),
                    child: PostReachMedia(
                      fileResult: mediaList[3].fileResult!,
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
              crossAxisSpacing: 2,
              mainAxisSpacing: 10),
          shrinkWrap: true,
          itemCount: mediaList.length,
          itemBuilder: (context, index) {
            String path = mediaList[index].file.path;
            return PostReachMedia(
              onClose: () {
                onRemove!(index);
              },
              fileResult: mediaList[index].fileResult!,
            );
          });
    }
  }
}

class PostReachMedia extends StatelessWidget {
  final FileResult fileResult;
  final Function()? onClose;
  final double? size;
  const PostReachMedia(
      {Key? key, this.onClose, required this.fileResult, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isVideo = FileUtils.isVideo(fileResult.file);
    String? duration = fileResult.duration == null
        ? null
        : StringUtil.formatDuration(Duration(seconds: fileResult.duration!));
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: getScreenWidth(size ?? 200),
          height: getScreenHeight(size ?? 200),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.file(
            (isVideo) ? File(fileResult.thumbnail!) : fileResult.file,
            fit: BoxFit.cover,
          ),
        ),
        (isVideo)
            ? Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(50),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )
            : Container(),
        (isVideo)
            ? Positioned(
                right: getScreenWidth(4),
                bottom: getScreenWidth(5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Center(
                        child: Text(
                      duration ?? '',
                      style: TextStyle(color: AppColors.grey),
                    )),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: AppColors.white),
                  ),
                ),
              )
            : Container(),
        (isVideo)
            ? Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.white,
                    size: 52,
                  ),
                ),
              )
            : Container(),
        Positioned.fill(child: GestureDetector(onTap: () {
          RouteNavigators.route(
              context,
              (isVideo)
                  ? VideoPreview(
                      path: fileResult.file.path,
                      isLocalVideo: true,
                      aspectRatio: fileResult.width! / fileResult.height!,
                    )
                  : PhotoView(
                      imageProvider: FileImage(
                        fileResult.file,
                      ),
                    ));
        })),
        onClose != null
            ? Positioned(
                right: getScreenWidth(4),
                top: getScreenWidth(5),
                child: GestureDetector(
                  onTap: onClose,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: getScreenHeight(26),
                      width: getScreenWidth(26),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: AppColors.grey,
                          size: getScreenHeight(14),
                        ),
                      ),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.white),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    ).paddingOnly(r: 10);
  }
}

class PostReachAudioMedia extends StatefulWidget {
  final String path;
  final EdgeInsets? margin, padding;
  final Function() onCancel;
  const PostReachAudioMedia(
      {Key? key,
      required this.path,
      required this.onCancel,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  State<PostReachAudioMedia> createState() => _PostReachAudioMediaState();
}

class _PostReachAudioMediaState extends State<PostReachAudioMedia> {
  late PlayerController playerController;
  bool isInitialised = false;
  bool isPlaying = false;
  final currentDurationStream = StreamController<int>();
  int currentDuration = 0;
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    // String fileName = widget.path;
    // String? dir = (await getDownloadsDirectory()).path;
    // String savePath = '$dir/$fileName';
    playerController = PlayerController();
    playerController.onCurrentDurationChanged.listen((event) {
      currentDuration = event;
      setState(() {});
      Console.log('<<AUDIO-DURATION>>', event.toString());
    });
    playerController.addListener(() {
      Console.log('<<AUDIO-LISTENER>>', playerController.playerState.name);
      if (playerController.playerState == PlayerState.initialized) {
        isInitialised = true;
        setState(() {});
      } else if (playerController.playerState == PlayerState.playing) {
        isPlaying = true;
        setState(() {});
      } else if (playerController.playerState == PlayerState.paused ||
          playerController.playerState == PlayerState.stopped) {
        isPlaying = false;
        setState(() {});
      }
    });
    await playerController.preparePlayer(widget.path);
    // await playerController.startPlayer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: getScreenHeight(36),
      decoration: BoxDecoration(
          color: AppColors.audioPlayerBg,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (isPlaying) {
                playerController.pausePlayer();
              } else {
                playerController.startPlayer();
              }
            },
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32,
              color: AppColors.black,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          isInitialised
              ? AudioFileWaveforms(
                  size: Size(MediaQuery.of(context).size.width / 2, 24),
                  playerController: playerController,
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
                  width: MediaQuery.of(context).size.width / 2,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    color: AppColors.greyShade1,
                    backgroundColor: AppColors.greyShade1,
                  ),
                ),
          SizedBox(
            width: getScreenWidth(12),
          ),
          Text(
            StringUtil.formatDuration(Duration(milliseconds: currentDuration)),
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Spacer(
            flex: 1,
          ),
          GestureDetector(
            onTap: widget.onCancel,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                height: getScreenHeight(36),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.white),
                child: Icon(
                  Icons.close_rounded,
                  size: getScreenHeight(16),
                  color: AppColors.audioPlayerClose,
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}

// class PostReachAudioMedia extends StatefulWidget {
//   final String path;
//   final Function() onCancel;
//   const PostReachAudioMedia(
//       {Key? key, required this.path, required this.onCancel})
//       : super(key: key);
//
//   @override
//   State<PostReachAudioMedia> createState() => _PostReachAudioMediaState();
// }
//
// class _PostReachAudioMediaState extends State<PostReachAudioMedia> {
//   final progressStream = StreamController<WaveformProgress>();
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   Future<void> _init() async {
//     final audioFile = File(widget.path);
//     try {
//       final waveFile =
//           File((await getTemporaryDirectory()).path + 'waveform.wave');
//       JustWaveform.extract(audioInFile: audioFile, waveOutFile: waveFile)
//           .listen(progressStream.add, onError: progressStream.addError);
//     } catch (e) {
//       progressStream.addError(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         height: 150.0,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: const BorderRadius.all(Radius.circular(20.0)),
//         ),
//         padding: const EdgeInsets.all(16.0),
//         width: double.maxFinite,
//         child: StreamBuilder<WaveformProgress>(
//           stream: progressStream.stream,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   'Error: ${snapshot.error}',
//                   style: Theme.of(context).textTheme.headline6,
//                   textAlign: TextAlign.center,
//                 ),
//               );
//             }
//             final progress = snapshot.data?.progress ?? 0.0;
//             final waveform = snapshot.data?.waveform;
//             if (waveform == null) {
//               return Center(
//                 child: Text(
//                   '${(100 * progress).toInt()}%',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//               );
//             }
//             return AudioWaveformWidget(
//               waveform: waveform,
//               start: Duration.zero,
//               duration: waveform.duration,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
