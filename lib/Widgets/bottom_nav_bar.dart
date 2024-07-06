import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../Utils/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2;
  Logger logger = Logger();

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
        Navigator.of(context).pushNamed('/createpost');
        logger.d('Create Post tapped');
        break;
      case 3:
        Navigator.of(context).pushNamed('/login');
        break;
      case 4:
        Navigator.of(context).pushNamed('/profile');
        break;
    }
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
          icon: Icon(Icons.lock),
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
