import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:word_cards_mainor_2025_spring/controllers/auth/firebase_auth.dart';
import 'package:word_cards_mainor_2025_spring/providers/word_card_list_provider.dart';
import 'package:word_cards_mainor_2025_spring/views/home_page.dart';

import 'controllers/auth/auth.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Auth auth = FirebaseAuthImpl();

  // listen to auth state
  auth.authStateChanges.listen((user) {
    if (user != null) {
      print('Signed in anonymously as ${user.uid}');
    } else {
      print('Signed out');
    }
  });

  // sign in
  await auth.signInAnonymously();
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