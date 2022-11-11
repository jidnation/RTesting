import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    Key? key,
    this.width = 100,
    this.height = 100,
    this.fontSize = 10,
    this.border,
  }) : super(key: key);

  final double height, width, fontSize;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(3),
      height: height,
      width: width,
      decoration: BoxDecoration(
        //  border: border,
        shape: BoxShape.circle,
        color: Colors.grey.shade50,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: FittedBox(
            child: Image.asset(
          'assets/images/blank-dp.png',
          fit: BoxFit.cover,
          gaplessPlayback: true,
        )),
      ),
    );
  }
}

class CoverImagePlaceholder extends StatelessWidget {
  const CoverImagePlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/cover.png',
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }
}
