import 'package:flutter/material.dart';

class TabIndexNotifier extends ChangeNotifier {
  int _tabIndex = 0;

  int get tabIndex => _tabIndex; // Add this getter

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}
