import 'package:flutter/material.dart';

BoxDecoration appBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Colors.deepPurple[900]!, // Darker shade of purple
      Colors.purple[800]!, // Darker shade of purple      // Darker shade of green
      Colors.blueGrey[900]!, // Darker shade of blue-grey
      Colors.blueGrey[800]!, // Darker shade of blue-grey
    ],
    stops: const [0.0, 0.5, 0.75, 1.0], // Adjust stops as per preference
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);
