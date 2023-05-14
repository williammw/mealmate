import 'package:flutter/foundation.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void changeLanguage(String newLanguage) {
    _currentLanguage = newLanguage;
    notifyListeners();
  }
}
