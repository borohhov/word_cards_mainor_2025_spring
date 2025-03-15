import 'package:word_cards_mainor_2025_spring/models/word_card.dart';

class WordCardList {
  SupportedLanguage fromLanguage;
  SupportedLanguage toLanguage;
  List<WordCard> wordCards;

  WordCardList(this.fromLanguage, this.toLanguage, this.wordCards);
}


enum SupportedLanguage {
  en, et, ru, jp
}

WordCardList demoCardList = WordCardList(SupportedLanguage.en, SupportedLanguage.et, [
  WordCard("Cat", "Kass"),
  WordCard("Dog", "Koer"),
  WordCard("Student", "Tudeng"),
  WordCard("Crocodile", "Крокодил"),
  WordCard("Student", "Tudeng"),
]);