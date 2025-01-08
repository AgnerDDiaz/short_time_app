import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/explore_data.dart';
import '../models/explore_recipe.dart';
import '../models/post.dart';
import '../models/simple_recipe.dart';

class ApiService {
  Future<String> _loadAssets(String path) async {
    return rootBundle.loadString(path);
  }

  Future<List<SimpleRecipe>> getRecipes() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    //Se trae el json desde nuestro archivo
    final data = await _loadAssets('assets/sample_data/sample_recipes.json');

    //Se convierte el json a un mapa
    final Map<String, dynamic> json = jsonDecode(data);

    // Se navega el mapa y se convierte a objetos tipo SimpleRecipe
    if (json['recipes'] != null) {
      final recipes = <SimpleRecipe>[];
      json['recipes'].forEach((value) {
        recipes.add(SimpleRecipe.fromJson(value));
      });

      return recipes; //Devolvemos la lista de objetos SimpleRecipes
    }

    return []; //Si tira error retorna una lista vacía
  }

  Future<List<Post>> getFriendPosts() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final data =
        await _loadAssets('assets/sample_data/sample_friends_feed.json');

    final Map<String, dynamic> json = jsonDecode(data);

    if (json['feed'] != null) {
      final posts = <Post>[];
      json['feed'].forEach((value) {
        posts.add(Post.fromJson(value));
      });

      return posts;
    }

    return [];
  }

  Future<List<ExploreRecipe>> getTodayRecipes() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final data =
        await _loadAssets('assets/sample_data/sample_explore_recipes.json');

    final Map<String, dynamic> json = jsonDecode(data);

    if (json['recipes'] != null) {
      final exploreRecipes = <ExploreRecipe>[];
      json['recipes'].forEach((value) {
        try {
          exploreRecipes.add(ExploreRecipe.fromJson(value));
          print("after from json");
          print(ExploreRecipe.fromJson(value).backgroundImage);
          print("-----------------LONGITUD RECIPES");
          print(exploreRecipes.length);
        } catch (e) {
          print("Exception");
        }
      });

      print("-----------------COMPLETADOA--------------------");
      print(exploreRecipes.length);
      return exploreRecipes;
    }

    return [];
  }

  Future<ExploreData> getExploreData() async {
    final todayRecipes = await getTodayRecipes();
    final friendPosts = await getFriendPosts();

    return ExploreData(todayRecipes, friendPosts);
  }
}
