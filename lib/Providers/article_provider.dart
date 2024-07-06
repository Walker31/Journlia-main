import 'package:flutter/material.dart';

import '../Models/article_box.dart';

class ArticleProvider extends ChangeNotifier {
  List<ArticleBox> _articles = []; // Initial list of articles

  // Method to fetch articles (replace with actual data fetch logic)
  Future<void> fetchArticles() async {
    // Simulate fetching data from API or database
    _articles = [
      ArticleBox(
        articleId: '2',
        title: "Sample Article",
        author: "John Doe",
        content: "This is a sample article content.",
        upVotes: 10,
        downVotes: 2,
        comments: [],
      ),
      // Add more articles here
    ];
    notifyListeners(); // Notify listeners after data is updated
  }

  // Getter for articles
  List<ArticleBox> get articles => _articles;

  // Method to add new article
  void addArticle(ArticleBox article) {
    _articles.add(article);
    notifyListeners(); // Notify listeners after data is updated
  }

  // Method to update existing article
  void updateArticle(ArticleBox updatedArticle) {
    // Find and update the article in the list
    final index = _articles.indexWhere((article) => article.title == updatedArticle.title);
    if (index != -1) {
      _articles[index] = updatedArticle;
      notifyListeners(); // Notify listeners after data is updated
    }
  }

  // Method to delete article
  void deleteArticle(ArticleBox article) {
    _articles.remove(article);
    notifyListeners(); // Notify listeners after data is updated
  }
}
