import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../Auth/firebase_auth_services.dart';
import '../Models/article.dart';
import '../log_page.dart'; // Import LogData class for logging

class ArticleDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _articlesCollection = 'Articles';

  // Add article
  Future<void> addArticle(
    String content,
    String title,
    int topicId,
  ) async {
    try {
      final articleData = Articles(
        articleId: generateArticleId(),
        topicId: topicId,
        userId: FirebaseAuthService().currentUser!.uid,
        title: title,
        imageUrl: '',
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).toMap();
      await _firestore.collection(_articlesCollection).doc().set(articleData);

      // Log debug message
      LogData.addDebugLog('Article added successfully');
    } catch (e) {
      Logger().e('Error adding article: $e');
      // Log error message
      LogData.addErrorLog('Error adding article: $e');
      // Handle error as per your application's requirements
    }
  }

  // Update article with partial data
  Future<void> updateArticle(
    String articleId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection(_articlesCollection)
          .doc(articleId)
          .update(updatedData);

      // Log debug message
      LogData.addDebugLog('Article updated successfully');
    } catch (e) {
      Logger().e('Error updating article: $e');
      // Log error message
      LogData.addErrorLog('Error updating article: $e');
      // Handle error as per your application's requirements
    }
  }

  // Get all articles stream
  Future<Stream<QuerySnapshot>> getArticles() async {
    try {
      return _firestore
          .collection(_articlesCollection)
          .orderBy('updatedAt', descending: true)
          .snapshots();
    } catch (e) {
      Logger().e('Error getting articles: $e');
      // Log error message
      LogData.addErrorLog('Error getting articles: $e');
      rethrow; // Propagate the error up the call stack
    }
  }

  // Get articles by topic
  Future<QuerySnapshot> getArticlesByTopic(String topic) async {
    try {
      return await _firestore
          .collection(_articlesCollection)
          .where('topic', isEqualTo: topic)
          .get();
    } catch (e) {
      Logger().e('Error getting articles by topic: $e');
      // Log error message
      LogData.addErrorLog('Error getting articles by topic: $e');
      rethrow; // Propagate the error up the call stack
    }
  }

  // Search article
  Future<List<Articles>> searchArticle(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_articlesCollection)
          .where('articleId', isEqualTo: query) // Search by articleId
          .where('title', isEqualTo: query) // Search by title
          .where('content', isEqualTo: query) // Search by content
          .get();

      List<Articles> articles = snapshot.docs.map((doc) {
        return Articles.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      // Log debug message
      LogData.addDebugLog('Article search successful');
      return articles;
    } catch (e) {
      Logger().e('Error searching for article: $e');
      // Log error message
      LogData.addErrorLog('Error searching for article: $e');
      return []; // Handle error or return default value
    }
  }

  // Get user articles
  Future<QuerySnapshot> getUserArticles(String userId) async {
    try {
      return await _firestore
          .collection(_articlesCollection)
          .where('userId', isEqualTo: userId)
          .get();
    } catch (e) {
      Logger().e('Error getting user articles: $e');
      // Log error message
      LogData.addErrorLog('Error getting user articles: $e');
      rethrow; // Propagate the error up the call stack
    }
  }

  // Delete article
  Future<void> deleteArticle(String articleId) async {
    try {
      await _firestore.collection(_articlesCollection).doc(articleId).delete();

      // Log debug message
      LogData.addDebugLog('Article deleted successfully');
    } catch (e) {
      Logger().e('Error deleting article: $e');
      // Log error message
      LogData.addErrorLog('Error deleting article: $e');
      // Handle error as per your application's requirements
    }
  }

  // Generate unique article ID
  String generateArticleId() {
    final DateTime now = DateTime.now();
    final int timestamp = now.millisecondsSinceEpoch;
    final String randomString = _generateRandomString(6);
    return '$timestamp$randomString';
  }

  // Generate random string for article ID
  String _generateRandomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }
}
