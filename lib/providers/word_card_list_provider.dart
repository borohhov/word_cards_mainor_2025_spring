import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

class WordCardListProvider extends ChangeNotifier {
  final List<WordCardList> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<WordCardList> get items => UnmodifiableListView(_items);


  /// Adds [cardList] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(WordCardList cardList) {
    _items.add(cardList);
    notifyListeners();
  }

  /*/// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }*/
}