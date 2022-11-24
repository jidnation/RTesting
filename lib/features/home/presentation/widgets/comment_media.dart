import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/presentation/widgets/gallery_view.dart';
import 'package:reach_me/features/home/presentation/widgets/post_media.dart';

class CommentMedia extends StatelessWidget {
  final CommentModel comment;

  const CommentMedia({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [];

    int nImages = (comment.imageMediaItems ?? []).length;

    if (nImages > 0) imageList.addAll(comment.imageMediaItems ?? []);

    if (imageList.length == 1) {
      return CommentImageMedia(
        imageUrl: imageList.first,
        allMediaUrls: imageList,
        index: 0,
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
                  height: 150,
                  allMediaUrls: imageList,
                  index: 1,
                ),
                SizedBox(height: getScreenHeight(5)),
                CommentImageMedia(
                  imageUrl: imageList[2],
                  height: 150,
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Expanded( 
          child: Column( 
            mainAxisSize: MainAxisSize.min,
            children: [
              CommentImageMedia(imageUrl: imageList[0],
              height: 150,
              allMediaUrls: imageList,
              index: 0,
              ),
              SizedBox( height: getScreenHeight(5)),
              PostImageMedia(imageUrl: imageList[1],
              index: 1,
              height: 150,
              allMediaUrls: imageList,
              )
            ],
          ),
         ),
         SizedBox(width: getScreenWidth(5)),
         Expanded(child: 
         Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommentImageMedia(imageUrl: imageList[2],
            height: 150,
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
                    child: PostImageMedia(
                      imageUrl: imageList[3],
                      height: 150,
                    ),
                  ),
                )
            
                   ],
         ))
      ]
      
      );
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
              child:PostImageMedia(
                      imageUrl: path,
                      allMediaUrls: imageList,
                      index: index,
                    )
                  
            );
          });

    }
  }
}

class CommentImageMedia extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: allMediaUrls == null
          ? null
          : (() => RouteNavigators.route(
              context,
              AppGalleryView(
                mediaPaths: allMediaUrls!,
                initialPage: index,
              ))),
      child: Container(
        height: getScreenHeight(height ?? 300),
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
