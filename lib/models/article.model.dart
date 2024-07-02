class Article {
  String title;
  String? description;
  String urlToImage;
  String content;

  Article({
    required this.title,
    this.description,
    required this.urlToImage,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      urlToImage: json['urlToImage'] ?? '',
      content: json['content'] ?? 'No content available',
    );
  }
}
