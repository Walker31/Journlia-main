// custom_drawer.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/user_provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  Future<void> _signOut(BuildContext context) async {
    // Clear user session data
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('isLoggedIn');
    await prefs.remove('userName');

    // Clear current user in the UsersProvider
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    userProvider.clearCurrentUser();

    // Check if the widget is still mounted before using the context
    if (!mounted) return;

    // Navigate to the login screen
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  List<bool> isSelected = [
    true,
    false
  ]; // Initial state, assuming light mode is selected

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context);
    bool isAdmin = userProvider.currentUser != null &&
        userProvider.currentUser!.role == 'Admin';
    bool isGuest = userProvider.currentUser != null &&
        userProvider.currentUser!.role == 'Guest';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.home, size: 48),
          ),
          ListTile(
            title: const Text('Settings'),
            trailing: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (isAdmin)
            ListTile(
              title: const Text('L O G'),
              trailing: const Icon(Icons.note),
              onTap: () {
                Navigator.pushNamed(context, '/Log');
              },
            ),
          if (isGuest)
            ListTile(
              title: const Text('Sign In'),
              trailing: const Icon(Icons.login),
              onTap: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          if (!isGuest)
            ListTile(
              title: const Text('Sign Out'),
              trailing: const Icon(Icons.exit_to_app_rounded),
              onTap: () => _signOut(context),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      isSelected[buttonIndex] = buttonIndex == index;
                    }
                  });
                },
                children: const <Widget>[
                  Icon(Icons.light_mode),
                  Icon(Icons.dark_mode),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
