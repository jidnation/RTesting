import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dimensions.dart';

class CustomDialog {
  static openDialogBox(
      {required Widget child, double? height, double? width, bool? barrierD}) {
    return Get.dialog(
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Card(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Container(
            height: height ?? 358,
            width: width ?? SizeConfig.screenWidth * 0.9,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
        )
      ]),
      barrierDismissible: barrierD ?? true,
    );
  }
}
