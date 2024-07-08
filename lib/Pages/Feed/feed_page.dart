import 'package:flutter/material.dart';
import 'package:journalia/Database/article_database.dart';
import 'package:journalia/Database/topic_database.dart';
import 'package:journalia/utils/constants.dart';
import 'package:journalia/widgets/base_scaffold.dart';
import 'package:journalia/widgets/bottom_nav_bar.dart';
import 'package:journalia/widgets/drawer.dart';
import 'package:logger/logger.dart';
import '../../Models/article_box.dart';
import '../../log_page.dart';
import 'article_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/colors.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  int currentTopicIndex = 0;
  Logger logger = Logger();
  List<String> topics = [];
  TextEditingController searchController = TextEditingController();
  Color lastColor = Colors.red;
  int _selectedIndex = -1;
  int _filterIndex = 1;
  ScrollController controller = ScrollController();
  double topContainer = 0;
  late List<String> _options;
  final ArticleDatabaseMethods _articleDb =
      ArticleDatabaseMethods(); // Add this line
  Stream<QuerySnapshot>? articlesStream;

  List<Color> cardColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  @override
  void initState() {
    super.initState();
    _options = ["Top", "Latest", "Trendy"];
    fetchTopics();
    searchController.addListener(search);
    controller.addListener(() {
      setState(() {
        topContainer = controller.offset > 50 ? 1 : 0;
      });
    });
    fetchArticlesStream(); // Fetch the articles stream
  }

  void fetchArticlesStream() async {
    articlesStream = await _articleDb.getArticles(currentTopicIndex);
    setState(() {}); // Update the state to refresh the UI
  }

  void fetchTopics() {
    TopicDatabaseMethods().getAllTopics().then((List<String> fetchedTopics) {
      setState(() {
        topics = fetchedTopics;
      });
      logger.d("fetching current topics");
      LogData.addDebugLog("fetching current topics");
    }).catchError((error) {
      LogData.addErrorLog('Error fetching topics: $error');
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search() {
    // Search logic remains the same
  }

  void _nextTopic() {
    setState(() {
      currentTopicIndex = (currentTopicIndex + 1) % topics.length;
      fetchArticlesStream();
    });
  }

  void _previousTopic() {
    setState(() {
      currentTopicIndex =
          (currentTopicIndex - 1 + topics.length) % topics.length;
          fetchArticlesStream();
    });
  }

  Color getNextColor(Color lastColor) {
    Color nextColor =
        cardColors[(cardColors.indexOf(lastColor) + 1) % cardColors.length];
    return nextColor;
  }

  Widget get filterChipRow {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < _options.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FilterChip(
                label: Text(
                  _options[i],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepPurple,
                  ),
                ),
                pressElevation: 5,
                elevation: 3,
                showCheckmark: false,
                selectedColor: Colors.black,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.grey,
                selected: _filterIndex == i,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _filterIndex = i;
                    }
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentTopic = topics.isNotEmpty ? topics[currentTopicIndex] : '';

    return BaseScaffold(
      body: Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        drawer: const CustomDrawer(),
        backgroundColor: Colors.transparent,
        appBar: buildAppBar2(context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryTextColor),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextField(
                    cursorColor: primaryTextColor,
                    style: const TextStyle(color: primaryTextColor),
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: primaryTextColor),
                      prefixIcon:
                          const Icon(Icons.search, color: primaryTextColor),
                      filled: false,
                      fillColor: accentColor.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.double_arrow,
                          color: primaryTextColor,
                        ),
                      ),
                      onPressed: _previousTopic,
                    ),
                    Text(
                      currentTopic,
                      style: const TextStyle(
                          fontSize: 32,
                          fontFamily: 'Caveat',
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      icon: const Icon(Icons.double_arrow,
                          color: primaryTextColor),
                      onPressed: _nextTopic,
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.more_vert, color: primaryTextColor),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              filterChipRow,
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: articlesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No articles found'));
                    }

                    final articles = snapshot.data!.docs.map((doc) {
                      return ArticleBox.fromMap(
                          doc.data() as Map<String, dynamic>);
                    }).toList();

                    return ListView.builder(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          bottom: 80, top: 8, left: 8, right: 8),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        Color currentColor = getNextColor(lastColor);
                        lastColor = currentColor;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex =
                                  _selectedIndex == index ? -1 : index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: Align(
                              heightFactor: _selectedIndex == index ? 1 : 0.3,
                              alignment: Alignment.topCenter,
                              child: ArticleCard(
                                article: article,
                                lastColor: currentColor,
                              ),
                            ),
                          ),
                        );
                      },
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
}
