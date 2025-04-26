import 'package:word_cards_mainor_2025_spring/models/word_card.dart';

class WordCardList {
  SupportedLanguage fromLanguage;
  SupportedLanguage toLanguage;
  String topic;
  String? uid;
  List<WordCard> wordCards;

  WordCardList(this.fromLanguage, this.toLanguage, this.topic, this.wordCards);
  /// Convert the entire list to a Map for JSON encoding.
  Map<String, dynamic> toJson() => {
    'fromLanguage': fromLanguage.toJson(),
    'toLanguage': toLanguage.toJson(),
    'topic': topic,
    'userId': uid,
    'wordCards': wordCards.map((wc) => wc.toJson()).toList(),
  };

  /// Create a WordCardList from decoded JSON.
  factory WordCardList.fromJson(Map<String, dynamic> json) {
    return WordCardList(
      SupportedLanguageSerialization.fromJson(
          json['fromLanguage'] as String),
      SupportedLanguageSerialization.fromJson(
          json['toLanguage'] as String),
      json['topic'] as String,
      (json['wordCards'] as List<dynamic>)
          .map((item) =>
          WordCard.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

enum SupportedLanguage { en, et, ru, jp }

WordCardList demoCardList = WordCardList(SupportedLanguage.en, SupportedLanguage.et, 'Basic Cards', [
  WordCard("Cat", "Kass"),
  WordCard("Dog", "Koer"),
  WordCard("Student", "Tudeng"),
  WordCard("Crocodile", "Крокодил"),
  WordCard("Student", "Tudeng"),
]);

/// Helper to go between enum and its JSON string.
extension SupportedLanguageSerialization on SupportedLanguage {
  String toJson() => toString().split('.').last;
  static SupportedLanguage fromJson(String value) {
    return SupportedLanguage.values
        .firstWhere((e) => e.toString().split('.').last == value);
  }
}
