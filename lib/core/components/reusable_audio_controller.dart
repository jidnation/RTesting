//
// import 'package:audio_waveforms/audio_waveforms.dart';
//
// class ReusableAudioController{
//
//   final PlayerController _playerController = ;
//   bool _isBeingUsed = false;
//   bool isPlaying = false;
//   // final BetterPlayerController? _activePlayer;
//
//   ReusableAudioController() {
//
//   }
//
//   PlayerController? getAudioPlayerController() {
//     if (_isBeingUsed) {
//       _isBeingUsed = true;
//     }
//     return _playerController;
//   }
//
//   void freeAudioPlayerController() {
//     _isBeingUsed = false;
//     _playerController.stopAllPlayers();
//   }
//
//   Future<bool> pausePlayingVideos() async {
//     for (var controller in _betterPlayerControllerRegistry) {
//       print('pause controller');
//       try {
//         if (controller != null) {
//           bool isInitialized = (controller.isVideoInitialized() != null)
//               ? controller.isVideoInitialized()!
//               : false;
//           bool isPlaying = !isInitialized
//               ? false
//               : ((controller.isPlaying() != null)
//               ? controller.isPlaying()!
//               : false);
//           if (isPlaying && isInitialized) {
//             print('pause video');
//             await controller.pause();
//           }
//         }
//       } catch (e) {
//         print('pause error $e');
//       }
//     }
//     for (var controller in _usedBetterPlayerControllerRegistry) {
//       print('used pause controller');
//       // freeBetterPlayerController(controller);
//       try {
//         if (controller != null) {
//           bool isInitialized = (controller.isVideoInitialized() != null)
//               ? controller.isVideoInitialized()!
//               : false;
//           bool isPlaying = !isInitialized
//               ? false
//               : ((controller.isPlaying() != null)
//               ? controller.isPlaying()!
//               : false);
//           if (isPlaying && isInitialized) {
//             print('used pause video');
//             await controller.pause();
//           }
//         }
//       } catch (e) {
//         print('used pause error $e');
//       }
//     }
//
//     isListPlaying = false;
//     return true;
//   }
//
//   void checkPlayingControllers() {
//     var playingCount = 0;
//     for (var controller in _betterPlayerControllerRegistry) {
//       try {
//         if (controller != null) {
//           bool isInitialized = (controller.isVideoInitialized() != null)
//               ? controller.isVideoInitialized()!
//               : false;
//           bool isPlaying = !isInitialized
//               ? false
//               : (controller.isPlaying() != null)
//               ? controller.isPlaying()!
//               : false;
//           if (isPlaying) {
//             playingCount += 1;
//           }
//         }
//       } catch (e) {
//         print('playing check error $e');
//       }
//     }
//     print('playing controllers $playingCount');
//
//     if (playingCount > 0) {
//       isListPlaying = true;
//     } else {
//       isListPlaying = false;
//     }
//   }
//
//   void dispose() {
//     // Future.wait([pausePlayingVideos()]).then((r) {
//     isListPlaying = false;
//     try {
//       if (_usedBetterPlayerControllerRegistry.length > 0) {
//         for (var controller in _usedBetterPlayerControllerRegistry) {
//           freeBetterPlayerController(controller);
//         }
//       }
//     } catch (e) {
//       print('error in used free $e');
//     }
//     for (var controller in _betterPlayerControllerRegistry) {
//       controller.dispose();
//     }
//     // });
//   }
// }
