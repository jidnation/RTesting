import 'package:better_player/better_player.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

class ReusableVideoListController {
  final List<BetterPlayerController> _betterPlayerControllerRegistry = [];
  final List<BetterPlayerController> _usedBetterPlayerControllerRegistry = [];
  bool isListPlaying = false;
  // final BetterPlayerController? _activePlayer;

  ReusableVideoListController() {
    for (int index = 0; index < 2; index++) {
      _betterPlayerControllerRegistry.add(
        BetterPlayerController(
          BetterPlayerConfiguration(
            handleLifecycle: true,
            autoDispose: false,
            fit: BoxFit.contain,
            autoPlay: false,
            expandToFill: true,
            looping: true,
            autoDetectFullscreenAspectRatio: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                showControlsOnInitialize: false,
                enableSkips: false,
                enableOverflowMenu: true,
                playIcon: Icons.play_arrow_sharp,
                enableQualities: true,
                enableSubtitles: false,
                controlBarColor: Colors.black.withOpacity(0.3)),
          ),
        ),
      );
    }
  }

  BetterPlayerController? getBetterPlayerController() {
    // return _betterPlayerControllerRegistry[0];
    final freeController = _betterPlayerControllerRegistry.firstWhereOrNull(
        (controller) =>
            !_usedBetterPlayerControllerRegistry.contains(controller));

    if (freeController != null) {
      _usedBetterPlayerControllerRegistry.add(freeController);
    }
    // else {
    //   //  pausePlayingVideos();
    //   //  freeBetterPlayerController();
    //    return _usedBetterPlayerControllerRegistry[0];
    // }

    return freeController;
  }

  void freeBetterPlayerController(
      BetterPlayerController? betterPlayerController) {
    _usedBetterPlayerControllerRegistry.remove(betterPlayerController);
  }

  Future<bool> pausePlayingVideos() async {
    for (var controller in _betterPlayerControllerRegistry) {
      print('pause controller');
      try {
        if (controller != null) {
          bool isInitialized = (controller.isVideoInitialized() != null)
              ? controller.isVideoInitialized()!
              : false;
          bool isPlaying = !isInitialized
              ? false
              : ((controller.isPlaying() != null)
                  ? controller.isPlaying()!
                  : false);
          if (isPlaying && isInitialized) {
            print('pause video');
            await controller.pause();
          }
        }
      } catch (e) {
        print('pause error $e');
      }
    }
    for (var controller in _usedBetterPlayerControllerRegistry) {
      print('used pause controller');
      // freeBetterPlayerController(controller);
      try {
        if (controller != null) {
          bool isInitialized = (controller.isVideoInitialized() != null)
              ? controller.isVideoInitialized()!
              : false;
          bool isPlaying = !isInitialized
              ? false
              : ((controller.isPlaying() != null)
                  ? controller.isPlaying()!
                  : false);
          if (isPlaying && isInitialized) {
            print('used pause video');
            await controller.pause();
          }
        }
      } catch (e) {
        print('used pause error $e');
      }
    }

    isListPlaying = false;
    return true;
  }

  void checkPlayingControllers() {
    var playingCount = 0;
    for (var controller in _betterPlayerControllerRegistry) {
      try {
        if (controller != null) {
          bool isInitialized = (controller.isVideoInitialized() != null)
              ? controller.isVideoInitialized()!
              : false;
          bool isPlaying = !isInitialized
              ? false
              : (controller.isPlaying() != null)
                  ? controller.isPlaying()!
                  : false;
          if (isPlaying) {
            playingCount += 1;
          }
        }
      } catch (e) {
        print('playing check error $e');
      }
    }
    print('playing controllers $playingCount');

    if (playingCount > 0) {
      isListPlaying = true;
    } else {
      isListPlaying = false;
    }
  }

  void dispose() {
    // Future.wait([pausePlayingVideos()]).then((r) {
    isListPlaying = false;
    try {
      if (_usedBetterPlayerControllerRegistry.length > 0) {
        for (var controller in _usedBetterPlayerControllerRegistry) {
          freeBetterPlayerController(controller);
        }
      }
    } catch (e) {
      print('error in used free $e');
    }
    for (var controller in _betterPlayerControllerRegistry) {
      controller.dispose();
    }
    // });
  }
}
