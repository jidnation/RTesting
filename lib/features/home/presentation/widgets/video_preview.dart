// import 'dart:io';
//
// import 'package:better_player/better_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:reach_me/core/utils/app_globals.dart';
// import 'package:reach_me/core/utils/constants.dart';
// import 'package:reach_me/core/utils/dimensions.dart';
// import 'package:reach_me/features/moment/moment_feed.dart';
// import 'package:reach_me/features/timeline/loading_widget.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPreview extends StatefulWidget {
//   final bool isLocalVideo;
//   final bool? showControls, loop;
//   final String path;
//   final double? aspectRatio;
//   final Function(BetterPlayerController controller)? onInitialised;
//   final BetterPlayerController? controller;
//   const VideoPreview(
//       {Key? key,
//       required this.isLocalVideo,
//       required this.path,
//       this.aspectRatio,
//       this.showControls,
//       this.loop,
//       this.controller,
//       this.onInitialised})
//       : super(key: key);
//
//   @override
//   State<VideoPreview> createState() => _VideoPreviewState();
// }
//
// class _VideoPreviewState extends State<VideoPreview> {
//   late BetterPlayerController _betterPlayerController;
//   late VideoPlayerController _videoPlayerController;
//   bool _initialised = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initBetterPlayer();
//   }
//
//   void initBetterPlayer() {
//     BetterPlayerConfiguration betterPlayerConfiguration =
//         BetterPlayerConfiguration(
//             placeholder: const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.white,
//               ),
//             ),
//             overlay: Container(
//               width: double.infinity,
//               color: AppColors.black.withOpacity(0.1),
//             ),
//             controlsConfiguration: BetterPlayerControlsConfiguration(
//                 enableQualities: false,
//                 enableSubtitles: false,
//                 enableAudioTracks: false,
//                 showControls: widget.showControls ?? true,
//                 enableOverflowMenu: false),
//             autoPlay: true,
//             looping: widget.loop ?? false);
//
//     BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//         widget.isLocalVideo
//             ? BetterPlayerDataSourceType.file
//             : BetterPlayerDataSourceType.network,
//         !widget.isLocalVideo
//             ? widget.path
//             : widget.isLocalVideo && Platform.isIOS
//                 ? 'file://${widget.path}'
//                 : widget.path,
//         videoFormat: Platform.isIOS ? BetterPlayerVideoFormat.hls : null,
//         cacheConfiguration: BetterPlayerCacheConfiguration(
//           useCache: true,
//           // preCacheSize: 10 * 1024 * 1024,
//           // maxCacheSize: 10 * 1024 * 1024,
//           // maxCacheFileSize: 10 * 1024 * 1024,
//
//           ///Android only option to use cached video between app sessions
//           key: widget.path,
//         ));
//
//     _betterPlayerController = BetterPlayerController(
//       betterPlayerConfiguration,
//       betterPlayerDataSource: betterPlayerDataSource,
//     );
//
//     _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
//       if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
//         _betterPlayerController.setOverriddenAspectRatio(
//             _betterPlayerController.videoPlayerController?.value.aspectRatio ??
//                 1);
//
//         if (widget.onInitialised != null) {
//           widget.onInitialised!(_betterPlayerController);
//           globals.statusVideoController = _betterPlayerController;
//         }
//         _initialised = true;
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _betterPlayerController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       key: Key(widget.path),
//       child: Container(
//         color: AppColors.black,
//         alignment: Alignment.center,
//         child: _initialised
//             ? BetterPlayer(
//                 controller: widget.onInitialised != null
//                     ? globals.statusVideoController!
//                     : _betterPlayerController,
//               )
//             : SizedBox(
//                 height: getScreenHeight(64),
//                 width: getScreenWidth(64),
//                 child: CircularProgressIndicator(
//                   color: AppColors.white,
//                 ),
//               ),
//       ),
//     );
//   }
// }
//
// class ChewieVideoPreviewer extends StatefulWidget {
//   final bool isLocalVideo;
//   final bool? showControls, loop;
//   final String path;
//   final double? aspectRatio;
//   const ChewieVideoPreviewer(
//       {Key? key,
//       required this.isLocalVideo,
//       this.showControls,
//       this.aspectRatio,
//       this.loop,
//       required this.path})
//       : super(key: key);
//
//   @override
//   State<ChewieVideoPreviewer> createState() => _ChewieVideoPreviewerState();
// }
//
// class _ChewieVideoPreviewerState extends State<ChewieVideoPreviewer> {
//   late VideoPlayerController _videoPlayerController;
//
//   ChewieController? _chewieController;
//   bool isInitialized = false;
//
//   @override
//   void initState() {
//     print(":::::::::;;;;;;; ${widget.path}");
//     super.initState();
//     initializePlayer();
//   }
//
//   Future<void> initializePlayer() async {
//     _videoPlayerController = await momentFeedStore.videoControllerService
//         .getControllerForVideo(
//             widget.isLocalVideo ? 'file://${widget.path}' : widget.path);
//     // await Future.wait([_videoPlayerController.initialize()]);
//     await _videoPlayerController.initialize();
//     _createChewieController();
//     setState(() {});
//   }
//
//   void _createChewieController() {
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: true,
//       aspectRatio: _videoPlayerController.value.aspectRatio,
//       // aspectRatio: 0.9,
//       allowFullScreen: true,
//
//       looping: true,
//       autoInitialize: true,
//       // hideControlsTimer: const Duration(seconds: 1),
//       // showControls: false,
//       materialProgressColors: ChewieProgressColors(
//         playedColor: Colors.white,
//         handleColor: Colors.white,
//         backgroundColor: Colors.grey,
//         bufferedColor: Colors.white54,
//       ),
//       placeholder: Container(
//         color: const Color(0xff001824),
//       ),
//     );
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   bool show = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black,
//       body: SafeArea(
//         child: Container(
//           color: AppColors.black,
//           alignment: Alignment.center,
//           child: _chewieController != null &&
//                   _chewieController!.videoPlayerController.value.isInitialized
//               ? Chewie(
//                   controller: _chewieController!,
//                 )
//               : Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(color: Colors.white),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         loadingEffect2(),
//                       ]),
//                 ),
//         ),
//       ),
//     );
//   }
// }
