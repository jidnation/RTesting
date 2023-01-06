import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reach_me/core/utils/dimensions.dart';

class Snackbars {
  static error(
    BuildContext context, {
    required String? message,
    int milliseconds = 3000,
  }) {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFDDDD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD83333), width: 0.5),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: getScreenWidth(16),
                vertical: getScreenHeight(25),
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: getScreenWidth(14),
                  vertical: getScreenHeight(10)),
              child: Row(
                children: [
                  Icon(
                    Icons.not_interested_rounded,
                    color: const Color(0xFFD83333),
                    size: getScreenHeight(24),
                  ),
                  SizedBox(width: getScreenWidth(21)),
                  Flexible(
                    child: Text(
                      message ?? 'Something went wrong',
                      style: TextStyle(
                        color: const Color(0xFFD83333),
                        fontSize: getScreenHeight(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      duration: Duration(milliseconds: milliseconds),
      context: context,
    );
  }

  static void success(
    BuildContext context, {
    String? message,
    int milliseconds = 3000,
  }) {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE0FFDD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1C8B43), width: 0.5),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: getScreenWidth(16),
                vertical: getScreenHeight(25),
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: getScreenWidth(14),
                  vertical: getScreenHeight(10)),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svgs/like.svg',
                    color: const Color(0xFF1C8B43),
                  ),
                  SizedBox(width: getScreenWidth(21)),
                  Flexible(
                    child: Text(
                      message ?? 'Something went wrong',
                      style: TextStyle(
                        color: const Color(0xFF1C8B43),
                        fontSize: getScreenHeight(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      duration: Duration(milliseconds: milliseconds),
      context: context,
    );
  }
}
