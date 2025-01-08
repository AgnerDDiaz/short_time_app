import 'package:flutter/material.dart';
import 'package:short_time_app/short_time_themes.dart';

import 'circle_image.dart';


class AuthorCard extends StatefulWidget {
  const AuthorCard(
      {super.key,
      required this.authorName,
      required this.title,
      this.imageProvider});

  final String authorName;
  final String title;
  final ImageProvider? imageProvider;

  @override
  State<AuthorCard> createState() => _AuthorCardState();
}

class _AuthorCardState extends State<AuthorCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleImageWidget(
                imageProvider: widget.imageProvider,
                radius: 28,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Text(
                    widget.authorName,
                    style: ShortTimeThemes.lightTextTheme.bodyLarge,
                  ),
                  Text(
                    widget.title,
                    style: ShortTimeThemes.lightTextTheme.bodyLarge,
                  )
                ],
              )
            ],
          ),
          IconButton(
              iconSize: 30,
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Favorite pressed")));
              },
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border))
        ],
      ),
    );
  }
}
