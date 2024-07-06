import 'package:cloud_firestore/cloud_firestore.dart';
import '../log_page.dart'; // Import your LogData class

class TopicDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _topicsCollection = 'Topics';

  /// Retrieves a stream of all topics from Firestore.
  Future<Stream<QuerySnapshot>> getTopics() async {
    try {
      return _firestore.collection(_topicsCollection).snapshots();
    } catch (e, stackTrace) {
      LogData.addErrorLog('Error getting topics: $e\n$stackTrace');
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }

  Future<int?> getTopicIdByName(String topicName) async {
    try {
      final querySnapshot = await _firestore
          .collection(_topicsCollection)
          .where('topicName', isEqualTo: topicName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final topicId = document.data()['topicId'];

        // Ensure topicId is treated as an int
        if (topicId is int) {
          LogData.addDebugLog('Topic ID: $topicId');
          return topicId;
        } else {
          throw TypeError(); // Unexpected type
        }
      }
      return null;
    } catch (e, stackTrace) {
      LogData.addErrorLog('Error getting topic ID by name: $e\n$stackTrace');
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }

  /// Returns null if no topic with the specified ID is found.
  Future<String?> getTopicNameById(String topicId) async {
    try {
      final querySnapshot =
          await _firestore.collection(_topicsCollection).doc(topicId).get();

      if (querySnapshot.exists) {
        LogData.addDebugLog(querySnapshot.data()?['topicName']);
        return querySnapshot.data()?['topicName'];
      }
      return null;
    } catch (e, stackTrace) {
      LogData.addErrorLog('Error getting topic name by ID: $e\n$stackTrace');
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }

  /// Retrieves a list of all topics as strings from Firestore.
  Future<List<String>> getAllTopics() async {
    try {
      final querySnapshot =
          await _firestore.collection(_topicsCollection).get();

      return querySnapshot.docs
          .map((doc) => doc['topicName'] as String)
          .toList();
    } catch (e, stackTrace) {
      LogData.addErrorLog('Error getting all topics: $e\n$stackTrace');
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }
}
