import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tab_manager.dart';


class EmptyGroceryScreen extends StatelessWidget {
  const EmptyGroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            child: AspectRatio(
                aspectRatio: 1/1,
              child: Image.asset("assets/grocery_pics/groceryimage.png"),
            ),
        ),
        Text('No Groceries', style: Theme.of(context).textTheme.displayLarge,),
        SizedBox(
          height: 16,
        ),
        Text("Shopping for ingredients?\nTap the +", textAlign: TextAlign.center,),

        MaterialButton(
          onPressed: (){
          Provider.of<TabManager>(context, listen: false).goToRecipes();
        },
          color: Colors.green,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text("Browse Recipes"),
        )

      ],
    );
  }
}
