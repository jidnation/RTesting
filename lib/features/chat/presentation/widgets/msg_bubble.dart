import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';

class MsgBubble extends StatelessWidget {
  const MsgBubble({
    Key? key,
    required this.isMe,
    required this.label,
    required this.size,
    required this.timeStamp,
  }) : super(key: key);

  final Size size;
  final bool isMe;
  final String label;
  final String timeStamp;

  @override
  Widget build(BuildContext context) {
    if (label.contains('amazon')) {
      return GestureDetector(
        onTap: (){
          RouteNavigators.route(context, PhotoView(imageProvider: NetworkImage(label)));
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
    }
    return Bubble(
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
                )),
          ],
        ),
      ),
    );
  }
}
