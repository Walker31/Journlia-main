import '../Models/article_box.dart';

List<ArticleBox> generateDummyArticles(int topicIndex) {
  switch (topicIndex) {
    case 0: // Random
      return [
        ArticleBox(
          articleId: '1',
          title: 'Random Article 1',
          author: 'John Doe',
          content: 'Random content for article 1.',
          upVotes: 10,
          downVotes: 2,
          comments: ['Comment 1', 'Comment 2'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Random Article 2',
          author: 'Jane Smith',
          content: 'Random content for article 2.',
          upVotes: 8,
          downVotes: 1,
          comments: ['Comment 1', 'Comment 2', 'Comment 3'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Random Article 3',
          author: 'Jane Smith',
          content: 'Random content for article 3.',
          upVotes: 8,
          downVotes: 1,
          comments: ['Comment 1', 'Comment 2', 'Comment 3'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Random Article 4',
          author: 'Jane Smith',
          content: 'Random content for article 4.',
          upVotes: 8,
          downVotes: 1,
          comments: ['Comment 1', 'Comment 2', 'Comment 3', 'Comment 4'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Random Article 5',
          author: 'Jane Smith',
          content: 'Random content for article 5.',
          upVotes: 8,
          downVotes: 1,
          comments: ['Comment 1', 'Comment 2', 'Comment 3'],
        ),
      ];
    case 1: // Raising Issues
      return [
        ArticleBox(
          articleId: '1',
          title: 'Issue 1',
          author: 'John Doe',
          content: 'Content for issue 1.',
          upVotes: 15,
          downVotes: 3,
          comments: ['Issue comment 1'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Issue 2',
          author: 'Jane Smith',
          content: 'Content for issue 2.',
          upVotes: 12,
          downVotes: 2,
          comments: ['Issue comment 1', 'Issue comment 2'],
        ),
      ];
    case 2: // Resource Sharing
      return [
        ArticleBox(
          articleId: '1',
          title: 'Resource Sharing 1',
          author: 'Alex Johnson',
          content: 'Content for resource sharing 1.',
          upVotes: 20,
          downVotes: 1,
          comments: ['Resource comment 1'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Resource Sharing 2',
          author: 'Emily Brown',
          content: 'Content for resource sharing 2.',
          upVotes: 18,
          downVotes: 0,
          comments: ['Resource comment 1', 'Resource comment 2'],
        ),
      ];
    case 3: // New Initiatives
      return [
        ArticleBox(
          articleId: '1',
          title: 'New Initiative 1',
          author: 'Samuel Green',
          content: 'Content for new initiative 1.',
          upVotes: 25,
          downVotes: 5,
          comments: ['New initiative comment 1'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'New Initiative 2',
          author: 'Sophia Rodriguez',
          content: 'Content for new initiative 2.',
          upVotes: 22,
          downVotes: 3,
          comments: ['New initiative comment 1', 'New initiative comment 2'],
        ),
      ];
    case 4: // Clubs
      return [
        ArticleBox(
          articleId: '1',
          title: 'Club Article 1',
          author: 'Michael Anderson',
          content: 'Content for club article 1.',
          upVotes: 18,
          downVotes: 2,
          comments: ['Club comment 1'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Club Article 2',
          author: 'Emma Wilson',
          content: 'Content for club article 2.',
          upVotes: 16,
          downVotes: 1,
          comments: ['Club comment 1', 'Club comment 2'],
        ),
      ];
    case 5: // Experience Sharing
      return [
        ArticleBox(
          articleId: '1',
          title: 'Experience Share 1',
          author: 'Daniel Lee',
          content: 'Content for experience share 1.',
          upVotes: 30,
          downVotes: 2,
          comments: ['Experience comment 1'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Experience Share 2',
          author: 'Isabella Martinez',
          content: 'Content for experience share 2.',
          upVotes: 28,
          downVotes: 1,
          comments: ['Experience comment 1', 'Experience comment 2'],
        ),
      ];
    case 6: // Internship
      return [
        ArticleBox(
          articleId: '1',
          title: 'Internship Article 1',
          author: 'William Harris',
          content: 'Content for internship article 1.',
          upVotes: 24,
          downVotes: 3,
          comments: ['Internship comment 1'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Internship Article 2',
          author: 'Olivia Clark',
          content: 'Content for internship article 2.',
          upVotes: 21,
          downVotes: 2,
          comments: ['Internship comment 1', 'Internship comment 2'],
        ),
      ];
    case 7: // Politics
      return [
        ArticleBox(
          articleId: '1',
          title: 'Politics Article 1',
          author: 'David Baker',
          content: 'Content for politics article 1.',
          upVotes: 35,
          downVotes: 5,
          comments: ['Politics comment 1'],
        ),
        ArticleBox(
          articleId: '1',
          title: 'Politics Article 2',
          author: 'Mia Garcia',
          content: 'Content for politics article 2.',
          upVotes: 32,
          downVotes: 4,
          comments: ['Politics comment 1', 'Politics comment 2'],
        ),
      ];
    default:
      return []; // Empty list as default
  }
}
