import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:journalia/log_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journalia/Pages/Home/home_page.dart'; // Adjust path as needed

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Delay for 1 second to display the splash screen for a minimum duration
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // Navigate based on login status
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
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
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.black,
      splashIconSize: double.infinity,
    );
  }
}
