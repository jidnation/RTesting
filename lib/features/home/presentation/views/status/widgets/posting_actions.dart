// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../../../core/services/media_service.dart';
// import '../../../../../../core/services/navigation/navigation_service.dart';
// import '../../../../../../core/utils/constants.dart';
// import '../../../../../../core/utils/dimensions.dart';
// import '../../../../../../core/utils/file_utils.dart';
// import '../create.status.dart';
//
// Container buildPostingActions(Size size, BuildContext context) {
//   return Container(
//     width: size.width,
//     decoration: const BoxDecoration(),
//     child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: getScreenHeight(44)),
//           Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Flexible(
//                   child: IconButton(
//                     onPressed: () async {
//                       // final image =
//                       //     await getImage(ImageSource.gallery);
//                       final res = await MediaService()
//                           .pickFromGallery(context: context);
//                       if (res != null) {
//                         RouteNavigators.route(
//                             context,
//                             BuildMediaPreview(
//                               path: res.first.path,
//                               isVideo: FileUtils.isVideo(
//                                   res.first.file),
//                             ));
//                       }
//                     },
//                     icon: Transform.scale(
//                       scale: 1.8,
//                       child: SvgPicture.asset(
//                         'assets/svgs/check-gallery.svg',
//                         height: getScreenHeight(71),
//                       ),
//                     ),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ),
//                 SizedBox(width: getScreenWidth(70)),
//                 Flexible(
//                   child: InkWell(
//                     onTap: () async {
//                       await controller!.takePicture().then(
//                               (value) => RouteNavigators.route(
//                               context,
//                               BuildMediaPreview(
//                                   path: value.path,
//                                   isVideo: false)));
//                     },
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: AppColors.white,
//                       ),
//                       padding: const EdgeInsets.all(20),
//                       child: SvgPicture.asset(
//                         'assets/svgs/Camera.svg',
//                         color: AppColors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: getScreenWidth(70)),
//                 Flexible(
//                   child: IconButton(
//                     onPressed: () {
//                       if (_cameras.isNotEmpty &&
//                           _cameras.length > 1) {
//                         if (_cameras.length == 2) {
//                           if (controller!
//                               .description.lensDirection ==
//                               CameraLensDirection.front) {
//                             initializeCamera(_cameras[0]);
//                           } else {
//                             initializeCamera(_cameras[1]);
//                           }
//                         } else {
//                           initializeCamera(_cameras[1]);
//                         }
//                       }
//                       setState(() {});
//                     },
//                     icon: Transform.scale(
//                       scale: 1.8,
//                       child: SvgPicture.asset(
//                         'assets/svgs/flip-camera.svg',
//                         height: getScreenHeight(71),
//                       ),
//                     ),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ),
//               ]),
//         ]),
//   );
// }
