import 'package:flutter/material.dart';
// import '../api/api_service.dart';
// import '../components/recipe_thumbnail.dart';
// import '../models/simple_recipe.dart';
import '../api/st_api_service.dart';

class Reservas_Screen extends StatelessWidget {
  Reservas_Screen({super.key});

  // final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Reservas_Screen');
    // return Center(child: Card2());
    // return FutureBuilder(
    //     future: apiService.getRecipes(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState != ConnectionState.done) {
    //         return Center(child: CircularProgressIndicator());
    //       }

    //       return RecipesGrid(recipes: snapshot.data ?? []);
    //     });
  }
}

// class RecipesGrid extends StatelessWidget {
//   RecipesGrid({super.key, required this.recipes});

//   final List<SimpleRecipe> recipes;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//       itemCount: recipes.length,
//       itemBuilder: (context, index) {
//         final simpleRecipe = recipes[index];

//         return RecipeThumbnail(simpleRecipe: simpleRecipe);
//       },
//     );
//   }
// }
