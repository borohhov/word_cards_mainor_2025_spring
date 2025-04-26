class WordCard {
  String word;
  String translatedWord;

  WordCard(this.word, this.translatedWord);

  /// Convert a WordCard into a Map for JSON encoding.
  Map<String, dynamic> toJson() => {
    'word': word,
    'translatedWord': translatedWord,
  };

  /// Create a WordCard from decoded JSON.
  factory WordCard.fromJson(Map<String, dynamic> json) {
    return WordCard(
      json['word'] as String,
      json['translatedWord'] as String,
    );
  }
}