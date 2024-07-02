import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ccoba1/providers/news_provider.dart'; // Sesuaikan dengan lokasi dan nama file NewsProvider Anda
import 'package:ccoba1/models/article.model.dart'; // Sesuaikan sesuai dengan model artikel Anda

class NewsCategoryPage extends StatefulWidget {
  final String category;

  const NewsCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _NewsCategoryPageState createState() => _NewsCategoryPageState();
}

class _NewsCategoryPageState extends State<NewsCategoryPage> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('News Category: $selectedCategory'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _showSearchDialog(context);
              },
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {
                setState(() {
                  selectedCategory = result;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Semua Kategori',
                  child: Text('Semua Kategori'),
                ),
                PopupMenuItem<String>(
                  value: 'Technology',
                  child: Text('Technology'),
                ),
                PopupMenuItem<String>(
                  value: 'Sports',
                  child: Text('Sports'),
                ),
                PopupMenuItem<String>(
                  value: 'Economy',
                  child: Text('Economy'),
                ),
                PopupMenuItem<String>(
                  value: 'Entertainment',
                  child: Text('Entertainment'),
                ),
              ],
            ),
          ],
        ),
        body: Consumer<NewsProvider>(
          builder: (context, newsProvider, _) {
            if (!newsProvider.isLoading && newsProvider.resNews == null) {
              newsProvider.getNewsByCategory(selectedCategory); // Fetch news by selected category
            }

            if (newsProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (newsProvider.isDataEmpty) {
              return Center(child: Text('No news available for $selectedCategory'));
            }

            // Display up to 20 news articles
            List<Article> filteredArticles =
                _filterArticlesByCategory(newsProvider.resNews?.articles, selectedCategory);
            int itemCount = filteredArticles.length > 20 ? 20 : filteredArticles.length;

            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.description ?? 'No Description'),
                  leading: article.urlToImage.isNotEmpty
                      ? Image.network(article.urlToImage, width: 100, height: 100, fit: BoxFit.cover)
                      : Container(width: 100, height: 100, color: Colors.grey),
                );
              },
            );
          },
        ),
      ),
    );
  }
List<Article> _filterArticlesByCategory(List<Article>? articles, String category) {
  if (articles == null || articles.isEmpty) {
    return [];
  }

  // Ubah kategori menjadi huruf kecil untuk memastikan kesesuaian yang lebih baik
  String categoryLower = category.toLowerCase();

  if (categoryLower == 'semua kategori') {
    return articles;
  } else {
    // Filter artikel berdasarkan judul yang mengandung kata kunci kategori yang dipilih
    return articles
        .where((article) => article.title.toLowerCase().contains(categoryLower))
        .toList();
  }
}

void _showSearchDialog(BuildContext context) {
  TextEditingController searchController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Search News'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search by title',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Search'),
            onPressed: () {
              String query = searchController.text;
              if (query.isNotEmpty) {
                // Panggil fungsi untuk mencari berita berdasarkan judul
                Provider.of<NewsProvider>(context, listen: false).fetchNewsByTitle(query);
              }
              // Reset nilai pada kontroler teks setelah pencarian selesai
              searchController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}