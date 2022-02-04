
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int currentIndex = 0;
  void toggle(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
