class Vote {
  final String voteId;
  final String articleId;
  final String userId;
  final bool voteType;

  Vote({
    required this.voteId,
    required this.articleId,
    required this.userId,
    required this.voteType,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      voteId: json['voteId'],
      articleId: json['articleId'],
      userId: json['userId'],
      voteType: json['voteType'],
    );
  }

  static Vote fromMap(Map<String, dynamic> map) => Vote(
        voteId: map['voteId'] as String,
        articleId: map['articleId'] as String,
        userId: map['userId'] as String,
        voteType: map['voteType'] as bool,
      );

  Map<String, dynamic> toMap() {
    return {
      'voteId': voteId,
      'articleId': articleId,
      'userId': userId,
      'voteType': voteType,
    };
  }
}
