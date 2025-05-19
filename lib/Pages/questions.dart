class Question {
  final String question;
  final List<String> options;
  final String answer;

  Question(
      {required this.question, required this.options, required this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    final options =
    (json['options'] as List).map((e) => e.toString().trim()).toList();

    String answer = json['answer']?.toString().trim().toLowerCase() ?? '';
    answer = answer.replaceAll(RegExp(r'[^\w\s]'), '');

    return Question(
      question: json['question']?.toString().trim() ?? 'No question provided',
      options: options,
      answer: answer,
    );
  }
}
/*
This ensures all questions, options and answers are cleaned
(trimmed, lowercase, punctuation removed) for reliable comparison later.
 */