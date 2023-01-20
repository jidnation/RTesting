import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:reach_me/features/timeline/models/post_feed.dart';

import '../../core/models/user.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/dimensions.dart';

imageLoader({required String imageUrl, double? height}) {
  if (imageUrl.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        height: height ?? 122,
        // width: 200,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}




Widget pictureViewer(BuildContext context, {ErProfile? ownerProfilePicture}) {
  return FullScreenWidget(
      child: Stack(
    children: [
      Container(
        color: AppColors.black,
      ),
      Column(
        children: [
          Container(
            height: getScreenHeight(100),
          ),
          Image.network(ownerProfilePicture!.profilePicture!,
              fit: BoxFit.contain)
        ],
      ),
      Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            title: const Text('Profile Picture'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColors.black, //You can make this transparent
            elevation: 0.0,
          ))
    ],
  ));
}


Widget pictureViewer2(BuildContext context, {User? ownerProfilePicture}) {
  return FullScreenWidget(
      child: Stack(
    children: [
      Container(
        color: AppColors.black,
      ),
      Column(
        children: [
          Container(
            height: getScreenHeight(100),
          ),
          Image.network(ownerProfilePicture!.profilePicture!,
              fit: BoxFit.contain)
        ],
      ),
      Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            title: const Text('Profile Picture'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColors.black, //You can make this transparent
            elevation: 0.0,
          ))
    ],
  ));
}
