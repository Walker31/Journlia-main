import 'package:flutter/material.dart';
import 'package:journalia/Models/topic.dart';
import 'package:journalia/Database/topic_database.dart';

class TopicProvider with ChangeNotifier {
  List<Topic> _topics = [];

  List<Topic> get topics => _topics;

  TopicProvider() {
    fetchTopics();
  }

  void fetchTopics() async {
    try {
      List<Topic> fetchedTopics = await TopicDatabaseMethods().getAllTopics();
      _topics = fetchedTopics;
      notifyListeners();
    } catch (error) {
      // Handle the error
    }
  }

  void setTopics(List<Topic> topics) {
    _topics = topics;
    notifyListeners();
  }
}
