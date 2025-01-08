import 'package:flutter/material.dart';
import 'package:short_time_app/short_time_themes.dart';


import '../models/explore_recipe.dart';

class Card1 extends StatelessWidget {
  const Card1({super.key, required this.recipe});

  final ExploreRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints.expand(
            width: 350,
            height: 350,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(recipe.backgroundImage), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Text(recipe.subtitle, style: ShortTimeThemes.darkTextTheme.bodyLarge),
              Positioned(
                  top: 20,
                  child: Text(recipe.title,
                      style: ShortTimeThemes.darkTextTheme.titleLarge)),
              Positioned(
                  bottom: 30,
                  right: 0,
                  child: Text(recipe.description,
                      style: ShortTimeThemes.darkTextTheme.bodyLarge)),
              Positioned(
                  bottom: 10,
                  right: 0,
                  child: Text(recipe.authorName,
                      style: ShortTimeThemes.darkTextTheme.bodyLarge)),
            ],
          )),
    );
  }
}
