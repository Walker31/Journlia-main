import 'package:firebase_auth/firebase_auth.dart';
import 'package:journalia/Database/user_database.dart';
import 'package:journalia/Models/users.dart';
import 'package:journalia/log_page.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  final LogData log = LogData();

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        LogData.addDebugLog('Logged in with Email: $email');
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

        UserDatabaseMethods().addUserDetails(appUser);
        // Simulated saving user details, replace with actual logic
        // For example, storing in Firestore or any other database
      }
    } on FirebaseAuthException catch (e) {
      _logger.d('Firebase Auth Error: ${e.message}');
      rethrow;
    }
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  void signOut() async {
    await _auth.signOut();
    // Additional logic to clear session or navigate to sign-out state
  }
}
