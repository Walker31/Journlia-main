class Comments {
  final String commentId;
  final String articleId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comments({
    required this.articleId,
    required this.userId,
    required this.commentId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      commentId: json['commentId'],
      content: json['content'],
      articleId: json['articleId'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static Comments fromMap(Map<String, dynamic> map) => Comments(
        commentId: map['commentId'] as String,
        articleId: map['articleId'] as String,
        userId: map['userId'] as String,
        content: map['content'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'articleId': articleId,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
