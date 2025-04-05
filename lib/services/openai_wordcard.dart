import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Replace with your actual model imports.
import 'package:word_cards_mainor_2025_spring/models/word_card.dart';

import '../models/word_card_list.dart';

/// An example function that calls the OpenAI API to generate a WordCardList
/// based on a given [topic], [fromLanguage], and [toLanguage].
///
/// Important:
///   1. Replace <YOUR_OPENAI_API_KEY> with your actual OpenAI API Key.
///   2. This example uses the Chat Completions endpoint.
///   3. Adjust the prompt or model as needed in your real code.
///   4. This example does minimal error handling; enhance it for production.
Future<WordCardList> generateWordCardList(
    String topic,
    SupportedLanguage fromLanguage,
    SupportedLanguage toLanguage,
    ) async {
  // Your OpenAI credentials
  var openaiApiKey = dotenv.env['OPENAI_KEY'];
  final url = Uri.parse("https://api.openai.com/v1/chat/completions");

  // Construct a system + user prompt requesting a JSON structure
  // matching the WordCardList shape.
  final prompt = """
You are a helpful assistant that generates a JSON object of word pairs in the format:

{
  "fromLanguage": "en", 
  "toLanguage": "ru", 
  "topic": "Basic Cards", 
  "wordCards": [
    {
      "word": "Hello",
      "translatedWord": "Привет"
    },
    ...
  ]
}

Please generate a JSON object that includes 25 word pairs for the topic "$topic".
The source language is "$fromLanguage" and the target language is "$toLanguage".
Return only valid JSON, with no additional explanation.
""";

  // Prepare the request body for the Chat Completion endpoint.
  final requestBody = jsonEncode({
    "model": "gpt-4o-mini",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant that outputs JSON only."
      },
      {
        "role": "user",
        "content": prompt,
      }
    ],
    "temperature": 0.7
  });

  // Make the request
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $openaiApiKey",
    },
    body: requestBody,
  );

  // Basic error handling
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch data from OpenAI. Status code: ${response.statusCode}");
  }

  // Parse the overall response
  final rawResponse = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(rawResponse) as Map<String, dynamic>;

  // The 'content' of the top choice includes our JSON string
  final rawContent = decoded["choices"]?[0]?["message"]?["content"];
  if (rawContent == null) {
    throw Exception("No content returned from OpenAI.");
  }

  // Convert the returned JSON string into a Dart object
  final parsedJson = jsonDecode(rawContent);

  // Build a WordCardList from the JSON
  final wordCardList = WordCardList(
    _mapLanguageStringToEnum(parsedJson["fromLanguage"]),
    _mapLanguageStringToEnum(parsedJson["toLanguage"]),
    parsedJson["topic"] ?? topic,
    (parsedJson["wordCards"] as List<dynamic>)
        .map((cardData) => WordCard(
      cardData["word"] as String,
      cardData["translatedWord"] as String,
    ))
        .toList(),
  );

  return wordCardList;
}

/// A helper method for mapping string to SupportedLanguage enum.
SupportedLanguage _mapLanguageStringToEnum(String? languageString) {
  switch (languageString) {
    case "en":
      return SupportedLanguage.en;
    case "et":
      return SupportedLanguage.et;
    case "ru":
      return SupportedLanguage.ru;
    case "jp":
      return SupportedLanguage.jp;
    default:
      throw ArgumentError("Unsupported language string: $languageString");
  }
}
