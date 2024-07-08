// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journalia/Database/article_database.dart';
import 'package:journalia/Models/article.dart';
import 'package:journalia/Models/users.dart';
import '../../Database/database_service.dart';
import '../../Utils/constants.dart';
import '../Feed/article_detail_dialog.dart';

class PostCard extends StatefulWidget {
  final Articles article;
  final Color lastColor;
  final VoidCallback isDeleted;

  const PostCard(
      {super.key,
      required this.article,
      required this.lastColor,
      required this.isDeleted});

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  int likes = 0;
  int dislikes = 0;
  bool isLiked = false;
  bool isDisliked = false;
  bool isExpanded = false;
  int commentCount = 0;
  late Color cardColor;
  late User? currentUser;
  late AppUser appUser;
  bool isDeleted = false;

  final DatabaseMethods _db = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    cardColor = getRandomColor(widget.lastColor);

    // Fetch current user data
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _db.userDatabaseMethods.fetchUser(currentUser!.uid).then((userData) {
        if (userData != null) {
          setState(() {
            appUser = userData;
          });
        }
      });
    }
    // Fetch likes, dislikes, and comments from Firestore
    _fetchArticleData();
  }

  Future<void> _fetchArticleData() async {
    try {
      final voteCounts = await _db.voteDatabaseMethods
          .getVoteCountsForArticle(widget.article.articleId);
      final commentsStream = await _db.commentDatabaseMethods
          .getCommentsForArticle(widget.article.articleId);

      setState(() {
        likes = voteCounts['upvotes'] ?? 0;
        dislikes = voteCounts['downvotes'] ?? 0;
      });

      commentsStream.listen((snapshot) {
        setState(() {
          commentCount = snapshot.docs.length;
        });
      });
    } catch (error) {
      // Handle error
    }
  }

  Color getRandomColor(Color lastColor) {
    Color newColor;
    do {
      newColor = boxColors[Random().nextInt(boxColors.length)];
    } while (newColor == lastColor);
    return newColor;
  }

  void _showArticleDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ArticleDetailDialog(
          article: widget.article,
        );
      },
    );
  }

  Future<void> _deleteArticle(String articleId) async {
    try {
      ArticleDatabaseMethods().deleteArticle(articleId);

      setState(() {
        isDeleted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article deleted')),
      );
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete article')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isDeleted) {
      return const SizedBox.shrink(); // Return an empty SizedBox if deleted
    }
    return GestureDetector(
      onLongPress: () {
        _showArticleDetailDialog(context);
      },
      child: Card(
        color: cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.white,
                    onPressed: () {
                      _deleteArticle(widget.article.articleId);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.article.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Like and Dislike buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        likes != 0 ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        '$likes',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        dislikes != 0
                            ? Icons.thumb_down
                            : Icons.thumb_down_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        '$dislikes',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.comment,
                        color: Colors.white,
                      ),
                      Text(
                        '$commentCount',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
