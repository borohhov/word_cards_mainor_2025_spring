import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_cards_mainor_2025_spring/providers/word_card_list_provider.dart';
import 'package:word_cards_mainor_2025_spring/views/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WordCardListProvider(),
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Cards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}