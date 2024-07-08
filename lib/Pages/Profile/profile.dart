import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:journalia/Database/article_database.dart';
import 'package:journalia/Models/article.dart';
import 'package:journalia/Models/users.dart';
import 'package:journalia/Widgets/base_scaffold.dart';
import 'package:journalia/Widgets/bottom_nav_bar.dart';
import 'package:journalia/Widgets/drawer.dart';
import 'package:logger/logger.dart';
import '../../Database/user_database.dart';
import '../../Providers/user_provider.dart';
import '../../Utils/colors.dart';
import '../../Utils/constants.dart';
import '../../log_page.dart';
import 'article_card.dart'; // Import your UsersProvider

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool isExpanded = false;
  List<Articles> allArticles = [];
  bool isLoading = false;
  AppUser? appUser;
  MaterialColor lastColor = Colors.red; // Initial color for ArticleCard
  final Logger logger = Logger();
  int? noOfPosts;

  @override
  void initState() {
    super.initState();
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      usersProvider.setCurrentUser(currentUser.uid);
      fetchUserData(currentUser.uid);
    }
  }

  // Fetches user data from Firestore
  void fetchUserData(String uid) async {
    logger.d("fetching User data");
    try {
      final userData = await UserDatabaseMethods().fetchUser(uid);
      logger.d(uid);
      logger.d(userData);
      setState(() {
        // Update UI with fetched user data
        if (userData != null) {
          appUser = AppUser(
            userId: userData['userId'],
            userName: userData['userName'],
            email: userData['email'],
            accessToken: userData['accessToken'],
            role: userData['role'],
            banned: userData['banned'],
            phoneNumber: userData['phoneNumber'],
          );
        }
      });
    } catch (error) {
      // Handle error
      LogData.addErrorLog('Error fetching user data: $error');
    }
  }

  // Fetches user articles from Firestore
  void getUserArticles(String uid) {
    setState(() {
      isLoading = true;
    });

    logger.d("Start fetching user articles for user ID: $uid");

    ArticleDatabaseMethods().getUserArticles(uid).then((querySnapshot) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider =
        Provider.of<UsersProvider>(context); // Access UsersProvider

    return BaseScaffold(
      body: Scaffold(
        appBar: buildAppBar2(context),
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawer(),
        bottomNavigationBar: const BottomNavBar(),
        body: SingleChildScrollView(
          child: Column(
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
                            child: Column(
                              children: [
                                const SizedBox(height: 75),
                                usersProvider.currentUser != null
                                    ? Column(
                                        children: [
                                          Text(
                                            "Name: ${usersProvider.currentUser?['userName']}",
                                            style: const TextStyle(
                                                color: primaryTextColor,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          Text(
                                            "PhoneNumber: ${usersProvider.currentUser?['phoneNumber']}",
                                            style: const TextStyle(
                                                color: primaryTextColor,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          Text(
                                            "User Type: ${usersProvider.currentUser?['role']}",
                                            style: const TextStyle(
                                                color: primaryTextColor,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          Text(
                                            "No of Posts Published: $noOfPosts",
                                            style: const TextStyle(
                                                color: primaryTextColor,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          )
                                        ],
                                      )
                                    : const CircularProgressIndicator(), // Show loading indicator while fetching data
                              ],
                            ), // Your content here
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
              if (appUser != null) ...[
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
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
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
                          : Container(
                              padding: const EdgeInsets.all(8),
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap:
                                    true, // Ensures the list is scrollable
                                physics: const ClampingScrollPhysics(),
                                itemCount: allArticles.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: PostCard(
                                      article: allArticles[index],
                                      lastColor: getNextColor(),
                                    ),
                                  );
                                },
                              ),
                            ),
              ],
            ],
          ),
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
