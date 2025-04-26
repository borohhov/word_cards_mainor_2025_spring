import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

abstract class PersistenceInterface {
  Future<void> init();
  Future<void> saveWordCardList(WordCardList list);
  Future<List<WordCardList>> getAllWordCardLists();
}