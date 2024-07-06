import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:journalia/Database/database_service.dart';
import 'package:journalia/Pages/Home/home_page.dart';
import 'package:journalia/Widgets/base_scaffold.dart';
import 'package:journalia/Widgets/bottom_nav_bar.dart';
import 'package:journalia/Widgets/drawer.dart';
import 'package:journalia/Utils/constants.dart';
import 'package:journalia/log_page.dart';
import '../../Database/topic_database.dart';
import '../../Utils/colors.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() => CreatePostPageState();
}

class CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String? selectedCommunity;
  String selectedTopic = 'Experience Sharing';
  List<String> topics = [];
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  void fetchTopics() {
    setState(() {
      isLoading = true;
    });
    TopicDatabaseMethods().getAllTopics().then((List<String> fetchedTopics) {
      setState(() {
        topics = fetchedTopics;
        isLoading = false;
      });
    }).catchError((error) {
      LogData.addErrorLog('Error fetching topics: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  void savePost() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final content = contentController.text;
      final title = titleController.text;
      int? topicId = await DatabaseMethods()
          .topicDatabaseMethods
          .getTopicIdByName(selectedTopic);

      if (topicId == null) {
        throw 'Topic ID not found';
      }

      await DatabaseMethods()
          .articleDatabaseMethods
          .addArticle(content, title, topicId);
      LogData.addDebugLog('Post saved: $title');

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.black.withOpacity(0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Article Posted Successfully',
                  style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'Caveat',
                      fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (error) {
      LogData.addErrorLog('Error saving post: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save post. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        appBar: buildAppBar2(context),
        drawer: const CustomDrawer(),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNavBar(),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20.0),
                        _buildCommunityDropdown(),
                        const SizedBox(height: 20.0),
                        _buildPostForm(),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Create Post',
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: 'Caveat',
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            onPressed: () {
              // Open drafts
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.purple.withOpacity(0.1),
            ),
            child: const Text(
              'My Drafts',
              style: TextStyle(color: Colors.purpleAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: primaryTextColor, width: 2),
            borderRadius: BorderRadius.circular(32)),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const ImageIcon(AssetImage("assets/DashedCircle.png"),
                color: primaryTextColor),
            DropdownButton(
              underline: const SizedBox.shrink(),
              hint: const Text(
                "Choose a Community",
                style: TextStyle(color: primaryTextColor),
              ),
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                color: primaryTextColor,
                size: 36,
              ),
              dropdownColor: Colors.white,
              value: selectedCommunity,
              items: communityList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style:
                        const TextStyle(color: primaryTextColor, fontSize: 20),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCommunity = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostForm() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'An Interesting title',
              hintStyle: TextStyle(color: primaryTextColor),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            style: const TextStyle(color: primaryTextColor),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(
              hintText: 'Your text post (optional)',
              hintStyle: TextStyle(color: primaryTextColor),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, style: BorderStyle.solid, width: 3),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            style: const TextStyle(color: primaryTextColor),
            maxLines: 5,
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryDropdown(),
              IconButton(
                icon: const Icon(
                  Icons.image_outlined,
                  color: primaryTextColor,
                ),
                onPressed: () {
                  // Add image
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text("Mark as: ", style: TextStyle(color: primaryTextColor)),
          DropdownButton(
            dropdownColor: Colors.white,
            isExpanded: false,
            icon: const Icon(
              Icons.arrow_drop_down_rounded,
              color: primaryTextColor,
              size: 36,
            ),
            underline: const SizedBox.shrink(),
            value: selectedTopic,
            items: topics.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(32)),
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTopic = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            // Save draft
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: const Text(
            'Save Draft',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: savePost,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text(
            'Post',
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }
}
