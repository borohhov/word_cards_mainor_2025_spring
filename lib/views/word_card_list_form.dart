import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';
import 'package:word_cards_mainor_2025_spring/providers/word_card_list_provider.dart';
import 'package:word_cards_mainor_2025_spring/services/openai_wordcard.dart';

class WordCardListForm extends StatefulWidget {
  const WordCardListForm({Key? key}) : super(key: key);

  @override
  _WordCardListFormState createState() => _WordCardListFormState();
}

class _WordCardListFormState extends State<WordCardListForm> {
  final _formKey = GlobalKey<FormState>();

  // Fields for the WordCardList
  SupportedLanguage? _fromLanguage;
  SupportedLanguage? _toLanguage;
  final TextEditingController _topicController = TextEditingController();

  // List of word cards (in memory)
  List<WordCard> _wordCards = [];

  // Controllers for each WordCard row
  final List<TextEditingController> _wordControllers = [];
  final List<TextEditingController> _translatedWordControllers = [];

  // Future for generated cards (if any)
  Future<WordCardList>? _generatedListFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New WordCard List'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // FROM language dropdown
              DropdownButtonFormField<SupportedLanguage>(
                decoration: const InputDecoration(
                  labelText: 'From Language',
                  border: OutlineInputBorder(),
                ),
                value: _fromLanguage,
                onChanged: (value) {
                  setState(() {
                    _fromLanguage = value;
                  });
                },
                items: SupportedLanguage.values.map((language) {
                  return DropdownMenuItem<SupportedLanguage>(
                    value: language,
                    child: Text(language.toString().split('.').last),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the source language';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // TO language dropdown
              DropdownButtonFormField<SupportedLanguage>(
                decoration: const InputDecoration(
                  labelText: 'To Language',
                  border: OutlineInputBorder(),
                ),
                value: _toLanguage,
                onChanged: (value) {
                  setState(() {
                    _toLanguage = value;
                  });
                },
                items: SupportedLanguage.values.map((language) {
                  return DropdownMenuItem<SupportedLanguage>(
                    value: language,
                    child: Text(language.toString().split('.').last),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the target language';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Topic text field
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(
                  labelText: 'Topic',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Word card fields using FutureBuilder to avoid flaky behaviour
              _buildWordCardsSection(),

              // Button to add another word card row manually
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addWordCard,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Word Card'),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Card List'),
              ),
              const SizedBox(height: 16),

              // Generate cards button
              ElevatedButton(
                onPressed: _generateCards,
                child: const Text('Generate Cards'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// This method builds the word cards section.
  /// If a generation future is active, it uses FutureBuilder to wait for the cards;
  /// otherwise it displays the current text fields.
  Widget _buildWordCardsSection() {
    if (_generatedListFuture != null) {
      return FutureBuilder<WordCardList>(
        future: _generatedListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Populate controllers if not already done
            if (_wordControllers.isEmpty && _translatedWordControllers.isEmpty) {
              _wordControllers.clear();
              _translatedWordControllers.clear();
              _wordCards = snapshot.data!.wordCards;
              for (final card in _wordCards) {
                _wordControllers.add(TextEditingController(text: card.word));
                _translatedWordControllers.add(TextEditingController(text: card.translatedWord));
              }
            }
            return Column(children: _buildWordCardFields());
          }
          return Container();
        },
      );
    } else {
      return Column(children: _buildWordCardFields());
    }
  }

  List<Widget> _buildWordCardFields() {
    List<Widget> cardFields = [];
    for (int i = 0; i < _wordControllers.length; i++) {
      cardFields.add(
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Word field
              Expanded(
                child: TextFormField(
                  controller: _wordControllers[i],
                  decoration: const InputDecoration(labelText: 'Word'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a word';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Translated word field
              Expanded(
                child: TextFormField(
                  controller: _translatedWordControllers[i],
                  decoration: const InputDecoration(labelText: 'Translation'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a translation';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeWordCard(i),
              )
            ],
          ),
        ),
      );
    }
    return cardFields;
  }

  void _addWordCard() {
    setState(() {
      _wordControllers.add(TextEditingController());
      _translatedWordControllers.add(TextEditingController());
    });
  }

  void _removeWordCard(int index) {
    setState(() {
      _wordControllers.removeAt(index);
      _translatedWordControllers.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // If any fields are invalid, don't submit
      return;
    }

    // Re-construct the list of WordCards from the text controllers
    _wordCards.clear();
    for (int i = 0; i < _wordControllers.length; i++) {
      _wordCards.add(
        WordCard(
          _wordControllers[i].text.trim(),
          _translatedWordControllers[i].text.trim(),
        ),
      );
    }

    final newList = WordCardList(
      _fromLanguage!,
      _toLanguage!,
      _topicController.text.trim(),
      _wordCards,
    );

    // Add to Provider and pop back to previous screen
    await Provider.of<WordCardListProvider>(context, listen: false)
        .addWordCardList(newList);
    Navigator.of(context).pop();
  }

  /// Calls the OpenAI API to generate cards and sets the future,
  /// triggering the FutureBuilder to rebuild.
  void _generateCards() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      // This future will be used by the FutureBuilder to show progress and result.
      _generatedListFuture = fetchWordCardsHttp(
        _topicController.text.trim(),
        _fromLanguage!,
        _toLanguage!,
      );
      // Clear any existing controllers so that they are replaced by the generated ones.
      _wordControllers.clear();
      _translatedWordControllers.clear();
    });
  }
}
