class Articles {
  final String articleId;
  final int topicId;
  final String userId;
  final String? imageUrl;
  final String content;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  Articles({
    required this.articleId,
    required this.topicId,
    required this.userId,
    this.imageUrl,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      articleId: json['articleId'] ?? '',
      topicId: json['topicId'] ?? 0,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  static Articles fromMap(Map<String, dynamic> map) {
    return Articles(
      articleId: map['articleId'] ?? '',
      topicId: map['topicId'] ?? '',
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'topicId': topicId,
      'userId': userId,
      'imageUrl': imageUrl ?? '',
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
