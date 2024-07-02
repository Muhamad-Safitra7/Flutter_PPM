import 'package:ccoba1/pages/news_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class News extends StatelessWidget {
  final String title;
  final String image;
  final String content;

  const News({
    required this.title,
    required this.image,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              title: title,
              imageUrl: image,
              content: content,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: image.isNotEmpty
              ? FancyShimmerImage(
                  imageUrl: image,
                  boxFit: BoxFit.cover,
                  width: 100,
                  height: 100,
                )
              : Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
          title: Text(
            title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
