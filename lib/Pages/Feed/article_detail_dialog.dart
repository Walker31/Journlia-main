import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:journalia/Models/article.dart';
import 'package:journalia/Models/comments.dart';
import '../../Database/article_database.dart';
import '../../Database/comment_database.dart';
import '../../Database/vote_database.dart';
import '../../log_page.dart';

class ArticleDetailDialog extends StatefulWidget {
  final Articles article;

  const ArticleDetailDialog({
    super.key,
    required this.article,
  });

  @override
  ArticleDetailDialogState createState() => ArticleDetailDialogState();
}

class ArticleDetailDialogState extends State<ArticleDetailDialog> {
  late CommentDatabaseMethods _commentDatabaseMethods;
  late VoteDatabaseMethods _voteDatabaseMethods;
  Stream<QuerySnapshot>? _commentsStream;
  int _likes = 0;
  int _dislikes = 0;
  String authorName = '';

  @override
  void initState() {
    super.initState();
    _commentDatabaseMethods = CommentDatabaseMethods();
    _voteDatabaseMethods = VoteDatabaseMethods();
    fetchCommentsStream();
    fetchAuthorName();
    _fetchVoteCounts();
  }

  Future<void> fetchAuthorName() async {
    try {
      String name = await ArticleDatabaseMethods()
          .getArticleAuthorByUser(widget.article.articleId);
      setState(() {
        authorName = name;
      });
    } catch (e) {
      setState(() {
        authorName = 'Unknown';
      });
      LogData.addErrorLog('Error fetching author name: $e');
    }
  }

  Future<void> _fetchVoteCounts() async {
    final voteCounts = await _voteDatabaseMethods
        .getVoteCountsForArticle(widget.article.articleId);
    setState(() {
      _likes = voteCounts['upvotes'] ?? 0;
      _dislikes = voteCounts['downvotes'] ?? 0;
    });
  }

  void fetchCommentsStream() async {
    _commentsStream = await _commentDatabaseMethods
        .getCommentsForArticle(widget.article.articleId);
    setState(() {}); // Update the state to refresh the UI
  }

  Future<String> getCommentUserName(String commentId) async {
    try {
      return await _commentDatabaseMethods.getCommentUserName(commentId);
    } catch (e) {
      return 'Unknown'; // Handle error gracefully
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.article_outlined,
              size: 28), // Example icon, replace with your preferred icon
          const SizedBox(width: 12),
          Text(
            widget.article.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize
                .min, // Ensure the dialog takes minimum space needed
            children: [
              Text(
                'Written by: $authorName',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Published on: ${formatDateTime(widget.article.createdAt)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                widget.article.content,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'Likes: $_likes',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Dislikes: $_dislikes',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                'Comments:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: _commentsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error loading comments');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No comments yet');
                  }
                  final comments = snapshot.data!.docs
                      .map((doc) =>
                          Comments.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();
                  return Column(
                    children: comments.map((comment) {
                      return FutureBuilder<String>(
                        future: getCommentUserName(comment
                            .userId), // Assuming userId is stored in comment document
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text('Unknown');
                          }
                          final authorName = snapshot.data ?? 'Unknown';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  child: Text(' '),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        authorName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        comment.content,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
