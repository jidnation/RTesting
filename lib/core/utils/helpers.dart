import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/utils/constants.dart';
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

  static iterate(String currentSelected, List<String> options) {
    for (var i = 0; i < options.length; i++) {
      if (options[i] == currentSelected) {
        if (i == options.length - 1) {
          currentSelected = options[0];
        } else {
          currentSelected = options[i + 1];
        }
        break;
      }
    }
  }

  static TextStyle getFont(String font) {
    switch (font) {
      case 'inter':
        return GoogleFonts.inter(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
      case 'poppins':
        return GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
      case 'amita':
        return GoogleFonts.amita(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
      default:
        return GoogleFonts.inter(
          color: AppColors.white,
          fontSize: getScreenHeight(23),
          fontWeight: FontWeight.w500,
        );
    }
  }

  static Map<String, dynamic> getAlignment(String align) {
    switch (align) {
      case 'left':
        return {
          'align': TextAlign.left,
          'align_icon': Icons.format_align_left_rounded,
        };

      case 'right':
        return {
          'align': TextAlign.right,
          'align_icon': Icons.format_align_right_rounded,
        };

      case 'center':
        return {
          'align': TextAlign.center,
          'align_icon': Icons.format_align_center_rounded,
        };

      case 'justify':
        return {
          'align': TextAlign.justify,
          'align_icon': Icons.format_align_justify_rounded,
        };

      default:
        return {
          'align': TextAlign.center,
          'align_icon': Icons.format_align_center_rounded,
        };
    }
  }
}
