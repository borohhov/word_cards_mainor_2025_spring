import 'package:flutter/material.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

class WordCardListWidget extends StatelessWidget {
  WordCardListWidget({super.key, required this.wordCardList});
  WordCardList wordCardList;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("${wordCardList.fromLanguage} -> ${wordCardList.toLanguage}"),
      GridView.builder(
        shrinkWrap: true, // Ограничиваем высоту до необходимой для содержимого
        physics: NeverScrollableScrollPhysics(), // Отключаем прокрутку внутри GridView
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Количество колонок
          crossAxisSpacing: 10, // Отступы между колонками
          mainAxisSpacing: 10,  // Отступы между строками
        ),
        itemCount: wordCardList.wordCards.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              wordCardList.wordCards[index].word, // Текст из списка
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    ],);
  }
}
