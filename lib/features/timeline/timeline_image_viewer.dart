import 'package:flutter/material.dart';

class TimeLineImageViewer extends StatelessWidget {
  final String imageUrl;
  const TimeLineImageViewer({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 300,
              )),
        ),
      ],
    );
  }
}
