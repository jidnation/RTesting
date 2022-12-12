import 'package:flutter/material.dart';

class CustomBottomSheet {
  static void open(context, {required Widget child}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return child;
      },
    );
  }
}
