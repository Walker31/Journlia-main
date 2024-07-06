import 'package:flutter/material.dart';
import 'package:journalia/database/topic_database.dart';
import 'package:journalia/log_page.dart';
import 'package:journalia/models/topic.dart'; // Adjust the import as per your folder structure

class TopicProvider extends ChangeNotifier {
  List<Topic> _topics = []; // Initial list of topics

  // Initialize an instance of TopicDatabaseMethods
  final TopicDatabaseMethods _db = TopicDatabaseMethods();

  // Method to fetch topics from Firestore
  Future<void> fetchTopics() async {
    try {
      List<Topic> fetchedTopics = [];
      List<String> topicNames = await _db.getAllTopics();

      for (String name in topicNames) {
        int topicId = await _db.getTopicIdByName(name) as int; // Fetch topicId for each topic name
        fetchedTopics.add(Topic(topicName: name, topicId: topicId)); // Create Topic object with both name and id
      }

      _topics = fetchedTopics;
      notifyListeners(); // Notify listeners after data is updated
    } catch (e, stackTrace) {
      LogData.addErrorLog('Error fetching topics: $e\n$stackTrace');
      // Handle error as needed
    }
  }

  // Getter for topics
  List<Topic> get topics => _topics;

  // Method to add a new topic
  void addTopic(Topic topic) {
    _topics.add(topic);
    notifyListeners(); // Notify listeners after data is updated
  }

  // Method to update an existing topic
  void updateTopic(Topic updatedTopic) {
    // Find and update the topic in the list
    final index = _topics.indexWhere((topic) => topic.topicId == updatedTopic.topicId);
    if (index != -1) {
      _topics[index] = updatedTopic;
      notifyListeners(); // Notify listeners after data is updated
    }
  }

  // Method to delete a topic
  void deleteTopic(Topic topic) {
    _topics.remove(topic);
    notifyListeners(); // Notify listeners after data is updated
  }
}
