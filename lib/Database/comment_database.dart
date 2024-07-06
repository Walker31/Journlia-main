import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../Models/comments.dart';
import 'dart:math';
import '../log_page.dart'; // Import LogData class for logging

class CommentDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _commentsCollection = 'Comments';

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

  // Add comment
  Future<void> addComment(Comments comment) async {
    try {
      final commentData = comment.toMap();
      await _firestore
          .collection(_commentsCollection)
          .doc(comment.commentId)
          .set(commentData);

      // Log debug message
      LogData.addDebugLog('Comment added successfully');
    } catch (e) {
      Logger().e('Error adding comment: $e');
      // Log error message
      LogData.addErrorLog('Error adding comment: $e');
      // Handle error as per your application's requirements
    }
  }

  // Get all comments for a specific article
  Future<Stream<QuerySnapshot>> getCommentsForArticle(String articleId) async {
    try {
      return _firestore
          .collection(_commentsCollection)
          .where('articleId', isEqualTo: articleId)
          .snapshots();
    } catch (e) {
      Logger().e('Error getting comments for article: $e');
      // Log error message
      LogData.addErrorLog('Error getting comments for article: $e');
      rethrow; // Propagate the error up the call stack
    }
  }

  // Update comment
  Future<void> updateComment(String commentId, String newContent) async {
    try {
      await _firestore.collection(_commentsCollection).doc(commentId).update({
        'content': newContent,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Log debug message
      LogData.addDebugLog('Comment updated successfully');
    } catch (e) {
      Logger().e('Error updating comment: $e');
      // Log error message
      LogData.addErrorLog('Error updating comment: $e');
      // Handle error as per your application's requirements
    }
  }

  // Delete comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection(_commentsCollection).doc(commentId).delete();

      // Log debug message
      LogData.addDebugLog('Comment deleted successfully');
    } catch (e) {
      Logger().e('Error deleting comment: $e');
      // Log error message
      LogData.addErrorLog('Error deleting comment: $e');
      // Handle error as per your application's requirements
    }
  }
}
