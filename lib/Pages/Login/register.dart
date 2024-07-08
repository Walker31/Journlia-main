import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:journalia/Pages/Login/login_page.dart';
import 'package:journalia/Utils/colors.dart';
import 'package:journalia/Widgets/base_scaffold.dart';
import 'package:journalia/Widgets/bottom_nav_bar.dart';
import 'package:logger/logger.dart';
import '../../Auth/firebase_auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Logger logger = Logger();
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.registerWithEmailAndPassword(
          nameController.text.trim(),
          emailController.text.trim(),
          phoneNumberController.text.trim(),
          passwordController.text.trim(),
        );

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  title: const Text('Registration Successful'),
                  content: const Text('You have registered successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } catch (e) {
        logger.d('Registration Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _clearTextFields();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: primaryTextColor,
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Caveat',
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: nameController,
                      labelText: 'Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Name cannot be empty' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: phoneNumberController,
                      labelText: 'Phone Number',
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty
                          ? 'Phone number cannot be empty'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: emailController,
                      labelText: 'Email Address',
                      validator: (value) =>
                          value!.isEmpty ? 'Email cannot be empty' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: passwordController,
                      labelText: 'Password',
                      validator: (value) =>
                          value!.isEmpty ? 'Password cannot be empty' : null,
                    ),
                    const SizedBox(height: 40),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildSignUpButton(),
                    const SizedBox(height: 20),
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Caveat',
          fontSize: 24,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Caveat',
          fontSize: 24,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: primaryTextColor,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextButton(
          onPressed: _register,
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: primaryTextColor,
              fontFamily: 'Caveat',
              fontSize: 30,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
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
            _clearTextFields();
            Navigator.pop(context);
          },
          child: const Text(
            'Log in',
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
    );
  }

  void _clearTextFields() {
    nameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
  }
}
