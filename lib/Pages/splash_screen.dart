import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:journalia/log_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journalia/Pages/Home/home_page.dart'; // Adjust path as needed
import 'package:journalia/Database/user_database.dart';

import 'Login/login_page.dart'; // Adjust path as needed

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  Map<String, dynamic>? _currentUser;

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Delay for 1 second to display the splash screen for a minimum duration
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // Navigate based on login status
    if (isLoggedIn) {
      final userId = prefs.getString('userId');
      if (userId != null) {
        await fetchCurrentUser(userId);
        if (_currentUser != null) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          if (!mounted) return;
          LogData.addErrorLog('Error fetching current user details.');
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> fetchCurrentUser(String userId) async {
    try {
      final userData = await UserDatabaseMethods().fetchUser(userId);
      if (userData != null) {
        setState(() {
          _currentUser = {
            'userId': userData['userId'],
            'userName': userData['userName'],
            'email': userData['email'],
            'phoneNumber': userData['phoneNumber'],
            'role': userData['role'],
            // Add other necessary fields as per your user model
          };
        });
      }
    } catch (e) {
      LogData.addErrorLog('Error fetching current user details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _checkLogin();
    } catch (e) {
      // Handle initialization error (e.g., SharedPreferences access error)
      LogData.addErrorLog('Error initializing app: $e');
      if (!mounted) return;
      // Navigate to login screen in case of error
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2500, // Increased duration for better visibility
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flash_on,
            size: MediaQuery.of(context).size.width * 0.4,
            color: Colors.yellow,
          ),
          const SizedBox(height: 20),
          const Text(
            'J O U R N A L I A',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      nextScreen: _currentUser != null ? const HomePage() : const Login(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.black,
      splashIconSize: double.infinity,
    );
  }
}
