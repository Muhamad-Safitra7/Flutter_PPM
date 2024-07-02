import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String content;

  const NewsDetailPage({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty)
                Image.network(imageUrl!)
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey,
                  child: Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}
