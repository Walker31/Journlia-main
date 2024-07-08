import 'package:flutter/material.dart';
import 'package:journalia/Database/user_database.dart';
import '../Models/users.dart'; // Assuming this is where fetchUser method is implemented

class UsersProvider extends ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  // Function to fetch and set current user
  Future<void> setCurrentUser(String uid) async {
    try {
      final userData = await UserDatabaseMethods().fetchUser(uid);
      if (userData != null) {
        _currentUser = userData;
      } else {
        // Handle case where user data is not found
        _currentUser = null;
      }
    } catch (error) {
      // Handle error from fetchUser method
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> setGuestUser() async {
    _currentUser = AppUser(
        userId: '0',
        userName: "Guest",
        email: '',
        accessToken: 'NIT',
        role: 'Guest',
        banned: false,
        phoneNumber: '0000');
    notifyListeners();
  }

  Future<AppUser> setAsGuest() async {
    return AppUser(
        userId: '0',
        userName: 'Guest',
        email: '',
        accessToken: '',
        role: 'Guest',
        banned: false,
        phoneNumber: '');
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }
}
