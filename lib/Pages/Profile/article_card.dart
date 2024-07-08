import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journalia/Models/article.dart';
import 'package:journalia/Models/comments.dart';
import 'package:journalia/Models/users.dart';
import 'package:journalia/Models/votes.dart';
import '../../Database/database_service.dart';
import '../../Utils/constants.dart';

class PostCard extends StatefulWidget {
  final Articles article;
  final Color lastColor;

  const PostCard({
    super.key,
    required this.article,
    required this.lastColor,
  });

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  int likes = 0;
  int dislikes = 0;
  bool isLiked = false;
  bool isDisliked = false;
  bool isExpanded = false;
  late Color cardColor;
  late User? currentUser;
  late AppUser appUser;
  List<Comments> comments = [];

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
            appUser = AppUser.fromMap(userData);
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
          comments = snapshot.docs
              .map(
                  (doc) => Comments.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
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

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        likes--;
        // Remove like from Firestore
        _db.voteDatabaseMethods
            .removeVote('like_${widget.article.articleId}_${currentUser!.uid}');
      } else {
        likes++;
        // Add like to Firestore
        _db.voteDatabaseMethods.addVote(Vote(
          voteId: 'like_${widget.article.articleId}_${currentUser!.uid}',
          userId: currentUser!.uid,
          articleId: widget.article.articleId,
          voteType: true,
        ));
        // If the user had previously disliked the article, we need to remove that dislike
        if (isDisliked) {
          dislikes--;
          isDisliked = false;
          _db.voteDatabaseMethods.removeVote(
              'dislike_${widget.article.articleId}_${currentUser!.uid}');
        }
      }
      isLiked = !isLiked;
    });
  }

  void _toggleDislike() {
    setState(() {
      if (isDisliked) {
        dislikes--;
        // Remove dislike from Firestore
        _db.voteDatabaseMethods.removeVote(
            'dislike_${widget.article.articleId}_${currentUser!.uid}');
      } else {
        dislikes++;
        // Add dislike to Firestore
        _db.voteDatabaseMethods.addVote(Vote(
          voteId: 'dislike_${widget.article.articleId}_${currentUser!.uid}',
          userId: currentUser!.uid,
          articleId: widget.article.articleId,
          voteType: false,
        ));
        // If the user had previously liked the article, we need to remove that like
        if (isLiked) {
          likes--;
          isLiked = false;
          _db.voteDatabaseMethods.removeVote(
              'like_${widget.article.articleId}_${currentUser!.uid}');
        }
      }
      isDisliked = !isDisliked;
    });
  }

  void _toggleComments() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.article.content,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Like and Dislike buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: Colors.white,
                      ),
                      onPressed: _toggleLike,
                    ),
                    Text(
                      '$likes',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isDisliked
                            ? Icons.thumb_down
                            : Icons.thumb_down_outlined,
                        color: Colors.white,
                      ),
                      onPressed: _toggleDislike,
                    ),
                    Text(
                      '$dislikes',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                  onPressed: _toggleComments,
                ),
              ],
            ),
            // Expanded comments section
            if (isExpanded) ...[
              const SizedBox(height: 16),
              const Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // for (var comment in comments)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 4.0),
              //     child: Row(
              //       children: [
              //         CircleAvatar(
              //           child: Text(' '),
              //         ),
              //         const SizedBox(width: 8),
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 comment.authorName,
              //                 style: const TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               Text(
              //                 comment.text,
              //                 style: const TextStyle(color: Colors.white),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // const SizedBox(height: 16),
              // // Add new comment input field
            ],
          ],
        ),
      ),
    );
  }
}
