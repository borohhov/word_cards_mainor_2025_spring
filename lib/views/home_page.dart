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
          child: FutureBuilder<List<WordCardList>>(
            future: Provider.of<WordCardListProvider>(context).getWordCardLists(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                  snapshot.data.map<Widget>(
                        (cardList) =>
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => CardsPage(cards: cardList)),
                              );
                            },
                            child: WordCardListWidget(wordCardList: cardList)),
                  )
                      .toList(),
                );
              }
              return Center(child: Text('An error occurred'),);
            },
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
