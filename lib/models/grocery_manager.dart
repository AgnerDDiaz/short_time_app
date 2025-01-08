import 'package:flutter/cupertino.dart';

import 'grocery_item.dart';


class GroceryManager extends ChangeNotifier{
  final _groceryItems = <GroceryItem>[];

  List<GroceryItem> get groceryItem => List.unmodifiable(_groceryItems);

  void addItems(GroceryItem item){
    _groceryItems.add(item);
    notifyListeners();
  }

  void deleteItem(int index){
    _groceryItems.removeAt(index);
    notifyListeners();
  }

  void updateItem(GroceryItem item, int index){
    _groceryItems[index] = item;
    notifyListeners();
  }

  void completeItem(int index, bool change){
    final item = _groceryItems[index];
    _groceryItems[index] = item;
    notifyListeners();
  }
}