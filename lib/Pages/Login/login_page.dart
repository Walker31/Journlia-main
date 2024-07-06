import 'package:flutter/material.dart';
import 'package:journalia/Pages/Login/register.dart';
import 'package:journalia/Utils/colors.dart';
import 'package:journalia/Widgets/base_scaffold.dart';
import 'package:journalia/Widgets/bottom_nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Auth/firebase_auth_services.dart';

// Firebase Authentication Service

// Login Widget
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final Logger _logger = Logger();

  Future<void> _login() async {
    String enteredEmail = emailController.text.trim();
    String enteredPassword = passwordController.text.trim();

    // Remove focus from text fields to dismiss keyboard
    FocusScope.of(context).unfocus();

    if (enteredEmail.isNotEmpty && enteredPassword.isNotEmpty) {
      try {
        // Sign in with Firebase Authentication
        User? user = await _authService.signInWithEmailPassword(
          enteredEmail,
          enteredPassword,
        );

        if (user != null) {
          // Save login state using SharedPreferences
          await _authService.saveLoginState();
          if (!mounted) return;

          // Navigate to home page after successful login
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on FirebaseAuthException catch (e) {
        // Handle specific FirebaseAuth exceptions
        if (e.code == 'user-not-found') {
          _logger.d('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          _logger.d('Wrong password provided for that user.');
        } else {
          _logger.d('Firebase Auth Error: ${e.message}');
        }
      }
    } else {
      _logger.d('Please enter valid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: const Text(''), // Empty leading text to adjust alignment
          backgroundColor: Colors.transparent,
          actions: [
            // Action button for continuing as a guest
            TextButton(
              onPressed: () {
                // Add logic for continuing as guest
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text(
                'Continue as guest',
                style: TextStyle(
                  color: primaryTextColor,
                  fontFamily: 'Caveat',
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Title row for "Login"
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Caveat',
                        fontSize: 56,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Email text field
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Caveat',
                            fontSize: 24,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Password text field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Caveat',
                            fontSize: 24,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Login button
                SizedBox(
                  width: double.infinity, // Expand button to full width
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: _login, // Call login function here
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontFamily: 'Caveat',
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Sign up row with "Do not have an account?" and "Sign up" link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Do not have an account? ',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontFamily: 'Caveat',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Clear text fields
                        emailController.clear();
                        passwordController.clear();

                        // Navigate to the registration page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Caveat',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar(), // Bottom navigation bar
      ),
    );
  }
}
