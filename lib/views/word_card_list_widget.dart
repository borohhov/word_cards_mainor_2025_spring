import 'package:flutter/material.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

class WordCardListWidget extends StatelessWidget {
  WordCardListWidget({super.key, required this.wordCardList});

  WordCardList wordCardList;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(
                "${wordCardList.fromLanguage.toString().split('.')[1].toUpperCase()} -> ${wordCardList.toLanguage.toString().split('.')[1].toUpperCase()}"),
            Text(wordCardList.topic, style: TextStyle(fontSize: 36),),
            Text('Cards: ${wordCardList.wordCards.length.toString()}', style: TextStyle(fontSize: 16),)
          ],
        ),
      ),
    );
  }
}
