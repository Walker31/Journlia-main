import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:journalia/Database/user_database.dart';
import 'package:journalia/Models/users.dart';
import 'package:journalia/log_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Providers/user_provider.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        LogData.addDebugLog('Logged in with Email: $email');
        // ignore: use_build_context_synchronously  
        await Provider.of<UsersProvider>(context, listen: false)
            .setCurrentUser(user.uid);
        await saveLoginState(); // Save login state after successful login
        return user;
      }
    } on FirebaseAuthException catch (e) {
      LogData.addErrorLog('Firebase Auth Error: ${e.message}');
      rethrow;
    }
    return null;
  }

  Future<void> registerWithEmailAndPassword(
    String name,
    String email,
    String phoneNumber,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Additional registration logic (e.g., saving user details to database)
      User? user = userCredential.user;
      if (user != null) {
        LogData.addDebugLog('Registered with Email: $email');

        AppUser appUser = AppUser(
            userId: user.uid,
            userName: name,
            email: email,
            accessToken: "NITT",
            role: 'User',
            banned: false,
            phoneNumber: phoneNumber);

        await UserDatabaseMethods().addUserDetails(appUser);
        // Simulated saving user details, replace with actual logic
        // For example, storing in Firestore or any other database
      }
    } on FirebaseAuthException catch (e) {
      LogData.addErrorLog('Firebase Auth Error: ${e.message}');
      rethrow;
    }
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await clearLoginState(); // Clear login state on sign out
    // Additional logic to clear session or navigate to sign-out state
  }
}
