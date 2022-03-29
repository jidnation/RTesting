import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
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
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
      color: AppColors.white,
      borderColor: const Color(0xFFE1E1E1),
      borderWidth: 2,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width / 1.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textBaseline: TextBaseline.ideographic,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor2,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeStamp,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor2),
                )),
          ],
        ),
      ),
    );
  }
}