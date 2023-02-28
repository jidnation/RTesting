// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get/get.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:reach_me/core/utils/constants.dart';
// import 'package:reach_me/core/utils/file_utils.dart';
// import 'package:reach_me/features/home/presentation/views/post_reach.dart';
// import 'package:reach_me/features/home/presentation/widgets/video_preview.dart';
//
// class AppGalleryView extends HookWidget {
//   final List<String> mediaPaths;
//   final int? initialPage;
//   const AppGalleryView({Key? key, required this.mediaPaths, this.initialPage})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final pageController = usePageController(initialPage: initialPage ?? 0);
//     return SafeArea(
//       child: PageView.builder(
//           itemCount: mediaPaths.length,
//           scrollDirection: Axis.horizontal,
//           pageSnapping: true,
//           controller: pageController,
//           itemBuilder: (context, index) {
//             String path = mediaPaths[index];
//             if (FileUtils.isImagePath(path)) {
//               return Stack(children: [
//                 PhotoView(
//                     imageProvider: NetworkImage(path),
//                     loadingBuilder: (context, event) => const Center(
//                           child: CupertinoActivityIndicator(
//                             color: Colors.white,
//                           ),
//                         )),
//                 Positioned(
//                   top: 20,
//                   left: 20,
//                   right: 20,
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Card(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: const SizedBox(
//                               height: 30,
//                               width: 30,
//                               child: Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         )
//                       ]),
//                 )
//               ]);
//             } else {
//               return VideoPreview(
//                 path: path,
//                 isLocalVideo: false,
//               );
//             }
//           }),
//     );
//   }
// }
//
// class PostReachGalleryView extends HookWidget {
//   final List<UploadFileDto> mediaList;
//   final int? initialPage;
//   const PostReachGalleryView(
//       {Key? key, required this.mediaList, this.initialPage})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final pageController = usePageController(initialPage: initialPage ?? 0);
//     // final _mediaList = useState<List<UploadFileDto>>(mediaList);
//     return WillPopScope(
//       onWillPop: () {
//         // Navigator.pop(context, _mediaList.value);
//         return Future.value(false);
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               color: AppColors.black,
//             ),
//             SafeArea(
//               child: PageView.builder(
//                   itemCount: _mediaList.value.length,
//                   scrollDirection: Axis.horizontal,
//                   pageSnapping: true,
//                   controller: pageController,
//                   itemBuilder: (context, index) {
//                     String path = _mediaList.value[index].file.path;
//                     if (FileUtils.isImagePath(path)) {
//                       return Stack(
//                         children: [
//                           PhotoView(
//                               imageProvider: FileImage(File(path)),
//                               loadingBuilder: (context, event) => const Center(
//                                     child: CupertinoActivityIndicator(
//                                       color: Colors.white,
//                                     ),
//                                   )),
//                           Positioned(
//                             right: 10,
//                             child: IconButton(
//                                 onPressed: () {
//                                   _mediaList.value = [..._mediaList.value]
//                                     ..removeAt(index);
//                                 },
//                                 icon: Container(
//                                   child: Icon(
//                                     Icons.close_rounded,
//                                     color: AppColors.white,
//                                   ),
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: AppColors.black.withOpacity(0.3)),
//                                   // height: 64,
//                                   padding: EdgeInsets.all(4),
//                                 )),
//                           )
//                         ],
//                       );
//                     } else {
//                       return Stack(
//                         children: [
//                           VideoPreview(
//                             path: path,
//                             isLocalVideo: true,
//                           ),
//                           Positioned(
//                             right: 10,
//                             child: IconButton(
//                                 onPressed: () {
//                                   _mediaList.value = [..._mediaList.value]
//                                     ..removeAt(index);
//                                 },
//                                 icon: Container(
//                                   child: Icon(
//                                     Icons.close_rounded,
//                                     color: AppColors.white,
//                                   ),
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: AppColors.black.withOpacity(0.5)),
//                                   height: 24,
//                                   padding: EdgeInsets.all(4),
//                                 )),
//                           )
//                         ],
//                       );
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
