import 'package:flutter/material.dart';
import 'package:journalia/Providers/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../Utils/colors.dart'; // Import your UsersProvider

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2; // Default to 'Create Post'
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    // Initialize state, fetch user role or other necessary data
    // Example: if using Provider, initialize your state here
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      logger.d('Selected Index changed to: $_selectedIndex');
    });
    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushNamed('/feed');
        break;
      case 2:
        if (!isGuestUser()) {
          // Check if not guest user
          Navigator.of(context).pushNamed('/createpost');
          logger.d('Create Post tapped');
        } else {
          // Handle logic for guest user (optional)
          logger.d('Guest user cannot create posts.');
        }
        break;
      case 3:
        () {};
        break;
      case 4:
        Navigator.of(context).pushNamed('/profile');
        break;
    }
  }

  bool isGuestUser() {
    // Example: Access current user's role, assuming using Provider
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final currentUser = usersProvider.currentUser;

    return currentUser != null && currentUser.role == 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 5,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: tertiaryColor,
      unselectedItemColor: accentColor,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Feed',
        ),
        if (!isGuestUser())
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 28),
            ),
            label: 'Create Post',
          ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'Login',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
