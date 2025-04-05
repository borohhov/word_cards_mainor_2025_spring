import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:word_cards_mainor_2025_spring/models/word_card.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';
import 'persistence.dart'; // Where you defined Persistence

class SqlController implements Persistence {
  Database? _database;

  /// Initialize the database, creating tables if they don’t exist.
  @override
  Future<void> init() async {
    // Get a platform-specific directory where persistent app data can be stored
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'word_cards.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the main table for WordCardList
        await db.execute('''
          CREATE TABLE word_card_lists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            from_language TEXT,
            to_language TEXT,
            topic TEXT
          )
        ''');

        // Create the table for individual WordCards
        await db.execute('''
          CREATE TABLE word_cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            list_id INTEGER,
            word TEXT,
            translated_word TEXT
          )
        ''');
      },
    );
  }

  /// Fetch all word card lists and their associated word cards.
  @override
  Future<List<WordCardList>> getAllWordCardLists() async {
    if (_database == null) {
      await init();
    }

    // Query all rows in the word_card_lists table.
    final listMaps = await _database!.query('word_card_lists');
    final List<WordCardList> lists = [];

    for (final listRow in listMaps) {
      final listId = listRow['id'] as int;
      final fromLangString = listRow['from_language'] as String;
      final toLangString = listRow['to_language'] as String;
      final topic = listRow['topic'] as String;

      // Build the WordCardList from database fields
      final fromLang = _parseLanguage(fromLangString);
      final toLang = _parseLanguage(toLangString);

      // Fetch related word cards
      final cardMaps = await _database!.query(
        'word_cards',
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      final wordCards = cardMaps
          .map((cardRow) => WordCard(
        cardRow['word'] as String,
        cardRow['translated_word'] as String,
      ))
          .toList();

      lists.add(WordCardList(fromLang, toLang, topic, wordCards));
    }

    return lists;
  }

  /// Insert or update a WordCardList in the DB, along with all its WordCards.
  @override
  Future<void> saveWordCardList(WordCardList list) async {
    if (_database == null) {
      await init();
    }

    // First, insert or replace the WordCardList row
    final listId = await _database!.insert(
      'word_card_lists',
      {
        'from_language': _languageToString(list.fromLanguage),
        'to_language': _languageToString(list.toLanguage),
        'topic': list.topic,
      },
      // If a row with the same fields exists, this replaces it. In a real app,
      // you might want to find a row by topic or some unique key instead.
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Now we handle the word_cards for this list.
    // Let's delete existing word_cards tied to the same listId to avoid duplicates.
    await _database!.delete(
      'word_cards',
      where: 'list_id = ?',
      whereArgs: [listId],
    );

    // Insert all new WordCards
    for (final card in list.wordCards) {
      await _database!.insert(
        'word_cards',
        {
          'list_id': listId,
          'word': card.word,
          'translated_word': card.translatedWord,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // ---------- Utilities for converting enum <-> string ----------

  SupportedLanguage _parseLanguage(String langStr) {
    switch (langStr) {
      case 'en':
        return SupportedLanguage.en;
      case 'et':
        return SupportedLanguage.et;
      case 'ru':
        return SupportedLanguage.ru;
      case 'jp':
        return SupportedLanguage.jp;
      default:
        throw Exception('Unsupported language string: $langStr');
    }
  }

  String _languageToString(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.en:
        return 'en';
      case SupportedLanguage.et:
        return 'et';
      case SupportedLanguage.ru:
        return 'ru';
      case SupportedLanguage.jp:
        return 'jp';
    }
  }
}
