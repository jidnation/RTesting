import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/chat/presentation/widgets/audio_player.dart';

class MsgBubble extends StatelessWidget {
  const MsgBubble(
      {Key? key,
      required this.msgDate,
      required this.isMe,
      required this.label,
      required this.size,
      required this.timeStamp,
      this.quotedData})
      : super(key: key);

  final Size size;
  final String msgDate;
  final bool isMe;
  final String label;
  final String timeStamp;
  final String? quotedData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(
        //         Icons.view_timeline_outlined,
        //         color: AppColors.primaryColor,
        //         size: 20,
        //       ),
        //       // Icon(
        //       //   Icons.feed_rounded,
        //       //   color: AppColors.primaryColor,
        //       //   size: 20,
        //       // ),
        //       Container(
        //         // clipBehavior: Clip.hardEdge,
        //         padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        //         margin: const EdgeInsets.only(right: 12, left: 4),
        //         constraints: BoxConstraints(
        //           maxWidth: size.width * .7,
        //           maxHeight: size.height * .4,
        //         ),
        //         decoration: BoxDecoration(
        //             border: Border.all(color: AppColors.primaryColor),
        //             borderRadius: BorderRadius.circular(15),
        //             color: isMe ? AppColors.white : AppColors.grey),
        //         // child: Row(
        //         //   mainAxisSize: MainAxisSize.min,
        //         //   children: [
        //         //     Icon(
        //         //       Icons.photo,
        //         //       color: AppColors.primaryColor.withOpacity(0.5),
        //         //       size: 20,
        //         //     ),
        //         //     Text(' Image Media',
        //         //         style: TextStyle(
        //         //             color: AppColors.primaryColor.withOpacity(0.5),
        //         //             fontStyle: FontStyle.normal)),
        //         //   ],
        //         // ),
        //         child: Row(
        //           children: [
        //             // Text('Status ',
        //             //     maxLines: 1,
        //             //     overflow: TextOverflow.ellipsis,
        //             //     style: TextStyle(
        //             //         color: AppColors.primaryColor.withOpacity(0.5),
        //             //         fontWeight: FontWeight.w600,
        //             //         fontStyle: FontStyle.italic)),
        //             Expanded(
        //               child: Text(
        //                   'On getting to the side of the road, all I could imagine running in my brain was the ministry of Charles and Frances Hunter. There and then I held the boy\'s feeble legs, the feet and the legs felt very light and lifeless in my hands.',
        //                   maxLines: 1,
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                       color: AppColors.primaryColor.withOpacity(0.5),
        //                       fontStyle: FontStyle.italic)),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Container(margin: EdgeInsets.only(top: 0), child: mainMessage(context))
        // Positioned(top: 32, right: 16, child: mainMessage(context))
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
            padding: const EdgeInsets.only(top: 10),
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
      //print('This is the lable link $label');
      return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              height: 55,
              width: 220,
              clipBehavior: Clip.hardEdge,
              //padding:
              //const EdgeInsets.only(top: 7, left: 2, right: 4, bottom: 13),
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.only(top: 5, bottom: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isMe ? AppColors.primaryColor : AppColors.grey),
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
          margin: const BubbleEdges.only(top: 10),
          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
          nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
          color: isMe ? AppColors.primaryColor : AppColors.white,
          borderColor: Colors.transparent,
          shadowColor: Colors.transparent,
          radius: const Radius.circular(20),
          nipOffset: 0,
          nipHeight: 17,
          borderWidth: 0,
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
