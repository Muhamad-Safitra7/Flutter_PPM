import 'package:ccoba1/models/article.model.dart'; // Sesuaikan dengan lokasi dan nama model Article Anda
// Example structure of NewsModel
class NewsModel {
  final List<Article> articles;

  NewsModel({required this.articles});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    var articlesList = json['articles'] as List;
    List<Article> articles =
        articlesList.map((articleJson) => Article.fromJson(articleJson)).toList();

    return NewsModel(articles: articles);
  }
}