import 'package:flutter/material.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

class CardsPage extends StatefulWidget {
  CardsPage({super.key, required this.cards});

  final WordCardList cards;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  int cardIndex = 0;
  bool translationShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(widget.cards.wordCards[cardIndex].word),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  translationShown = !translationShown;
                });
              },
              child: Icon(Icons.refresh))
        ],
      ),
    );
  }
}
