import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/components/reusable_video_list/reusable_video_list_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/video_list_data.dart';

class ReusableVideoListWidget extends StatefulWidget {
  final VideoListData? videoListData;
  final ReusableVideoListController? videoListController;
  final Function? canBuildVideo;

  const ReusableVideoListWidget({
    Key? key,
    this.videoListData,
    this.videoListController,
    this.canBuildVideo,
  }) : super(key: key);

  @override
  _ReusableVideoListWidgetState createState() =>
      _ReusableVideoListWidgetState();
}

class _ReusableVideoListWidgetState extends State<ReusableVideoListWidget> {
  VideoListData? get videoListData => widget.videoListData;
  BetterPlayerController? controller;
  StreamController<BetterPlayerController?>
      betterPlayerControllerStreamController = StreamController.broadcast();
  bool _initialized = false;
  Timer? _timer;
  Timer? _playtimer;
  double fraction = 0;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print('widget dispose in reusable widget');
    if (controller != null) {
      videoListData!.wasPlaying =
          (controller!.isPlaying() != null) ? controller!.isPlaying() : false;
      if (videoListData!.wasPlaying!) {
        print('pause playing video');
        controller!.pause();
      }
    }
    betterPlayerControllerStreamController.close();
    super.dispose();
  }

  Rect? globalPaintBounds(key) {
    final renderObject = key.currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }

  void _setupController() {
    print('setup controller $controller');
    if (controller == null) {
      controller = widget.videoListController!.getBetterPlayerController();
      if (controller != null) {
        if (videoListData!.aspectRatio != null &&
            videoListData!.aspectRatio! > 0) {
          controller!.setOverriddenAspectRatio(videoListData!.aspectRatio!);
          controller!.setOverriddenFit(BoxFit.contain);
        }

        //  controller!.preCache(BetterPlayerDataSource(
        //   BetterPlayerDataSourceType.network,
        //   videoListData!.videoLink,
        //   resolutions: videoListData!.resolutions,
        //   bufferingConfiguration: BetterPlayerBufferingConfiguration(
        //     minBufferMs: 10000,
        //     maxBufferMs: 6553600,
        //     bufferForPlaybackMs: 5000,
        //     bufferForPlaybackAfterRebufferMs: 10000,
        //   ),
        //   cacheConfiguration: BetterPlayerCacheConfiguration(
        //       useCache: true,
        //       preCacheSize: 2 * 1024 * 1024,
        //       maxCacheSize: 5 * 1024 * 1024,
        //       maxCacheFileSize: 2 * 1024 * 1024,
        //       key: videoListData!.videoLink //Android only option to use cached video between app sessions
        //       ),
        // ));

        controller!.setupDataSource(BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          videoListData!.videoLink,
          resolutions: videoListData!.resolutions,
          bufferingConfiguration: BetterPlayerBufferingConfiguration(
            minBufferMs: 5000,
            maxBufferMs: 6553600,
            bufferForPlaybackMs: 2500,
            bufferForPlaybackAfterRebufferMs: 5000,
          ),
          placeholder: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: videoListData!.thumbnail,
                        fadeInDuration: Duration(seconds: 0),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // cacheConfiguration: BetterPlayerCacheConfiguration(
          //     useCache: true,
          //     preCacheSize: 2 * 1024 * 1024,
          //     maxCacheSize: 5 * 1024 * 1024,
          //     maxCacheFileSize: 2 * 1024 * 1024,
          //     key: videoListData!.videoLink //Android only option to use cached video between app sessions
          //     ),
        ));

        // controller!.play();
        controller!.addEventsListener(onPlayerEvent);

        if (!betterPlayerControllerStreamController.isClosed) {
          betterPlayerControllerStreamController.add(controller);
        }
        // controller!.onPlayerVisibilityChanged
        _playController();
      }
    } else {
      _playController();
    }
  }

  void _freeController() {
    // if (!_initialized) {
    //   _initialized = true;
    //   return;
    // }
    if (controller != null) {
      _pauseController();
      controller!.removeEventsListener(onPlayerEvent);
      widget.videoListController!.freeBetterPlayerController(controller);
      // controller!.pause();
      controller = null;
      if (!betterPlayerControllerStreamController.isClosed) {
        betterPlayerControllerStreamController.add(null);
      }
      _initialized = false;
    }
  }

  void _pauseController() {
    try {
      if (controller != null) {
        var isVideoInitialized = controller!.isVideoInitialized()!;
        var isPlaying = !isVideoInitialized
            ? false
            : ((controller!.isPlaying() != null)
                ? controller!.isPlaying()!
                : false);
        if (fraction < 0.85 && isPlaying) {
          print('pause controller pause');
          print(videoListData!.videoLink);
          controller!.pause();
          widget.videoListController?.isListPlaying = false;
        }
      }
    } catch (e) {
      widget.videoListController?.isListPlaying = false;
    }
  }

  void _playController() {
    print('play controller');
    _playtimer?.cancel();
    _playtimer = null;
    _playtimer = Timer(Duration(milliseconds: 10), () {
      print('play controller timer $controller');
      if (controller != null) {
        try {
          var isVideoInitialized = controller!.isVideoInitialized()!;
          var isPlaying = !isVideoInitialized
              ? false
              : ((controller!.isPlaying() != null)
                  ? controller!.isPlaying()!
                  : false);
          print('is initialized $isVideoInitialized is playing $isPlaying');
          if (fraction >= 0.85 && !isPlaying && isVideoInitialized) {
            // Future.wait([widget.videoListController!.pausePlayingVideos()])
            // .then((r) {
            widget.videoListController!.checkPlayingControllers();
            if (widget.videoListController!.isListPlaying) {
              print('player already active');
              _playController();
            } else {
              print('play controller play');
              print(videoListData!.videoLink);
              controller!.play();
              widget.videoListController?.isListPlaying = true;
            }
            // });
          } else if (isVideoInitialized && isPlaying) {
            print('pause - play controller');
            print(videoListData!.videoLink);
            widget.videoListController?.isListPlaying = false;
            _pauseController();
          } else {
            _playController();
          }
        } catch (e) {
          print('error in play controller $e');
          _playController();
        }
      } else {
        _playController();
      }
    });
  }

  void onPlayerEvent(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
      videoListData!.lastPosition = event.parameters!["progress"] as Duration?;
    }
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      if (videoListData!.lastPosition != null && controller != null) {
        controller!.seekTo(videoListData!.lastPosition!);
      }
    }
    if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
      // fraction = 0.85;
      // if(videoListData!.wasPlaying!) {
      //   fraction = 0.8;
      // } else {
      //   fraction = 0.2;
      // }
      print('exception play controller $fraction ');
      try {
        controller!.retryDataSource();
        // _pauseController();
        _playController();
      } catch (e) {
        print('exception error $e');
        _freeController();
        _setupController();
      }
    }
  }

  ///TODO: Handle "setState() or markNeedsBuild() called during build." error
  ///when fast scrolling through the list
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VisibilityDetector(
            key: Key(hashCode.toString() + DateTime.now().toString()),
            onVisibilityChanged: (info) {
              fraction = info.visibleFraction;
              double top = globalPaintBounds(key)?.top ??
                  0; //this is y - I think it's what you want
              double bottom = globalPaintBounds(key)?.bottom ?? 0;
              if (!widget.canBuildVideo!()) {
                _timer?.cancel();
                _timer = null;
                _timer = Timer(Duration(milliseconds: 1), () {
                  top = globalPaintBounds(key)!
                      .top; //this is y - I think it's what you want
                  bottom = globalPaintBounds(key)!.bottom;
                  fraction = info.visibleFraction;
                  print(fraction);
                  print(top);
                  print(bottom);
                  if (info.visibleFraction >= 0.85) {
                    _setupController();
                  } else {
                    _freeController();
                  }
                });
                return;
              }

              print(fraction);
              print(top);
              print(bottom);

              if (info.visibleFraction >= 0.85) {
                _setupController();
              } else {
                _freeController();
              }
            },
            child: StreamBuilder<BetterPlayerController?>(
              stream: betterPlayerControllerStreamController.stream,
              builder: (context, snapshot) {
                return Container(
                  height: videoListData!.maxHeight,
                  color: Colors.black,
                  child: controller != null
                      ? BetterPlayer(
                          controller: controller!,
                        )
                      : Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CachedNetworkImage(
                                      imageUrl: videoListData!.thumbnail,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   right: 10,
                                  //   top: 10,
                                  //   child: Container(
                                  //     width: 20,
                                  //     height: 20,
                                  //     child: CircularProgressIndicator(
                                  //       backgroundColor: Colors.white,
                                  //       strokeWidth: 4,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    if (controller != null) {
      videoListData!.wasPlaying =
          (controller!.isPlaying() != null) ? controller!.isPlaying() : false;
      if (videoListData!.wasPlaying!) {
        controller!.pause();
      }
    }
    _initialized = true;
    super.deactivate();
  }
}
