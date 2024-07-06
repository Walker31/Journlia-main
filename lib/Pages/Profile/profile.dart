import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journalia/Database/article_database.dart';
import 'package:journalia/Database/user_database.dart';
import 'package:journalia/Models/article.dart';
import 'package:journalia/Models/users.dart';
import 'package:journalia/Pages/Profile/article_card.dart';
import 'package:journalia/Widgets/base_scaffold.dart';
import 'package:journalia/Widgets/bottom_nav_bar.dart';
import 'package:journalia/Widgets/drawer.dart';
import 'package:journalia/log_page.dart'; // Import your log_page if needed
import '../../Utils/colors.dart';
import '../../Utils/constants.dart'; // Adjust the path as necessary
import 'package:logger/logger.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  User? currentUser;
  late AppUser appUser;
  bool isExpanded = false;
  List<Articles> allArticles = [];
  bool isLoading = false;
  MaterialColor lastColor = Colors.red; // Initial color for ArticleCard
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      fetchUserData();
      logger.d("fetching User data");
    }
  }

  // Fetches user data from Firestore
  void fetchUserData() {
    logger.d("fetching User data1");
    UserDatabaseMethods().fetchUser(currentUser!.uid).then((userData) {
      logger.d(currentUser!.uid);
      logger.d(userData);
      if (userData != null) {
        setState(() {
          appUser = AppUser(
            userId: userData['userId'],
            userName: userData['userName'],
            email: userData['email'],
            accessToken: userData['accessToken'],
            role: userData['role'],
            banned: userData['banned'],
            phoneNumber: userData['phoneNumber'],
          );
          logger.d(appUser);
        });
      } else {
        // Handle if user data is not found
      }
    }).catchError((error) {
      // Handle error
      LogData.addErrorLog('Error fetching user data: $error');
    });
  }

  // Fetches user articles from Firestore
  void getUserArticles() {
    setState(() {
      isLoading = true;
    });

    logger.d("Start fetching user articles for user ID: ${currentUser!.uid}");

    ArticleDatabaseMethods()
        .getUserArticles(currentUser!.uid)
        .then((querySnapshot) {
      logger.d(
          "Received querySnapshot with ${querySnapshot.docs.length} documents");

      List<Articles> articles = querySnapshot.docs.map((doc) {
        logger.d("Processing document ID: ${doc.id}");
        try {
          return Articles.fromMap(doc.data() as Map<String, dynamic>);
        } catch (e) {
          logger.e("Error processing document ID: ${doc.id}, Error: $e");
          rethrow;
        }
      }).toList();

      logger.d("Processed ${articles.length} articles");

      setState(() {
        allArticles = articles;
        isLoading = false;
      });

      logger.d("Finished fetching and setting user articles");
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });

      logger.e("Error fetching user articles: $error");
      LogData.addErrorLog('Error fetching user articles: $error');
    });
  }

  // Toggles the visibility of user posts
  void _toggleposts() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        getUserArticles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        appBar: buildAppBar2(context),
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawer(),
        bottomNavigationBar: const BottomNavBar(),
        body: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Information Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    // Profile Image and Name Section
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Column(), // Your content here
                        ),
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: Column(
                            children: [
                              // Profile Image
                              Image.asset('assets/Profile.png'),
                              const Text(
                                "N I T", // Adjust text as needed
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // User Posts Section
            if (currentUser != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Title for My Posts section
                    const Text(
                      "My Posts",
                      style: TextStyle(
                          fontFamily: 'Caveat',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: primaryTextColor),
                    ),
                    IconButton(
                      color: primaryTextColor,
                      onPressed: _toggleposts,
                      icon: Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                isLoading
                    ? const CircularProgressIndicator() // Show loading spinner
                    : allArticles.isEmpty
                        ? const Center(
                            child: Text("No Articles Found"),
                          ) // Show message when no articles
                        : Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: allArticles.length,
                              itemBuilder: (context, index) {
                                ArticleCard1(
                                    article: allArticles[index],
                                    lastColor: lastColor);
                                return null;
                              },
                            ),
                          ),
            ],
          ],
        ),
      ),
    );
  }

  // Generate a random color for each ArticleCard
  MaterialColor getNextColor() {
    MaterialColor newColor;
    do {
      newColor = Colors.primaries[
          (Colors.primaries.indexOf(lastColor) + 1) % Colors.primaries.length];
    } while (newColor == lastColor);
    lastColor = newColor;
    return newColor;
  }
}
