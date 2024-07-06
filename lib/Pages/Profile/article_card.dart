import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journalia/Models/article.dart';
import 'package:journalia/Models/comments.dart';
import 'package:journalia/Models/users.dart';
import 'package:journalia/Models/votes.dart';
import 'package:journalia/Utils/colors.dart';
import '../../Database/database_service.dart';
import '../../Utils/constants.dart';

class ArticleCard1 extends StatefulWidget {
  final Articles article;
  final Color lastColor;

  const ArticleCard1({
    super.key,
    required this.article,
    required this.lastColor,
  });

  @override
  ArticleCard1State createState() => ArticleCard1State();
}

class ArticleCard1State extends State<ArticleCard1> {
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
            appUser = userData as AppUser;
          });
        }
      });
    }

    // Fetch likes, dislikes, and comments from Firestore
    _fetchArticleData();
  }

  void _fetchArticleData() async {
    final voteCounts = await _db.voteDatabaseMethods.getVoteCountsForArticle(widget.article.articleId);
    final commentsStream = await _db.commentDatabaseMethods.getCommentsForArticle(widget.article.articleId);

    setState(() {
      likes = voteCounts['upvotes'] ?? 0;
      dislikes = voteCounts['downvotes'] ?? 0;
    });

    commentsStream.listen((snapshot) {
      setState(() {
        comments = snapshot.docs.map((doc) => Comments.fromMap(doc.data() as Map<String, dynamic>)).toList();
      });
    });
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
        _db.voteDatabaseMethods.removeVote('like_${widget.article.articleId}_${currentUser!.uid}');
      } else {
        likes++;
        // Add like to Firestore
        _db.voteDatabaseMethods.addVote(Vote(
          voteId: 'like_${widget.article.articleId}_${currentUser!.uid}',
          userId: currentUser!.uid,
          articleId: widget.article.articleId,
          voteType: true,
        ));

        if (isDisliked) {
          dislikes--;
          isDisliked = false;
          // Remove dislike from Firestore
          _db.voteDatabaseMethods.removeVote('dislike_${widget.article.articleId}_${currentUser!.uid}');
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
        _db.voteDatabaseMethods.removeVote('dislike_${widget.article.articleId}_${currentUser!.uid}');
      } else {
        dislikes++;
        // Add dislike to Firestore
        _db.voteDatabaseMethods.addVote(Vote(
          voteId: 'dislike_${widget.article.articleId}_${currentUser!.uid}',
          userId: currentUser!.uid,
          articleId: widget.article.articleId,
          voteType: false,
        ));

        if (isLiked) {
          likes--;
          isLiked = false;
          // Remove like from Firestore
          _db.voteDatabaseMethods.removeVote('like_${widget.article.articleId}_${currentUser!.uid}');
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

  // ignore: unused_element
  void _addComment(String comment) {
    Comments newComment = Comments(
      updatedAt: DateTime.now(),
      commentId: 'comment_${DateTime.now().millisecondsSinceEpoch}_${currentUser!.uid}',
      articleId: widget.article.articleId,
      userId: currentUser!.uid,
      content: comment,
      createdAt: DateTime.now(),
    );

    // Add comment to Firestore
    _db.commentDatabaseMethods.addComment(newComment);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.article.userId.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "- ${widget.article.userId}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            // Post's Cover Image
            Container(
              padding: const EdgeInsets.all(8),
              height: 150, // Adjust the height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/Dummy_image.png'), // Replace with your image asset
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.article.content,
              style: const TextStyle(
                fontSize: 16,
                color: textColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up_alt : Icons.thumb_up_off_alt,
                        color: tertiaryColor,
                      ),
                      onPressed: _toggleLike,
                    ),
                    const SizedBox(height: 0),
                    Text(
                      likes.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isDisliked ? Icons.thumb_down : Icons.thumb_down_off_alt,
                        color: tertiaryColor,
                      ),
                      onPressed: _toggleDislike,
                    ),
                    const SizedBox(height: 0),
                    Text(
                      dislikes.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      color: tertiaryColor,
                      onPressed: _toggleComments,
                    ),
                    Text(
                      comments.length.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, color: tertiaryColor),
                  label: const Text(
                    'Share',
                    style: TextStyle(color: tertiaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isExpanded)
              Column(
                children: comments
                    .map((comment) => ListTile(
                          title: Text(
                            comment.content,
                            style: const TextStyle(color: textColor),
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
