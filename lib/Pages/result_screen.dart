import 'package:flutter/material.dart';
import 'home_page.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String difficulty;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((score / total) * 100).toStringAsFixed(1);
    final color = score == total
        ? Colors.green
        : score >= total / 2
            ? Colors.orange
            : Colors.red;

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF00695C),
          title: Text(
            '$difficulty Quiz Results',
            style: const TextStyle(color: Colors.white),
          )),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/green.jpg"), fit: BoxFit.fill)),
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(MediaQuery.sizeOf(context).width*0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Difficulty indicator
                Chip(
                  label: Text(difficulty),
                  backgroundColor: difficulty == 'Easy'
                      ? Colors.green[100]
                      : difficulty == 'Medium'
                          ? Colors.orange[100]
                          : Colors.red[100],
                ),

                Text(
                  'Your Score',
                  style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[100]),
                ),
                CircleAvatar(
                  radius: MediaQuery.sizeOf(context).width*0.15,
                  backgroundColor: color.withOpacity(0.9),
                  child: Text(
                    '$score/$total',
                    style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width*0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.sizeOf(context).width*0.04),
                  child: Text(
                    '$percent%',
                    style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width*0.07,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).width * 0.1),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: Size(MediaQuery.sizeOf(context).height * 0.3,
                          MediaQuery.sizeOf(context).width * 0.13),
                    ),
                    child:Text(
                      'Try Again',
                      style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.04, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
