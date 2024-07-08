import 'dart:math';
import 'package:flutter/material.dart';
import 'package:journalia/Models/article_box.dart';
import 'package:journalia/Models/comments.dart';
import 'package:journalia/Models/users.dart';
import 'package:journalia/Models/votes.dart';
import 'package:journalia/Utils/colors.dart';
import 'package:journalia/log_page.dart';
import 'package:provider/provider.dart';
import '../../Database/database_service.dart';
import '../../Providers/user_provider.dart';
import '../../Utils/constants.dart';

class ArticleCard extends StatefulWidget {
  final ArticleBox article;
  final Color lastColor;

  const ArticleCard({
    super.key,
    required this.article,
    required this.lastColor,
  });

  @override
  ArticleCardState createState() => ArticleCardState();
}

class ArticleCardState extends State<ArticleCard> {
  int likes = 0;
  int dislikes = 0;
  bool isLiked = false;
  bool isDisliked = false;
  bool isExpanded = false;
  late Color cardColor;
  late AppUser appUser;

  final DatabaseMethods _db = DatabaseMethods();

  @override
  void initState() {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    LogData.addDebugLog('Article Id: ${widget.article.articleId}');
    super.initState();
    likes = widget.article.upVotes;
    dislikes = widget.article.downVotes;
    cardColor = getRandomColor(widget.lastColor);

    // Fetch current user data
    _fetchUserData(usersProvider);
  }

  Future<void> _fetchUserData(UsersProvider usersProvider) async {
    final currentUser = usersProvider.currentUser;
    if (currentUser != null && currentUser.role != 'Guest') {
      final userData =
          await _db.userDatabaseMethods.fetchUser(currentUser.userId);
      if (userData != null) {
        setState(() {
          appUser = userData;
        });
      }
    } else if (currentUser?.role == 'Guest') {
      final user = await usersProvider.setAsGuest();
      setState(() {
        appUser = user;
      });
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
    if (appUser.role == 'Guest') {
      // Show a message or take appropriate action for guest users
      return;
    }

// true for like, false for dislike

    setState(() {
      if (isLiked) {
        likes--;
        _removeVote('like');
      } else {
        likes++;
        _addVote('like');
        if (isDisliked) {
          dislikes--;
          _removeVote('dislike');
          isDisliked = false;
        }
      }
      isLiked = !isLiked;
    });
  }

  void _toggleDislike() {
    if (appUser.role == 'Guest') {
      // Show a message or take appropriate action for guest users
      return;
    }

    setState(() {
      if (isDisliked) {
        dislikes--;
        _removeVote('dislike');
      } else {
        dislikes++;
        _addVote('dislike');
        if (isLiked) {
          likes--;
          _removeVote('like');
          isLiked = false;
        }
      }
      isDisliked = !isDisliked;
    });
  }

  void _addVote(String voteType) {
    _db.voteDatabaseMethods.addVote(Vote(
      voteId: '${voteType}_${widget.article.articleId}_${appUser.userId}',
      userId: appUser.userId,
      articleId: widget.article.articleId,
      voteType: voteType == 'like', // true for like, false for dislike
    ));
  }

  void _removeVote(String voteType) {
    _db.voteDatabaseMethods.removeVote(
        '${voteType}_${widget.article.articleId}_${appUser.userId}');
  }

  void _toggleComments() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  int noOfComments(ArticleBox article) {
    return article.comments.length;
  }

  // ignore: unused_element
  void _addComment(String comment) {
    Comments newComment = Comments(
      updatedAt: DateTime.now(),
      commentId:
          'comment_${DateTime.now().millisecondsSinceEpoch}_${appUser.userId}',
      articleId: widget.article.articleId,
      userId: appUser.userId,
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
            if (widget.article.author.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "- ${widget.article.author}",
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
                  image: AssetImage(
                      'assets/Dummy_image.png'), // Replace with your image asset
                  // Adjust the fit as needed
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
                        isDisliked
                            ? Icons.thumb_down
                            : Icons.thumb_down_off_alt,
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
                      noOfComments(widget.article).toString(),
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
                children: widget.article.comments
                    .map((comment) => ListTile(
                          title: Text(
                            comment,
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
