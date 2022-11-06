import 'package:flutter/material.dart';

abstract class IDialogAndSheetService {
  Future<bool> showYesNoDialog<T>(
      {required BuildContext context,
      required String yesLabel,
      required String noLabel,
      required String message});
}
