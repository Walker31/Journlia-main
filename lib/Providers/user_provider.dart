import 'package:flutter/material.dart';
import '../Models/users.dart';

class UsersProvider extends ChangeNotifier {
  List<AppUser> _users = [];
  AppUser? _currentUser; // Initial list of users

  // Method to fetch users (replace with actual data fetch logic)
  Future<void> fetchUsers() async {
    // Simulate fetching data from API or database
    _users = [
      AppUser(
          userId: '1',
          userName: "John Doe",
          email: "john.doe@example.com",
          accessToken: "sample_access_token",
          role: "user",
          banned: false,
          phoneNumber: '720099309'),
      // Add more users here
    ];
    notifyListeners(); // Notify listeners after data is updated
  }

  AppUser? get currentUser => _currentUser;

  void setCurrentUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  // Getter for users
  List<AppUser> get users => _users;

  // Method to add a new user
  void addUser(name, phone, email, password) {
    int id = _users.length;
    AppUser user = AppUser(
        userId: id.toString(),
        userName: name,
        email: email,
        accessToken: '',
        role: 'User',
        banned: false,
        phoneNumber: phone);
    _users.add(user);
    notifyListeners(); // Notify listeners after data is updated
  }

  void setUserDetails(String userName, String email, String phoneNumber) {
    int id = _users.length;
    _currentUser = AppUser(
        userId: id.toString(), // Generate a new userId
        userName: userName,
        email: email,
        accessToken: '', // Set appropriate access token
        role: 'user', // Default role
        banned: false,
        phoneNumber: phoneNumber);
    notifyListeners(); // Notify listeners after data is updated
  }

  // Method to update an existing user
  void updateUser(AppUser updatedUser) {
    // Find and update the user in the list
    final index =
        _users.indexWhere((user) => user.userId == updatedUser.userId);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners(); // Notify listeners after data is updated
    }
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  // Method to delete a user
  void deleteUser(AppUser user) {
    _users.remove(user);
    notifyListeners(); // Notify listeners after data is updated
  }
}
