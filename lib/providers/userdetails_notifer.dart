import 'package:flutter/material.dart';

import '../api.dart';
import '../models/new_chat_related_models.dart';

class UserDetailsProvider with ChangeNotifier {
  User? _userDetails;

  User? get userDetails => _userDetails;

  Future<void> fetchUserDetails(String userId) async {
    _userDetails = await Api().getUserDetails(userId);
    notifyListeners();
  }

  void clearUserDetails() {
    _userDetails = null;
    notifyListeners();
  }
}
