import 'package:flutter/material.dart';

import '../models/explore_recipe.dart';
import 'card1.dart';
import 'card2.dart';
import 'card3.dart';

class TodayRecipeListView extends StatelessWidget {
  TodayRecipeListView({super.key, required this.recipes});

  final List<ExploreRecipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Recipes of the day",
          style: Theme.of(context).textTheme.displayLarge),
      Container(
        height: 400,
        color: Colors.transparent,
        child: ListView.separated(
          itemCount: recipes.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 16,
            );
          },
          itemBuilder: (context, index) {
            return buildCard(recipes[index]);
          },
        ),
      )
    ]);
  }

  Widget buildCard(ExploreRecipe recipe) {
    switch (recipe.cardType) {
      case CardTypes.Card1:
        return Card1(
          recipe: recipe,
        );
      case CardTypes.Card2:
        return Card2(
          recipe: recipe,
        );
      case CardTypes.Card3:
        return Card3(
          recipe: recipe,
        );
      default:
        throw Exception("This card does not exists");
    }
  }
}
