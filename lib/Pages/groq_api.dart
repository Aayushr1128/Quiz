import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'questions.dart';

List<Question> extractJsonFromContent(String content) {
  try {
    // First try to parse the content directly
    final parsed = jsonDecode(content.trim());
    if (parsed is List) {
      return parsed.map((e) => Question.fromJson(e)).toList();
    }
    throw Exception('Expected JSON array but got something else');
  } catch (e) {
    // If direct parse fails, try extracting JSON from string
    final startIndex = content.indexOf('[');
    final endIndex = content.lastIndexOf(']');

    if (startIndex != -1 && endIndex != -1) {
      final jsonString = content.substring(startIndex, endIndex + 1);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => Question.fromJson(e)).toList();
    }
    throw Exception('JSON data not found in response: $e');
  }
}

Future<List<Question>> fetchQuizQuestions(String category, String selectedDifficulty) async {
  const apiKey = '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';
  final response = await http.post(
    Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "model": "llama3-8b-8192",
      "messages": [
        {
          "role": "user",
          "content": "Generate 5 multiple-choice questions on $category. "
              "Format each question as: "
              "{'question': 'text', 'options': ['a. option1', 'b. option2', 'c. option3', 'd. option4'], "
              "'answer': 'a'}. "
              "Return only a JSON array with no additional text or explanations."
        }
      ],
      "temperature": 0.7,
    }),
  );

  if (response.statusCode == 200) {
    try {
      final content =
      jsonDecode(response.body)['choices'][0]['message']['content'];
      debugPrint('Received content: $content');
      return extractJsonFromContent(content);
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  } else {
    throw Exception('Failed to load questions: ${response.statusCode}');
  }
}

/*
The prompt is very specific about the required JSON format

Temperature of 0.7 gives some variety while maintaining consistency

Explicitly requests only the letter (a/b/c/d) as the answer
 */