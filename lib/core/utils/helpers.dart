import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';

class Helper {
  static String parseDate(DateTime? date) {
    String? day = '', month = '';
    final year = date!.year.toString();
    if (date.month.toString().length < 2) {
      month = '0${date.month.toString()}';
    } else {
      month = date.month.toString();
    }

    if (date.day.toString().length < 2) {
      day = '0${date.day.toString()}';
    } else {
      day = date.day.toString();
    }

    return '$day-$month-$year';
  }

  static String parseChatDate(String date) {
    String today = DateFormat("EEE, MMM d, y").format(DateTime.now());
    String yesterday = DateFormat("EEE, MMM d, y")
        .format(DateTime.now().add(const Duration(days: -1)));

    final msgDate = DateTime.tryParse(date);
    if (msgDate == null) return 'Today';
    String dateString = DateFormat("EEE, MMM d, y").format(msgDate);
    if (today == dateString) {
      return "Today";
    } else if (yesterday == dateString) {
      return "Yesterday";
    } else {
      return dateString;
    }
  }

  static String parseChatTime(String time) {
    final msgTime = DateTime.tryParse(time);
    if (msgTime == null) {
      return 'now';
    } else {
      return DateFormat('jm').format(msgTime).toLowerCase();
    }
  }

  static String parseUserLastSeen(String date) {
    final dateTime = DateTime.tryParse(date);
    if (dateTime == null) return 'now';
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays > 1) {
      return 'about ${diff.inDays.toString()} days ago';
    } else if (diff.inHours == 1) {
      return 'about ${diff.inHours.toString()} hour ago';
    } else if (diff.inHours > 1) {
      return 'about ${diff.inHours.toString()} hours ago';
    } else if (diff.inMinutes >= 1) {
      return 'about ${diff.inMinutes.toString()} min ago';
    } else if (diff.inSeconds > 1) {
      return 'now';
    } else {
      return 'now';
    }
  }



  static Widget renderProfilePicture(String? profilePicture,
      {double size = 35}) {
    if (profilePicture == null) {
      return ImagePlaceholder(
        width: getScreenWidth(size),
        height: getScreenHeight(size),
      );
    } else {
      return RecipientProfilePicture(
        width: getScreenWidth(size),
        height: getScreenHeight(size),
        border: Border.all(color: Colors.grey.shade50, width: 3.0),
        imageUrl: profilePicture,
      );
    }
  }

  static Widget renderRecommendPicture(String? profilePicture,
      {double size = 35}) {
    if (profilePicture == null) {
      return ImagePlaceholder(
        width: getScreenWidth(size),
        height: getScreenHeight(size),
      );
    } else {
      return RecommendPicture(
        width: getScreenWidth(size),
        height: getScreenHeight(size),
        border: Border.all(color: Colors.grey.shade50, width: 3.0),
        imageUrl: profilePicture,
      );
    }
  }

  static iterate(String currentSelected, List<String> options) {
    for (var i = 0; i < options.length; i++) {
      if (options[i] == currentSelected) {
        if (i == options.length - 1) {
          currentSelected = options[0];
        } else {
          currentSelected = options[i + 1];
        }
        break;
      }
    }
  }

  static TextStyle getFont(String font) {
    switch (font) {
      case 'inter':
        return GoogleFonts.inter(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
      case 'poppins':
        return GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
      case 'amita':
        return GoogleFonts.amita(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
      default:
        return GoogleFonts.inter(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
    }
  }

  static Map<String, dynamic> getAlignment(String align) {
    switch (align) {
      case 'left':
        return {
          'align': TextAlign.left,
          'align_icon': Icons.format_align_left_rounded,
        };

      case 'right':
        return {
          'align': TextAlign.right,
          'align_icon': Icons.format_align_right_rounded,
        };

      case 'center':
        return {
          'align': TextAlign.center,
          'align_icon': Icons.format_align_center_rounded,
        };

      case 'justify':
        return {
          'align': TextAlign.justify,
          'align_icon': Icons.format_align_justify_rounded,
        };

      default:
        return {
          'align': TextAlign.center,
          'align_icon': Icons.format_align_center_rounded,
        };
    }
  }

  static Color convertStringToColour(String colour) {
    String valueString =
        colour.replaceFirst('0', '').replaceAll('x', ''); //0xff0077b6
    int value = int.parse(valueString, radix: 16);
    Console.log('value:', value);
    return Color(value);
  }

  static Color getStatusBgColour(String colour) {
    switch (colour.toLowerCase()) {
      case '0xff0077b6':
        return const Color(0xFF0077B6);
      case '0xff25b900':
        return const Color(0xFF25B900);
      case '0xfffe9800':
        return const Color(0xFFFE9800);
      case '0xffc12626':
        return const Color(0xFFC12626);
      default:
        return const Color(0xFFC12626);
    }
  }

  static Widget renderPostImages(PostModel post, BuildContext context) {
    int imageLength = post.imageMediaItems!.length;
    if (post.imageMediaItems!.length > 4) {
      int remImageLength = imageLength - 4;
      return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 178 / 164,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          shrinkWrap: true,
          itemCount: (post.imageMediaItems!.length - remImageLength),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                RouteNavigators.route(
                  context,
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: getScreenHeight(300),
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  index == 3
                      ? Container(
                          alignment: Alignment.center,
                          height: getScreenHeight(50),
                          width: getScreenWidth(50),
                          decoration:
                             BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black38),
                          child: Text(
                            "+ $remImageLength",
                            style: TextStyle(
                                fontSize: getScreenHeight(28),
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          });
    } else if(post.imageMediaItems!.length == 1){
         return GestureDetector(
          onTap: (() =>    RouteNavigators.route(
                  context,
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                )
              ),
          child: Container(
            height: getScreenHeight(300),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: post.imageMediaItems![0],
              fit: BoxFit.cover,
            ),
          ),
        );
    }    
    else if (post.imageMediaItems!.length == 3) {
      int remImageLength =
          1; // length of extra image not seen in the grid at first
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: (() =>   RouteNavigators.route(
                  context,
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                )
                    ),
                child: Container(
                  height: getScreenHeight(300),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: post.imageMediaItems![0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: getScreenWidth(5)),
            Column(
              mainAxisSize: MainAxisSize.min,

              ///crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: (() => RouteNavigators.route(
                        context,
                        PhotoView(
                          imageProvider: NetworkImage(post.imageMediaItems![1]),
                          loadingBuilder: (context, event) => const Center(
                            child:
                                CupertinoActivityIndicator(color: Colors.white),
                          ),
                        ),
                      )),
                  child: Container(
                    height: getScreenHeight(150),
                    width: getScreenWidth(180),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: getScreenHeight(5)),
                GestureDetector(
                  onTap: (() => RouteNavigators.route(
                        context,
                        PhotoView(
                          imageProvider: NetworkImage(post.imageMediaItems![2]),
                          loadingBuilder: (context, event) => const Center(
                            child:
                                CupertinoActivityIndicator(color: Colors.white),
                          ),
                        ),
                      )),
                  child: Container(
                    height: getScreenHeight(150),
                    width: getScreenWidth(180),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![2],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )
          ],
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
          itemCount: post.imageMediaItems!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (() => RouteNavigators.route(
                    context,
                     ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
              )),
              child: Container(
                height: getScreenHeight(300),
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: post.imageMediaItems![index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          });
    }

    
    /*
       return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 178 / 164,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          shrinkWrap: true,
          itemCount: (post.imageMediaItems!.length - remImageLength),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                RouteNavigators.route(
                  context,
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(
                      height: getScreenHeight(300),
                      margin: const EdgeInsets.only(top: 50),
                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index]),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: getScreenHeight(300),
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  index == 1
                      ? Container(
                          alignment: Alignment.center,
                          height: getScreenHeight(50),
                          width: getScreenWidth(50),
                          decoration:
                              const BoxDecoration(color: Colors.black38),
                          child: Text(
                            "+ $remImageLength",
                            style: TextStyle(
                                fontSize: getScreenHeight(28),
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          });
    
    */
    // switch (post.imageMediaItems!.length) {
    //   case 1:
    //     return GestureDetector(
    //       onTap: (() => RouteNavigators.route(
    //             context,
    //             PhotoView(
    //               imageProvider: NetworkImage(post.imageMediaItems![0]),
    //               loadingBuilder: (context, event) => const Center(
    //                 child: CupertinoActivityIndicator(color: Colors.white),
    //               ),
    //             ),
    //           )),
    //       child: Container(
    //         height: getScreenHeight(300),
    //         clipBehavior: Clip.hardEdge,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(15),
    //         ),
    //         child: CachedNetworkImage(
    //           imageUrl: post.imageMediaItems![0],
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     );

    //   case 3:
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Flexible(
    //           child: GestureDetector(
    //             onTap: (() => RouteNavigators.route(
    //                   context,
    //                   PhotoView(
    //                     imageProvider: NetworkImage(post.imageMediaItems![0]),
    //                     loadingBuilder: (context, event) => const Center(
    //                       child:
    //                           CupertinoActivityIndicator(color: Colors.white),
    //                     ),
    //                   ),
    //                 )),
    //             child: Container(
    //               height: getScreenHeight(300),
    //               clipBehavior: Clip.hardEdge,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: CachedNetworkImage(
    //                 imageUrl: post.imageMediaItems![0],
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //           ),
    //         ),
    //         SizedBox(width: getScreenWidth(5)),
    //         Column(
    //           mainAxisSize: MainAxisSize.min,

    //           ///crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             GestureDetector(
    //               onTap: (() => RouteNavigators.route(
    //                     context,
    //                     PhotoView(
    //                       imageProvider: NetworkImage(post.imageMediaItems![1]),
    //                       loadingBuilder: (context, event) => const Center(
    //                         child:
    //                             CupertinoActivityIndicator(color: Colors.white),
    //                       ),
    //                     ),
    //                   )),
    //               child: Container(
    //                 height: getScreenHeight(150),
    //                 width: getScreenWidth(180),
    //                 clipBehavior: Clip.hardEdge,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(15),
    //                 ),
    //                 child: CachedNetworkImage(
    //                   imageUrl: post.imageMediaItems![1],
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: getScreenHeight(5)),
    //             GestureDetector(
    //               onTap: (() => RouteNavigators.route(
    //                     context,
    //                     PhotoView(
    //                       imageProvider: NetworkImage(post.imageMediaItems![2]),
    //                       loadingBuilder: (context, event) => const Center(
    //                         child:
    //                             CupertinoActivityIndicator(color: Colors.white),
    //                       ),
    //                     ),
    //                   )),
    //               child: Container(
    //                 height: getScreenHeight(150),
    //                 width: getScreenWidth(180),
    //                 clipBehavior: Clip.hardEdge,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(15),
    //                 ),
    //                 child: CachedNetworkImage(
    //                   imageUrl: post.imageMediaItems![2],
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     );
    //   default:
    //     return Wrap(
    //       runSpacing: getScreenHeight(5),
    //       spacing: getScreenHeight(5),
    //       alignment: WrapAlignment.spaceBetween,
    //       children: [
    //         for (var i = 0; i < post.imageMediaItems!.length; i++)
    //           GestureDetector(
    //             onTap: () => RouteNavigators.route(
    //                 context,
    //                 PhotoView(
    //                   imageProvider: NetworkImage(
    //                     post.imageMediaItems![i],
    //                   ),
    //                 )),
    //             child: SizedBox(
    //               width: getScreenWidth(170),
    //               height: getScreenHeight(152),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(10),
    //                 child: Image.network(
    //                   post.imageMediaItems![i],
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //           ),
    //       ],
    //     );
    // }
  }


  static Widget renderSavedPostImages(SavePostModel post, BuildContext context) {
    int imageLength = post.imageMediaItems!.length;
    if (post.imageMediaItems!.length > 4) {
      int remImageLength = imageLength - 4;
      return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 178 / 164,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          shrinkWrap: true,
          itemCount: (post.imageMediaItems!.length - remImageLength),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                RouteNavigators.route(
                  context,
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: getScreenHeight(300),
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  index == 3
                      ? Container(
                          alignment: Alignment.center,
                          height: getScreenHeight(50),
                          width: getScreenWidth(50),
                          decoration:
                             BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black38),
                          child: Text(
                            "+ $remImageLength",
                            style: TextStyle(
                                fontSize: getScreenHeight(28),
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          });
    } else if(post.imageMediaItems!.length == 1){
         return GestureDetector(
          onTap: (() =>    RouteNavigators.route(
                  context,
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                )
              ),
          child: Container(
            height: getScreenHeight(300),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: post.imageMediaItems![0],
              fit: BoxFit.cover,
            ),
          ),
        );
    }    
    else if (post.imageMediaItems!.length == 3) {
      int remImageLength =
          1; // length of extra image not seen in the grid at first
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: (() =>   RouteNavigators.route(
                  context,
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                )
                    ),
                child: Container(
                  height: getScreenHeight(300),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: post.imageMediaItems![0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: getScreenWidth(5)),
            Column(
              mainAxisSize: MainAxisSize.min,

              ///crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: (() => RouteNavigators.route(
                        context,
                        PhotoView(
                          imageProvider: NetworkImage(post.imageMediaItems![1]),
                          loadingBuilder: (context, event) => const Center(
                            child:
                                CupertinoActivityIndicator(color: Colors.white),
                          ),
                        ),
                      )),
                  child: Container(
                    height: getScreenHeight(150),
                    width: getScreenWidth(180),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: getScreenHeight(5)),
                GestureDetector(
                  onTap: (() => RouteNavigators.route(
                        context,
                        PhotoView(
                          imageProvider: NetworkImage(post.imageMediaItems![2]),
                          loadingBuilder: (context, event) => const Center(
                            child:
                                CupertinoActivityIndicator(color: Colors.white),
                          ),
                        ),
                      )),
                  child: Container(
                    height: getScreenHeight(150),
                    width: getScreenWidth(180),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![2],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )
          ],
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
          itemCount: post.imageMediaItems!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (() => RouteNavigators.route(
                    context,
                     ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(                 
                       decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
                    //clipBehavior: Clip.hardEdge,
                      width: MediaQuery.of(context).size.width,
                      //height:MediaQuery.of(context).size.height ,
                      margin: const EdgeInsets.only(right: 50),

                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index],),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
              )),
              child: Container(
                height: getScreenHeight(300),
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: post.imageMediaItems![index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          });
    }

    
    /*
       return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 178 / 164,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          shrinkWrap: true,
          itemCount: (post.imageMediaItems!.length - remImageLength),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                RouteNavigators.route(
                  context,
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: imageLength,
                    itemBuilder: (context, index) => Container(
                      height: getScreenHeight(300),
                      margin: const EdgeInsets.only(top: 50),
                      child: PhotoView(
                          imageProvider:
                              NetworkImage(post.imageMediaItems![index]),
                          loadingBuilder: (context, event) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )),
                    ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: getScreenHeight(300),
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: CachedNetworkImage(
                      imageUrl: post.imageMediaItems![index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  index == 1
                      ? Container(
                          alignment: Alignment.center,
                          height: getScreenHeight(50),
                          width: getScreenWidth(50),
                          decoration:
                              const BoxDecoration(color: Colors.black38),
                          child: Text(
                            "+ $remImageLength",
                            style: TextStyle(
                                fontSize: getScreenHeight(28),
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          });
    
    */
    // switch (post.imageMediaItems!.length) {
    //   case 1:
    //     return GestureDetector(
    //       onTap: (() => RouteNavigators.route(
    //             context,
    //             PhotoView(
    //               imageProvider: NetworkImage(post.imageMediaItems![0]),
    //               loadingBuilder: (context, event) => const Center(
    //                 child: CupertinoActivityIndicator(color: Colors.white),
    //               ),
    //             ),
    //           )),
    //       child: Container(
    //         height: getScreenHeight(300),
    //         clipBehavior: Clip.hardEdge,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(15),
    //         ),
    //         child: CachedNetworkImage(
    //           imageUrl: post.imageMediaItems![0],
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     );

    //   case 3:
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Flexible(
    //           child: GestureDetector(
    //             onTap: (() => RouteNavigators.route(
    //                   context,
    //                   PhotoView(
    //                     imageProvider: NetworkImage(post.imageMediaItems![0]),
    //                     loadingBuilder: (context, event) => const Center(
    //                       child:
    //                           CupertinoActivityIndicator(color: Colors.white),
    //                     ),
    //                   ),
    //                 )),
    //             child: Container(
    //               height: getScreenHeight(300),
    //               clipBehavior: Clip.hardEdge,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: CachedNetworkImage(
    //                 imageUrl: post.imageMediaItems![0],
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //           ),
    //         ),
    //         SizedBox(width: getScreenWidth(5)),
    //         Column(
    //           mainAxisSize: MainAxisSize.min,

    //           ///crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             GestureDetector(
    //               onTap: (() => RouteNavigators.route(
    //                     context,
    //                     PhotoView(
    //                       imageProvider: NetworkImage(post.imageMediaItems![1]),
    //                       loadingBuilder: (context, event) => const Center(
    //                         child:
    //                             CupertinoActivityIndicator(color: Colors.white),
    //                       ),
    //                     ),
    //                   )),
    //               child: Container(
    //                 height: getScreenHeight(150),
    //                 width: getScreenWidth(180),
    //                 clipBehavior: Clip.hardEdge,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(15),
    //                 ),
    //                 child: CachedNetworkImage(
    //                   imageUrl: post.imageMediaItems![1],
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: getScreenHeight(5)),
    //             GestureDetector(
    //               onTap: (() => RouteNavigators.route(
    //                     context,
    //                     PhotoView(
    //                       imageProvider: NetworkImage(post.imageMediaItems![2]),
    //                       loadingBuilder: (context, event) => const Center(
    //                         child:
    //                             CupertinoActivityIndicator(color: Colors.white),
    //                       ),
    //                     ),
    //                   )),
    //               child: Container(
    //                 height: getScreenHeight(150),
    //                 width: getScreenWidth(180),
    //                 clipBehavior: Clip.hardEdge,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(15),
    //                 ),
    //                 child: CachedNetworkImage(
    //                   imageUrl: post.imageMediaItems![2],
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     );
    //   default:
    //     return Wrap(
    //       runSpacing: getScreenHeight(5),
    //       spacing: getScreenHeight(5),
    //       alignment: WrapAlignment.spaceBetween,
    //       children: [
    //         for (var i = 0; i < post.imageMediaItems!.length; i++)
    //           GestureDetector(
    //             onTap: () => RouteNavigators.route(
    //                 context,
    //                 PhotoView(
    //                   imageProvider: NetworkImage(
    //                     post.imageMediaItems![i],
    //                   ),
    //                 )),
    //             child: SizedBox(
    //               width: getScreenWidth(170),
    //               height: getScreenHeight(152),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(10),
    //                 child: Image.network(
    //                   post.imageMediaItems![i],
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //           ),
    //       ],
    //     );
    // }
  }

}
