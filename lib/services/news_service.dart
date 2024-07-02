import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ccoba1/models/topNews.model.dart'; // Adjust according to your news model

class NewsService {
  final String baseUrl = 'https://newsapi.org/v2/';
  final String apiKey = '4ee3fccaa7b348548693feedcf8263c0'; // Replace with your News API key

  Future<NewsModel> fetchTopNews(String query) async {
    String url = query.isEmpty
        ? '${baseUrl}top-headlines?sources=cnn&apiKey=$apiKey' // Assuming CNN Indonesia uses 'cnn' as a source in News API
        : '${baseUrl}everything?q=$query&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<NewsModel> getNewsByCategory(String category) async {
    String url = '${baseUrl}top-headlines?sources=cnn&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news by category');
    }
  }

  Future<NewsModel> fetchNewsByTitle(String title) async {
    String url = '${baseUrl}everything?q=$title&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news by title');
    }
  }

  Future<NewsModel> searchByDescription(String query) async {
    String url = '${baseUrl}everything?qInTitle=$query&apiKey=$apiKey'; // Search by keyword in description

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news by description');
    }
  }
}
