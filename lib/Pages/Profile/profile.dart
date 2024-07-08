import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../Database/user_database.dart';
import '../../Database/article_database.dart';
import '../../Providers/user_provider.dart';
import '../../Models/users.dart';
import '../../Models/article.dart';
import '../../Utils/colors.dart';
import '../../Utils/constants.dart';
import '../../Widgets/base_scaffold.dart';
import '../../Widgets/bottom_nav_bar.dart';
import '../../Widgets/drawer.dart';
import 'post_card.dart';

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

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on init
    fetchUserArticles(); // Fetch user articles on init
  }

  // Fetches user data from Providers
  void fetchUserData() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    if (usersProvider.currentUser != null &&
        usersProvider.currentUser!.role != "Guest") {
      try {
        final userData = await UserDatabaseMethods()
            .fetchUser(usersProvider.currentUser!.userId);
        if (mounted) {
          setState(() {
            if (userData != null) {
              appUser = userData;
            }
          });
        }
      } catch (error) {
        logger.e("Error fetching user data: $error");
        // Handle error
      }
      if (usersProvider.currentUser!.role == "Guest") {
        if (mounted) {
          final guestUser = await usersProvider.setAsGuest();
          setState(() {
            appUser = guestUser;
          });
        }
      }
    }
  }

  // Fetches user articles from Firestore
  void fetchUserArticles() {
    setState(() {
      isLoading = true;
    });

    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    ArticleDatabaseMethods()
        .getUserArticles(usersProvider.currentUser!.userId)
        .then((querySnapshot) {
      List<Articles> articles = querySnapshot.docs.map((doc) {
        try {
          return Articles.fromMap(doc.data() as Map<String, dynamic>);
        } catch (e) {
          logger.e("Error processing document ID: ${doc.id}, Error: $e");
          rethrow;
        }
      }).toList();

      setState(() {
        allArticles = articles;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });

      logger.e("Error fetching user articles: $error");
      // Handle error
    });
  }

  // Toggles the visibility of user posts
  void togglePosts() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  bool postVisibility() {
    return appUser != null && appUser!.role != 'Guest';
  }

  // Remove deleted article from allArticles
  void deleteArticleFromList(String articleId) {
    setState(() {
      allArticles.removeWhere((article) => article.articleId == articleId);
      fetchUserArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);

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
                                if (usersProvider.currentUser != null)
                                  Column(
                                    children: [
                                      Text(
                                        "Name: ${usersProvider.currentUser?.userName}",
                                        style: const TextStyle(
                                          color: primaryTextColor,
                                          fontFamily: 'Caveat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      if (appUser?.role !=
                                          'Guest') // Ensure appUser is checked for nullability
                                        Column(
                                          children: [
                                            Text(
                                              "PhoneNumber: ${usersProvider.currentUser?.phoneNumber}",
                                              style: const TextStyle(
                                                color: primaryTextColor,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Text(
                                              "User Type: ${usersProvider.currentUser?.role}",
                                              style: const TextStyle(
                                                color: primaryTextColor,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Text(
                                              "No of Posts Published: ${allArticles.length}",
                                              style: const TextStyle(
                                                color: primaryTextColor,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                if (usersProvider.currentUser == null)
                                  const CircularProgressIndicator(), // Show loading indicator while fetching data
                              ],
                            ),
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
                                ),
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
              if (postVisibility())
                Column(
                  children: [
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
                              color: primaryTextColor,
                            ),
                          ),
                          IconButton(
                            color: primaryTextColor,
                            onPressed: togglePosts,
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
                  ],
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
                            height: 220,
                            child: ListView.builder(
                              shrinkWrap:
                                  true, // Ensures the list is scrollable
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
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
                                    isDeleted: () => deleteArticleFromList(
                                        allArticles[index].articleId),
                                  ),
                                );
                              },
                            ),
                          ),
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
