import 'package:flutter/material.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';

class Helper {
  static String parseDate(DateTime? date) {
    String? day = '', month = '';
    final year = date!.year.toString();
    if (date.month.toString().length < 2) {
      month = '0${date.month.toString()}';
    } else {
      month = date.month.toString();
    }

    if (date.day.toString().length < 2) {
      day = '0${date.day.toString()}';
    } else {
      day = date.day.toString();
    }

    return '$day-$month-$year';
  }

  static String parseChatDate(String date) {
    final dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return '${diff.inSeconds}s';
    }
  }

  static Widget renderProfilePicture(String? profilePicture,
      {double size = 35}) {
    if (profilePicture == null) {
      return ImagePlaceholder(
        width: getScreenWidth(size),
        height: getScreenHeight(size),
      );
    } else {
      return ProfilePicture(
        width: getScreenWidth(size),
        height: getScreenHeight(size),
        border: Border.all(color: Colors.grey.shade50, width: 3.0),
      );
    }
  }
}
