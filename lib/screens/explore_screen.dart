import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../components/friend_post_list_view.dart';
import '../components/today_recipe_list_view.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiService.getExploreData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(scrollDirection: Axis.vertical, children: [
            TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
            FriendPostListView(friendPost: snapshot.data?.friendPost ?? [])
          ]);
          //Carrousel
        });
  }
}
