import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(
      {Key? key,
      this.width = 50,
      this.height = 50,
      this.imgUrl = 'assets/images/user.png',
      this.border})
      : super(key: key);

  final double width;
  final double height;
  final String imgUrl;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor,
        border: border ?? Border.all(color: Colors.transparent, width: 0.0),
        image: DecorationImage(
          image: AssetImage(imgUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
