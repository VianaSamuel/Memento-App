import 'package:flutter/material.dart';

class AppControler extends ChangeNotifier {
  static AppControler instance = AppControler();

  bool isDartTheme = false;
  chageTheme() {
    isDartTheme = !isDartTheme;
    notifyListeners();
  }
}
