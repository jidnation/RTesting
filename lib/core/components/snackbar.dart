import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/dimensions.dart';

class Snackbars {
  static success(
    BuildContext context, {
    required String message,
    int milliseconds = 5000,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message,
          style: TextStyle(color: Colors.white, fontSize: getScreenHeight(14)),
        ),
      ),
    );
  }

  static void error(
    BuildContext context, {
    String? message,
    int milliseconds = 5000,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF647C),
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message ?? 'An error occured',
          style: TextStyle(color: Colors.white, fontSize: getScreenHeight(14)),
        ),
      ),
    );
  }
}
