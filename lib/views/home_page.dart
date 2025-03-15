import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';
import 'package:word_cards_mainor_2025_spring/providers/word_card_list_provider.dart';
import 'package:word_cards_mainor_2025_spring/views/cards_page.dart';
import 'package:word_cards_mainor_2025_spring/views/word_card_list_form.dart';
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
            children: Provider.of<WordCardListProvider>(context)
                .items
                .map(
                  (cardList) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CardsPage(cards: cardList)),
                        );
                      },
                      child: WordCardListWidget(wordCardList: cardList)),
                )
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WordCardListForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
