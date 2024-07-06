import 'dart:math';

import 'article_database.dart';
import 'comment_database.dart';
import 'topic_database.dart';
import 'user_database.dart';
import 'vote_database.dart';

class DatabaseMethods {
  final UserDatabaseMethods userDatabaseMethods = UserDatabaseMethods();
  final TopicDatabaseMethods topicDatabaseMethods = TopicDatabaseMethods();
  final ArticleDatabaseMethods articleDatabaseMethods = ArticleDatabaseMethods();
  final CommentDatabaseMethods commentDatabaseMethods = CommentDatabaseMethods();
  final VoteDatabaseMethods voteDatabaseMethods = VoteDatabaseMethods();

  // Utility to generate a unique ID
  String generateUniqueId() {
    final DateTime now = DateTime.now();
    final int timestamp = now.millisecondsSinceEpoch;
    final String randomString = _generateRandomString(6);
    return '$timestamp$randomString';
  }

  String _generateRandomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }
}
