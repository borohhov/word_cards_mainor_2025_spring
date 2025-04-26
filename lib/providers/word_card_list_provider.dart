import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:word_cards_mainor_2025_spring/controllers/persistence/firebase_controller.dart';
import 'package:word_cards_mainor_2025_spring/controllers/persistence/persistence.dart';
import 'package:word_cards_mainor_2025_spring/controllers/persistence/sql_controller.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

class WordCardListProvider extends ChangeNotifier {
  PersistenceInterface dataController = FirebaseController();

  Future<void> addWordCardList(WordCardList cardList) async {
    dataController.saveWordCardList(cardList);
    notifyListeners();
  }

  Future<List<WordCardList>> getWordCardLists() async {
    return dataController.getAllWordCardLists();
  }
}