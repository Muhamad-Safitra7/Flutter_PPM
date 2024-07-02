
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ccoba1/providers/news_provider.dart';
import 'package:ccoba1/component/news.dart'; // Sesuaikan dengan lokasi dan nama komponen News Anda

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cari Berita'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Cari Berita ...',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Panggil metode pencarian berdasarkan judul dari NewsProvider
                          newsProvider.fetchNewsByTitle(searchController.text);
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildSearchResult(newsProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResult(NewsProvider newsProvider) {
    if (newsProvider.isDataEmpty) {
      return const Center(child: Text("Tidak ada berita ditemukan"));
    } else if (newsProvider.isLoadingSearch) {
      return const Center(child: CircularProgressIndicator());
    } else if (newsProvider.resSearch == null || newsProvider.resSearch!.articles.isEmpty) {
      return const Center(child: Text("Tidak ada hasil pencarian"));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: newsProvider.resSearch!.articles.length,
        itemBuilder: (context, index) {
          final article = newsProvider.resSearch!.articles[index];
          return News(
            title: article.title ?? '',
            image: article.urlToImage ?? '',
            content: article.content ?? 'No content available',
          );
        },
      );
    }
  }
}
