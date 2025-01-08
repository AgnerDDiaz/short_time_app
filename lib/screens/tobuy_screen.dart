import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/grocery_manager.dart';
import 'empty_grocery_screen.dart';


class TobuyScreen extends StatelessWidget {
  const TobuyScreen({super.key});



  @override
  Widget build(BuildContext context) {
    // return Card3();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          onPressed: () {},
        child: Icon(Icons.add, color: Colors.white,),
      ),
      body: buildGroceryScreen(),
    );
  }

  Consumer<GroceryManager> buildGroceryScreen() {
    return Consumer<GroceryManager>(
      builder: (context, manager, child,){
        if(manager.groceryItem.isNotEmpty){
          return Container();
        }else{
          return EmptyGroceryScreen();
        }
      });
  }
}
