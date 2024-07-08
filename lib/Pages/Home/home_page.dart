import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:journalia/Pages/Home/carousel.dart';
import 'package:journalia/Widgets/base_scaffold.dart';
import 'package:journalia/Widgets/bottom_nav_bar.dart';
import 'package:journalia/Utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Providers/user_provider.dart';
import '../../Widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Logger logger = Logger();
  String selectedButton = "Home"; // Initial selected button
  bool isRefreshing = false;

  // Method to handle pull-to-refresh
  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate fetching new data or refreshing content
    await Future.delayed(
        const Duration(seconds: 2)); // Replace with your data fetching logic

    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawer(),
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gradient text saying "Hey"
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF4EED7A),
                                  Color(0xFF11336D),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Text(
                                "Hey",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 36,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Displays the current user's name or "Guest"
                            Consumer<UsersProvider>(
                              builder: (context, usersProvider, child) {
                                final userName =
                                    usersProvider.currentUser?['userName'] ??
                                        'Guest';
                                return Text(
                                  userName,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 36,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // Circular container with "Streaks" text
                        IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black26, width: 4.0),
                            ),
                            child: const Text(
                              "Streaks",
                              style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10), // Adds space between rows
                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Home button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButton = "Home";
                          });
                          logger.d("Home Pressed");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedButton == "Home"
                              ? Colors.white
                              : Colors.grey,
                          foregroundColor: selectedButton == "Home"
                              ? Colors.black
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Home",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      // Communities button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButton = "Communities";
                          });
                          logger.d("Communities Pressed");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedButton == "Communities"
                              ? Colors.white
                              : Colors.grey,
                          foregroundColor: selectedButton == "Communities"
                              ? Colors.black
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Communities",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25), // Adds space before Carousel
                  // Carousel widget
                  const SizedBox(
                    height: 250, // Height for the Carousel widget
                    child: Carousel(),
                  ),
                  const SizedBox(height: 25), // Adds space after Carousel

                  // Placeholder for additional content or loading indicator
                  if (isRefreshing)
                    const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    )
                  else
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.3, // Height for the empty space
                      child: const Center(
                        child: Text(
                          "Additional content placeholder",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
