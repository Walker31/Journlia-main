
class ArticleBox {
  final String title;
  final String author;
  final String content;
  final String articleId;
  final int upVotes;
  final int downVotes;
  final List<String> comments;

  ArticleBox({
    required this.articleId,
    required this.title,
    required this.author,
    required this.content,
    required this.upVotes,
    required this.downVotes,
    required this.comments,
  });

  // Convert an ArticleBox instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'title': title,
      'author': author,
      'content': content,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'comments': comments,
    };
  }

  // Create an ArticleBox instance from a Map
  factory ArticleBox.fromMap(Map<String, dynamic> map) {
    return ArticleBox(
      articleId: map['articleId'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      content: map['content'] as String,
      upVotes: map['upVotes'] as int,
      downVotes: map['downVotes'] as int,
      comments: List<String>.from(map['comments']),
    );
  }
}
