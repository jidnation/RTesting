import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';

class RMSpinner extends StatelessWidget {
  const RMSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/gifs/spinner.json'),
    );
  }
}

class RMLoader {
  static show(BuildContext context) {
    return Loader.show(context,
        progressIndicator: const RMSpinner(), overlayColor: Colors.white30);
  }

  static hide() {
    return Loader.hide();
  }
}

class LinearLoader extends StatelessWidget {
  const LinearLoader({Key? key, this.color = AppColors.primaryColor})
      : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: color,
      backgroundColor: color.withOpacity(0.2),
      minHeight: getScreenHeight(2.5),
    );
  }
}

class CircularLoader extends StatelessWidget {
  const CircularLoader({Key? key, this.color = AppColors.black})
      : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? SizedBox(
              width: getScreenWidth(20),
              height: getScreenHeight(20),
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: 2.5,
                //backgroundColor: AppColors.primaryColorFade,
              ),
            )
          : CupertinoActivityIndicator(color: color),
    );
  }
}
