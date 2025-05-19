import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz/Pages/questions.dart';
import 'package:quiz/Pages/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String difficulty;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.difficulty,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int current = 0;
  int score = 0;
  String selected = '';
  bool submitted = false;
  Timer? timer;
  int remainingSeconds = 30;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.difficulty == 'Easy'
        ? 40
        : widget.difficulty == 'Medium'
        ? 30
        : 20;
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        _submitAnswer();
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  void _submitAnswer() {
    if (!submitted && selected.isNotEmpty) {
      setState(() {
        submitted = true;
        final selectedLetter =
        selected.toLowerCase().trim().split('.')[0].trim();
        if (selectedLetter == widget.questions[current].answer) {
          score++;
        }
      });
    }
  }

  /*
we only compare the leading letters (a/b/c/d) which is more reliable
Splits on "." to get just the letter portion before comparing
   */

  void _nextQuestion() {
    if (current < widget.questions.length - 1) {
      setState(() {
        current++;
        selected = '';
        submitted = false;
        remainingSeconds = widget.difficulty == 'Easy'
            ? 40
            : widget.difficulty == 'Medium'
            ? 30
            : 20;
        startTimer();
      });
    } else {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: score,
            total: widget.questions.length,
            difficulty: widget.difficulty,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[current];
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF00695C),
        title: Text(
            '${widget.difficulty} Quiz - Q${current + 1}/${widget.questions.length}',style: const TextStyle(color: Colors.white),),
        actions: [
          Padding(
            padding:  EdgeInsets.all(MediaQuery.sizeOf(context).width*0.02),
            child: CircleAvatar(
              backgroundColor: colorScheme.primary.withOpacity(0.7),
              child:
              Text('$score', style: const TextStyle(color: Colors.deepOrange)),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/green.jpg"),fit: BoxFit.fill)
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width*0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Difficulty indicator
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).width*0.02),
                child: Chip(
                  label: Text(widget.difficulty),
                  backgroundColor: widget.difficulty == 'Easy'
                      ? Colors.green[100]
                      : widget.difficulty == 'Medium'
                      ? Colors.orange[100]
                      : Colors.red[100],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom:MediaQuery.sizeOf(context).width*0.02),
                child: LinearProgressIndicator(
                  value: (current + 1) / widget.questions.length,
                  minHeight: MediaQuery.sizeOf(context).width*0.02,
                  backgroundColor: Colors.grey[200],
                  color: colorScheme.primary,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom:MediaQuery.sizeOf(context).width*0.04),
                child: Text(q.question,
                    style:
                     TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.05, fontWeight: FontWeight.bold)),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).width*0.02),
                child: Text(
                  'Time left: $remainingSeconds seconds',
                  style: TextStyle(
                    color: remainingSeconds <= 10 ? Colors.red : const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  children: q.options.map((opt) {
                    final isCorrectAnswer =
                        opt.toLowerCase().trim().split('.')[0].trim() == q.answer;
                    final isSelected = selected == opt;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).width*0.01),
                      color: submitted
                          ? isCorrectAnswer
                          ? Colors.green[100]
                          : isSelected && !isCorrectAnswer
                          ? Colors.red[100]
                          : null
                          : isSelected
                          ? colorScheme.primary.withOpacity(0.1)
                          : null,
                      child: ListTile(
                        title: Text(opt),
                        onTap: submitted
                            ? null
                            : () => setState(() => selected = opt),
                      ),
                    );
                  }).toList(),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed:
                    selected.isNotEmpty && !submitted ? _submitAnswer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: submitted ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      submitted ? colorScheme.primary : Colors.grey,
                      minimumSize: const Size(150, 50),
                    ),
                    child: Text(
                        current < widget.questions.length - 1 ? 'Next' : 'Finish',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}