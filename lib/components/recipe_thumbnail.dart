import 'package:flutter/material.dart';

import '../models/simple_recipe.dart';

class RecipeThumbnail extends StatelessWidget {
  RecipeThumbnail({
    super.key,
    required this.simpleRecipe,
  });

  final SimpleRecipe simpleRecipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  simpleRecipe.dishImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(simpleRecipe.title,
                maxLines: 1, style: Theme.of(context).textTheme.bodyLarge),
            Text(simpleRecipe.duration,
                maxLines: 1, style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
      ),
    );
  }
}
