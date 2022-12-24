import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/presentation/widgets/gallery_view.dart';
import 'package:reach_me/features/home/presentation/widgets/post_media.dart';
import 'package:reach_me/features/momentControlRoom/moment_cacher.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/services/media_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/string_util.dart';

class CommentMedia extends StatelessWidget {
  final CommentModel comment;

  const CommentMedia({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [];

    int nImages = (comment.imageMediaItems ?? []).length;
    print('This is the number of images found here $nImages');

    if (nImages > 0) imageList.addAll(comment.imageMediaItems ?? []);

    print('Image List is shown as Follows $imageList');

    if (imageList.length == 1) {
      return CommentImageMedia(
        imageUrl: imageList.first,
        allMediaUrls: imageList,
        index: 0,
      );
    } else if (imageList.length == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: CommentImageMedia(
            imageUrl: imageList[0],
            allMediaUrls: imageList,
            index: 0,
          )),
          SizedBox(width: getScreenHeight(5)),
          Expanded(
              child: CommentImageMedia(
                  imageUrl: imageList[1], allMediaUrls: imageList, index: 1)),
        ],
      );
    } else if (imageList.length == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: CommentImageMedia(
            imageUrl: imageList[0],
            allMediaUrls: imageList,
            index: 0,
          )),
          SizedBox(width: getScreenHeight(5)),
          Expanded(
            child: Column(
              children: [
                CommentImageMedia(
                  imageUrl: imageList[1],
                  height: 75,
                  allMediaUrls: imageList,
                  index: 1,
                ),
                SizedBox(height: getScreenHeight(5)),
                CommentImageMedia(
                  imageUrl: imageList[2],
                  height: 75,
                  allMediaUrls: imageList,
                  index: 2,
                )
              ],
            ),
          )
        ],
      );
    } else if (imageList.length > 4) {
      int remMedia = imageList.length - 4;
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommentImageMedia(
                imageUrl: imageList[0],
                height: 750,
                allMediaUrls: imageList,
                index: 0,
              ),
              SizedBox(height: getScreenHeight(5)),
              PostImageMedia(
                imageUrl: imageList[1],
                index: 1,
                height: 75,
                allMediaUrls: imageList,
              )
            ],
          ),
        ),
        SizedBox(width: getScreenWidth(5)),
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommentImageMedia(
              imageUrl: imageList[2],
              height: 75,
              index: 2,
              allMediaUrls: imageList,
            ),
            SizedBox(height: getScreenHeight(5)),
            GestureDetector(
              onTap: () => RouteNavigators.route(
                  context,
                  AppGalleryView(
                    mediaPaths: imageList,
                    initialPage: 3,
                  )),
              child: MediaWithCounter(
                count: remMedia,
                child: CommentImageMedia(
                  imageUrl: imageList[3],
                  height: 75,
                  allMediaUrls: imageList,
                ),
              ),
            )
          ],
        ))
      ]);
    } else {
      return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 178 / 164,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          shrinkWrap: true,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            String path = imageList[index];
            return Container(
                height: getScreenHeight(300),
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: PostImageMedia(
                  imageUrl: path,
                  allMediaUrls: imageList,
                  index: index,
                ));
          });
    }
  }
}

class CommentImageMedia extends StatefulWidget {
  final String imageUrl;
  final List<String>? allMediaUrls;
  final int? index;
  final double? height, width;

  const CommentImageMedia(
      {Key? key,
      required this.imageUrl,
      this.height,
      this.width,
      this.allMediaUrls,
      this.index})
      : super(key: key);

  @override
  State<CommentImageMedia> createState() => _CommentImageMediaState();
}

class _CommentImageMediaState extends State<CommentImageMedia> {
  @override
  Widget build(BuildContext context) {
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
        child: CachedNetworkImage(imageUrl: widget.imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}

class CommentAudioMedia extends StatefulWidget {
  final String path;
  final EdgeInsets? margin, padding;
  const CommentAudioMedia(
      {Key? key, required this.path, this.margin, this.padding})
      : super(key: key);

  @override
  State<CommentAudioMedia> createState() => _CommentAudioMediaState();
}

class _CommentAudioMediaState extends State<CommentAudioMedia> {
  PlayerController? playerController;
  bool isInitialised = false;
  bool isPlaying = false;
  bool isReadingCompleted = false;
  //final currentDurationStream = StreamController<int>();
  int currentDuration = 0;
 
  final MediaService _mediaService = MediaService();
  Map<String, PlayerController> playerControllers = {};
  late VideoAudioCommentCacheService videoAudioservices = CachedVideoAudioService(DefaultCacheManager());

  @override
  void initState() {
    super.initState();
    if (mounted) initPlayer();
  }

  Future<void> initPlayer() async {
    late String filePath;
    playerController = PlayerController();
    File? audioFile = await videoAudioservices.getAudioFile(widget.path);

    if (audioFile == null) {
      final res = await _mediaService.downloadFile(url: widget.path);
      filePath = res!.path;
    } else {
      filePath = audioFile.path;
    }
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

    await playerController!.preparePlayer(filePath);
    // await playerController.startPlayer();
    if (mounted) setState(() {});
  }

  Future<PlayerController> getPlayerController(
      String path, String playerkey) async {
    if (playerkey != null && playerControllers.containsKey(playerkey)) {
      return playerControllers[playerkey]!;
    }

    final anotherPlayerController = PlayerController();
    await anotherPlayerController.preparePlayer(path);
    playerControllers[anotherPlayerController.playerKey] =
        anotherPlayerController;
    return anotherPlayerController;
  }

  @override
  Widget build(BuildContext context) {
    
    print("current duration $currentDuration");

    return Container(
      margin: widget.margin,
      height: getScreenHeight(36),
      decoration: const BoxDecoration(
          color: AppColors.audioPlayerBg,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // playerController?.pausePlayer();

              //   playerController = await getPlayerController(widget.path,playerController!.playerKey);
              //   playerController!.startPlayer(finishMode: FinishMode.pause);

              if (playerController == null) return;
              if (isPlaying) {
                playerController!.pausePlayer();
              } else {
                // playerController!.stopAllPlayers();
                playerController!.startPlayer(finishMode: FinishMode.pause);
              }
            },
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(
            width: getScreenWidth(8),
          ),
          isInitialised
              ? Expanded(
                  child: AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width / 2.0, 24),
                    playerController: playerController!,
                    density: 2,
                    enableSeekGesture: true,
                    playerWaveStyle: const PlayerWaveStyle(
                      scaleFactor: 0.2,
                      waveThickness: 3,
                      fixedWaveColor: AppColors.white,
                      liveWaveColor: Colors.blueAccent,
                      waveCap: StrokeCap.round,
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 2.0,
                  child: const LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    color: AppColors.greyShade1,
                    backgroundColor: AppColors.greyShade1,
                  ),
                ),
          const Spacer(
            flex: 1,
          ),
          Text(
            StringUtil.formatDuration(Duration(milliseconds: currentDuration)),
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.blueAccent),
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

abstract class VideoAudioCommentCacheService {
  Future<VideoPlayerController> getVideoFile(String videoUrl);
  Future<File?> getAudioFile(String audioUrl);
}

class CachedVideoAudioService extends VideoAudioCommentCacheService {
  final BaseCacheManager _cacheManager;

  CachedVideoAudioService(this._cacheManager);

  @override
  Future<File?> getAudioFile(String audioUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(audioUrl);

    if (fileInfo == null) {
      print('[VideoAudioCommentCacheService]: No audio in cache');

      unawaited(_cacheManager.downloadFile(audioUrl));
      return null;
    } else {
      print('[VideoAudioCommentCacheService]: Loading audio from cache');

      return fileInfo.file;
    }
  }

  @override
  Future<VideoPlayerController> getVideoFile(String videoUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(videoUrl);

    if (fileInfo == null) {
      print('[VideoAudioCommentCacheService]: No video in cache');
      unawaited(_cacheManager.downloadFile(videoUrl));

      return VideoPlayerController.network(videoUrl);
    } else {
      print('[VideoAudioCommentCacheService]: Loading video from cache');
      return VideoPlayerController.file(fileInfo.file);
    }
  }
}
