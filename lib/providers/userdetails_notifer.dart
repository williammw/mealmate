import 'package:flutter/material.dart';
import '../api.dart';
import '../models/new_chat_related_models.dart';

class UserDetailsProvider with ChangeNotifier {
  User? _userDetails;

  User? get userDetails => _userDetails;

  void setUserDetails(User userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  void clearUserDetails() {
    _userDetails = null;
    notifyListeners();
  }

  void updatePreferredLanguage(String language) {
    if (_userDetails != null) {
      _userDetails!.preferredLanguage = language;
      notifyListeners();
    }
  }

  Future<void> fetchUserDetails(String userId) async {
    // Fetch the user details from your backend or wherever you're storing the user data.
    User userDetails = await Api().getUserDetails(userId);
    setUserDetails(userDetails);
  }
}
