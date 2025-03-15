import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

class CardsPage extends StatefulWidget {
  CardsPage({Key? key, required this.cards}) : super(key: key);

  final WordCardList cards;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  int cardIndex = 0;
  bool translationShown = false;

  void getNextCard() {
    setState(() {
      int nextIndex = Random().nextInt(widget.cards.wordCards.length - 1);
      while (cardIndex == nextIndex) {
        nextIndex = Random().nextInt(widget.cards.wordCards.length - 1);
      }
      cardIndex = nextIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                color: Colors.blue.shade100,
                height: 300,
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    translationShown
                        ? widget.cards.wordCards[cardIndex].translatedWord
                        : widget.cards.wordCards[cardIndex].word,
                    style: TextStyle(fontSize: 60), // TODO: adjust based on word length
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons side-by-side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      translationShown = !translationShown;
                    });
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: getNextCard,
                  child: const Icon(Icons.play_arrow_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
