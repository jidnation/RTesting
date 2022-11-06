import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

import '../../utils/dimensions.dart';
import 'i_dialog_and_sheet_service.dart';

class DialogAndSheetService extends IDialogAndSheetService {
  @override
  Future<bool> showYesNoDialog<T>(
      {required BuildContext context,
      required String yesLabel,
      required String noLabel,
      required String message}) async {
    return await showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        insetPadding: EdgeInsets.symmetric(horizontal: 100),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        backgroundColor: AppColors.white,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: getScreenHeight(16),
                  color: const Color(0xFF767474)),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    noLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: getScreenHeight(16),
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    yesLabel,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: getScreenHeight(16),
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
  // @override
  // Future<T> showAppBottomSheet<T>(Widget child) async {
  //   return await showModalBottomSheet(
  //     context: _router.navigatorKey.currentContext!,
  //     backgroundColor: AppColors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(12),
  //       ),
  //     ),
  //     builder: (context) => child,
  //   );
  // }

}
