class Topic {
  final int topicId;
  final String topicName;

  Topic({required this.topicId, required this.topicName});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topicId'],
      topicName: json['topicName'],
    );
  }

  static Topic fromMap(Map<String, dynamic> map) => Topic(
        topicId: map['topicId'] as int,
        topicName: map['topicName'] as String,
      );

  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'topicName': topicName,
    };
  }
}
