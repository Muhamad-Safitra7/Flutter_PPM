import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ccoba1/component/news.dart'; // Pastikan model Article sesuai dengan struktur berita Anda
import 'package:ccoba1/pages/search_page.dart';
import 'package:ccoba1/providers/news_provider.dart';
import 'package:ccoba1/models/topNews.model.dart'; // Pastikan model Article sesuai dengan struktur berita Anda
import 'package:ccoba1/models/article.model.dart'; // Pastikan model Article sesuai dengan struktur berita Anda

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _currentDateTime = '';
  String _selectedCategory = 'All Categories';

  List<String> _categories = [
    'All Categories',
    'Technology',
    'Sports',
    'Economy',
    'Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    Provider.of<NewsProvider>(context, listen: false).fetchTopNews("");
  }

  Future<void> _refreshNews() async {
    await Provider.of<NewsProvider>(context, listen: false).fetchTopNews("");
  }

  void _updateDateTime() {
    setState(() {
      _currentDateTime =
          DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), () => _updateDateTime());
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    Provider.of<NewsProvider>(context, listen: false)
        .getNewsByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return RefreshIndicator(
          onRefresh: _refreshNews,
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Berita Terbaru'),
                  Text(
                    _currentDateTime,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
                _buildCategoryPopupMenu(),
              ],
            ),
            body: _buildNewsList(newsProvider),
          ),
        );
      },
    );
  }

  Widget _buildCategoryPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: _onCategorySelected,
      itemBuilder: (BuildContext context) {
        return _categories.map((String category) {
          return PopupMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList();
      },
      initialValue: _selectedCategory,
    );
  }

  Widget _buildNewsList(NewsProvider newsProvider) {
    if (newsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (newsProvider.resNews == null ||
        newsProvider.resNews!.articles.isEmpty) {
      return const Center(child: Text("No news available."));
    } else {
      List<Article> filteredArticles = _selectedCategory == 'All Categories'
          ? newsProvider.resNews!.articles
          : newsProvider.resNews!.articles
              .where((article) => article.title
                  .toLowerCase()
                  .contains(_selectedCategory.toLowerCase()))
              .toList();

      return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: filteredArticles.length > 20 ? 20 : filteredArticles.length,
        itemBuilder: (context, index) {
          final article = filteredArticles[index];
          return News(
            title: article.title,
            image: article.urlToImage,
            content: article.content,
          );
        },
      );
    }
  }
}
