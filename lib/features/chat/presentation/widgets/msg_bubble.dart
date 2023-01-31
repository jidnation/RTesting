import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/widgets/audio_player.dart';
import 'package:reach_me/features/home/presentation/views/full_post.dart';
import 'package:reach_me/features/home/presentation/views/status/status_view_page.dart';

class MsgBubble extends StatelessWidget {
  const MsgBubble(
      {Key? key,
      required this.msgDate,
      required this.isMe,
      required this.label,
      required this.size,
      required this.timeStamp,
      this.quotedData,
      required this.chat})
      : super(key: key);

  final Size size;
  final String msgDate;
  final bool isMe;
  final String label;
  final String timeStamp;
  final String? quotedData;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    String quotedTitle = '';
    Map? map;
    if (chat.quotedFromPost != null) {
      map = jsonDecode(quotedData!);
      if (chat.quotedFromPost ?? false) {
        quotedTitle =
            isMe ? 'You reached out to a post' : 'Reached out to your post';
      } else {
        quotedTitle =
            isMe ? 'You reached our to a status' : 'Reached out to your status';
      }
    }
    bool isMedia = (label.contains('jpg') || label.contains('aac'));

    // return Stack(
    //   clipBehavior: Clip.none,
    //   alignment: AlignmentDirectional.bottomStart,
    //   children: [
    //     Visibility(
    //       visible: quotedData != null,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.only(right: 12),
    //             child: Text(
    //               quotedTitle,
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //               style: TextStyle(
    //                 fontSize: 12,
    //                 color: AppColors.greyShade3,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             margin: EdgeInsets.only(bottom: 16),
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    //             constraints: BoxConstraints(maxWidth: size.width / 1.5),
    //             decoration: BoxDecoration(
    //                 border: Border.all(
    //                     color: AppColors.primaryColor.withOpacity(0.5)),
    //                 borderRadius: BorderRadius.circular(20),
    //                 color: isMe ? AppColors.white : AppColors.grey),
    //             child: Text(quotedContent,
    //                 maxLines: 3,
    //                 overflow: TextOverflow.ellipsis,
    //                 textAlign: TextAlign.left,
    //                 style: TextStyle(
    //                   fontSize: 14,
    //                   fontWeight: FontWeight.w400,
    //                   color: AppColors.primaryColor.withOpacity(0.5),
    //                 )),
    //           ),
    //         ],
    //       ),
    //     ),
    //     quotedData == null
    //         ? Container(child: mainMessage(context))
    //         : mainMessage(context)
    //   ],
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: quotedData != null,
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: isMe
                    ? const EdgeInsets.only(right: 12)
                    : const EdgeInsets.only(left: 12),
                child: Text(
                  quotedTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textColor5,
                  ),
                ),
              ),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              //   constraints: BoxConstraints(maxWidth: size.width / 1.37),
              //   decoration: BoxDecoration(
              //       border: Border.all(
              //           color: AppColors.primaryColor.withOpacity(0.5)),
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(20),
              //         bottomLeft: Radius.circular(20),
              //         topRight: Radius.circular(20),
              //       ),
              //       color: isMe ? AppColors.white : AppColors.grey),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(quotedContent,
              //             maxLines: 3,
              //             overflow: TextOverflow.ellipsis,
              //             textAlign: TextAlign.left,
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: AppColors.primaryColor.withOpacity(0.5),
              //             )),
              //       ),
              //     ],
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  if (chat.quotedFromPost == null) return;
                  if (chat.quotedFromPost!) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => FullPostScreen(
                              postFeedModel: chat.quotedPost,
                            )));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => StatusViewPage(
                              status: [chat.quotedStatus!],
                              isMuted: false,
                            )));
                  }
                },
                child: Bubble(
                  alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                  nip: (isMedia)
                      ? null
                      : isMe
                          ? BubbleNip.rightBottom
                          : BubbleNip.leftBottom,
                  showNip: !(isMedia),
                  color: isMe
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : AppColors.greyShade10.withOpacity(0.5),
                  radius: Radius.circular(isMedia ? 15 : 20),
                  nipOffset: 0,
                  nipHeight: 17,
                  elevation: 0,
                  borderColor: AppColors.greyShade5,
                  borderWidth: 1,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: size.width / 1.5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      textBaseline: TextBaseline.ideographic,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            chat.quotedContent ?? 'Nothing found',
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isMe
                                  ? AppColors.textColor5
                                  : AppColors.textColor5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        quotedData == null
            ? Container(child: mainMessage(context))
            : mainMessage(context)
      ],
    );
  }

  Widget mainMessage(BuildContext context) {
    if (label.contains('jpg')) {
      return GestureDetector(
        onTap: () {
          RouteNavigators.route(
              context, PhotoView(imageProvider: NetworkImage(label)));
        },
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(top: quotedData == null ? 10 : 0),
            // margin: EdgeInsets.only(right: quotedData == null ? 0 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            constraints: BoxConstraints(
              maxWidth: size.width * .5,
              maxHeight: size.height * .4,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/blank-dp.png',
                image: label,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else if (label.contains('aac')) {
      return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              height: 55,
              // width: 220,
              clipBehavior: Clip.hardEdge,
              constraints: BoxConstraints(
                maxWidth: size.width * .56,
              ),
              padding: const EdgeInsets.only(
                top: 3,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isMe ? AppColors.primaryColor : AppColors.white),
              child: PlayAudio(
                audioFile: label,
                isMe: isMe,
                timeStamp: timeStamp,
              )));
    }
    return Column(
      children: [
        // SizedBox(
        //   width: getScreenWidth(130),
        //   height: getScreenHeight(41),
        //   child: CustomButton(
        //     label: msgDate,
        //     color: AppColors.white,
        //     onPressed: (){},
        //     size: size,
        //     padding: const EdgeInsets.symmetric(
        //       vertical: 9,
        //       horizontal: 21,
        //     ),
        //     textColor: const Color(0xFF767474),
        //     borderSide: BorderSide.none,
        //   ),
        // ),
        Bubble(
          // margin: const BubbleEdges.only(top: 10),
          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
          nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
          color: isMe ? AppColors.primaryColor : AppColors.white,
          borderColor: Colors.transparent,
          // shadowColor: Colors.transparent,
          radius: const Radius.circular(20),
          nipOffset: 0,
          nipHeight: 17,
          borderWidth: 0,
          margin: BubbleEdges.only(top: 1),
          child: Container(
            constraints: BoxConstraints(maxWidth: size.width / 1.5),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isMe ? AppColors.white : AppColors.textColor2,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    timeStamp,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: isMe ? AppColors.white : AppColors.textColor2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
