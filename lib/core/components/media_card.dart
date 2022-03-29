import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/utils/constants.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    Key? key,
    this.height = 152,
    this.width = 152,
    this.isPhoto = false,
    this.isVideo = true,
   
    required this.size,
  }) : super(key: key);

  final Size size;
  final double width;
  final double height;
  final bool isVideo;
  final bool isPhoto;
  // final double leftPosition;
  // final double bottomPosition;

  @override
  Widget build(BuildContext context) {
    if (isVideo) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height,
            width: width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                  image: AssetImage('assets/images/post.png'),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0x80000000),
                  offset: Offset(0, 0),
                  blurRadius: 7,
                  spreadRadius: 0)
            ]),
            child: SvgPicture.asset('assets/svgs/video play.svg',
                color: AppColors.white,
                height: size.width * 0.15,
                width: size.width * 0.15),
          ),
        ],
      );
    }
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: const DecorationImage(
            image: AssetImage('assets/images/post.png'), fit: BoxFit.fitHeight),
      ),
    );
  }
}
