import 'package:flutter/material.dart';

class DragState with ChangeNotifier {
  bool _dragging = false;

  bool get dragging => _dragging;

  void startDragging() {
    _dragging = true;
    notifyListeners();
  }

  void endDragging() {
    _dragging = false;
    notifyListeners();
  }
}
