import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';
import 'package:word_cards_mainor_2025_spring/views/cards_page.dart';
import 'package:word_cards_mainor_2025_spring/views/word_card_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CardsPage(cards: demoCardList)),
                  );
                },
                child: WordCardListWidget(wordCardList: demoCardList)),
            WordCardListWidget(wordCardList: demoCardList),
            WordCardListWidget(wordCardList: demoCardList),
            WordCardListWidget(wordCardList: demoCardList),
          ],),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: null, child: Icon(Icons.add),),
    );
  }
}
