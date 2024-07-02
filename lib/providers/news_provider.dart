import 'package:flutter/material.dart';
import 'package:ccoba1/models/topNews.model.dart'; // Sesuaikan dengan model berita Anda
import 'package:ccoba1/services/news_service.dart'; // Sesuaikan dengan layanan berita Anda

class NewsProvider with ChangeNotifier {
  NewsModel? _resNews;
  NewsModel? _resSearch;
  bool _isLoading = false;
  bool _isLoadingSearch = false;
  bool _isDataEmpty = false;

  NewsModel? get resNews => _resNews;
  NewsModel? get resSearch => _resSearch;
  bool get isLoading => _isLoading;
  bool get isLoadingSearch => _isLoadingSearch;
  bool get isDataEmpty => _isDataEmpty;

  Future<void> fetchTopNews(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _resNews = await NewsService().fetchTopNews(query); // Menggunakan layanan untuk mengambil berita teratas
      _isDataEmpty = _resNews?.articles.isEmpty ?? true;
    } catch (e) {
      _isDataEmpty = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getNewsByCategory(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      _resNews = await NewsService().getNewsByCategory(category); // Menggunakan layanan untuk mengambil berita berdasarkan kategori
      _isDataEmpty = _resNews?.articles.isEmpty ?? true;
    } catch (e) {
      _isDataEmpty = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNewsByTitle(String title) async {
    _isLoadingSearch = true;
    _isDataEmpty = false;
    notifyListeners();

    try {
      _resSearch = await NewsService().fetchNewsByTitle(title); // Menggunakan layanan untuk mencari berita berdasarkan judul
      _isDataEmpty = _resSearch?.articles.isEmpty ?? true;
    } catch (e) {
      _isDataEmpty = true;
      _resSearch = null;
    }

    _isLoadingSearch = false;
    notifyListeners();
  }

  Future<void> searchByDescription(String query) async {
    _isLoadingSearch = true;
    _isDataEmpty = false;
    notifyListeners();

    try {
      _resSearch = await NewsService().searchByDescription(query); // Menggunakan layanan untuk mencari berita berdasarkan deskripsi
      _isDataEmpty = _resSearch?.articles.isEmpty ?? true;
    } catch (e) {
      _isDataEmpty = true;
      _resSearch = null;
    }

    _isLoadingSearch = false;
    notifyListeners();
  }
}
