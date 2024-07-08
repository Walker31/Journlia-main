import 'package:flutter/material.dart';
import 'package:journalia/Utils/colors.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

final List<String> communityList = [
  'Community 1',
  'Community 2',
  'Community 3'
];

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    actions: [
      Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            icon: const Icon(
              Icons.menu,
              color: primaryTextColor,
            ),
          );
        },
      )
    ],
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: textColor,
    leading: IconButton(
      onPressed: () {
        logger.d('Person icon button pressed!');
        Navigator.pushNamed(context, '/profile');
      },
      icon: const CircleAvatar(
        backgroundImage: AssetImage('assets/Profile.png'),
      ),
    ),
    title: const Text(
      "Journalia",
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Caveat',
        fontWeight: FontWeight.bold,
        fontSize: 48,
      ),
    ),
  );
}

AppBar buildAppBar2(BuildContext context) {
  return AppBar(
    leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: primaryTextColor,
        ),
        onPressed: () => Navigator.pop(context)),
    title: const Text(
      "Journalia",
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Caveat',
        fontWeight: FontWeight.bold,
        fontSize: 48,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: textColor,
    actions: [
      Builder(builder: (context) {
        return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu, color: primaryTextColor),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip);
      })
    ],
  );
}

List<Color> boxColors = [
  Colors.purple.shade600,
  Colors.blue.shade500,
  Colors.green.shade700,
  const Color.fromARGB(255, 187, 27, 15),
  Colors.grey.shade700
];
