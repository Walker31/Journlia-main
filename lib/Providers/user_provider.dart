import 'package:flutter/material.dart';
import 'package:journalia/Database/user_database.dart'; // Assuming this is where fetchUser method is implemented

class UsersProvider extends ChangeNotifier {
  late Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;

  // Function to fetch and set current user
  Future<void> setCurrentUser(String uid) async {
    final userData = await UserDatabaseMethods().fetchUser(uid);
    if (userData != null) {
      _currentUser = userData;
      notifyListeners();
    } else {
      // Handle case where user data is not found
      _currentUser = null;
      notifyListeners();
    }
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }
}
