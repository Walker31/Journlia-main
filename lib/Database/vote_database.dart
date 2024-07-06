import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../Models/votes.dart';
import '../log_page.dart'; // Import LogData class

class VoteDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _votesCollection = 'Votes';

  // Add vote
  Future<void> addVote(Vote vote) async {
    final voteData = vote.toMap();
    try {
      await _firestore.collection(_votesCollection).doc(vote.voteId).set(voteData);
      LogData.addDebugLog('Vote added: ${vote.voteId}');
    } catch (e) {
      Logger().e('Error adding vote: $e');
      LogData.addErrorLog('Error adding vote: $e');
      // Handle error as per your application's requirements
    }
  }

  // Remove vote
  Future<void> removeVote(String voteId) async {
    try {
      await _firestore.collection(_votesCollection).doc(voteId).delete();
      LogData.addDebugLog('Vote removed: $voteId');
    } catch (e) {
      Logger().e('Error removing vote: $e');
      LogData.addErrorLog('Error removing vote: $e');
      // Handle error as per your application's requirements
    }
  }

  // Get all votes stream
  Future<Stream<QuerySnapshot>> getVotes() async {
    try {
      return _firestore.collection(_votesCollection).snapshots();
    } catch (e) {
      Logger().e('Error fetching votes stream: $e');
      LogData.addErrorLog('Error fetching votes stream: $e');
      rethrow; // Rethrow the error for higher-level error handling
    }
  }

  // Get all votes for a specific article
  Future<Stream<QuerySnapshot>> getVotesForArticle(String articleId) async {
    try {
      return _firestore
          .collection(_votesCollection)
          .where('articleId', isEqualTo: articleId)
          .snapshots();
    } catch (e) {
      Logger().e('Error fetching votes for article: $e');
      LogData.addErrorLog('Error fetching votes for article: $e');
      rethrow; // Rethrow the error for higher-level error handling
    }
  }

  // Get number of votes for an article (up, down)
  Future<Map<String, int>> getVoteCountsForArticle(String articleId) async {
    try {
      final upvotesQuery = await _firestore
          .collection(_votesCollection)
          .where('articleId', isEqualTo: articleId)
          .where('voteType', isEqualTo: 'upvote')
          .get();

      final downvotesQuery = await _firestore
          .collection(_votesCollection)
          .where('articleId', isEqualTo: articleId)
          .where('voteType', isEqualTo: 'downvote')
          .get();

      final int upvoteCount = upvotesQuery.docs.length;
      final int downvoteCount = downvotesQuery.docs.length;

      LogData.addDebugLog('Vote counts fetched for article: $articleId');
      return {'upvotes': upvoteCount, 'downvotes': downvoteCount};
    } catch (e) {
      Logger().e('Error fetching vote counts for article: $e');
      LogData.addErrorLog('Error fetching vote counts for article: $e');
      return {'upvotes': 0, 'downvotes': 0}; // Handle error or return default value
    }
  }
}
