import 'package:flutter/material.dart';

import '../../../../core/utils/custom_text.dart';

class VideoLoader extends StatelessWidget {
  const VideoLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      CircularProgressIndicator(),
      SizedBox(height: 10),
      CustomText(
        text: 'Loading...',
        color: Colors.white,
        weight: FontWeight.w600,
      )
    ]);
  }
}
