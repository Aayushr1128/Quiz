import 'package:flutter/material.dart';
import 'groq_api.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _selectedCategory = 'General Knowledge';
  String _selectedDifficulty = 'Medium';
  bool _isLoading = false;

  final Map<String, List<String>> _categoryGroups = {
    'General': [
      'General Knowledge',
      'Current Affairs',
      'Books',
      'Movies'
    ],
    'Science': [
      'Science',
      'Technology',
      'Mathematics',
      'Engineering'
    ],
    'Arts': [
      'Music',
      'Art',
      'Literature',
      'Photography'
    ],
    'Sports': [
      'Sports',
      'Cricket',
      'Football',
      'Olympics'
    ],
    'History': [
      'World History',
      'Ancient History',
      'Modern History'
    ],
  };

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00695C),
          title: const Text('GROQ Quiz',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/green.jpg"),fit:BoxFit.fill)
          ),
          child: SingleChildScrollView(
            padding:  EdgeInsets.all(MediaQuery.sizeOf(context).width*0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader('Select Difficulty'),
                Wrap(
                  spacing: MediaQuery.sizeOf(context).width*0.02,
                  runSpacing: MediaQuery.sizeOf(context).width*0.02,
                  children: _difficulties.map((difficulty) {
                    return ChoiceChip(
                      label: Text(difficulty),
                      selected: _selectedDifficulty == difficulty,
                      selectedColor: Theme.of(context).primaryColor,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _selectedDifficulty == difficulty
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (selected) {
                        setState(() => _selectedDifficulty = difficulty);
                      },
                    );
                  }).toList(),
                ),
      
                _buildSectionHeader('Select Category'),
                ..._categoryGroups.entries.map((group) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).width*0.025),
                        child: Text(
                          group.key,
                          style:  TextStyle(
                            fontSize: MediaQuery.sizeOf(context).width*0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: MediaQuery.sizeOf(context).width*0.03,
                        mainAxisSpacing: MediaQuery.sizeOf(context).width*0.03,
                        children: group.value.map((category) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedCategory == category
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[200],
                              foregroundColor: _selectedCategory == category
                                  ? Colors.white
                                  : Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).width*0.02),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              setState(() => _selectedCategory = category);
                            },
                            child: Text(
                              category,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.035),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }),
      
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).width*0.04),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _startQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).width*0.04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).width*0.03),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        :  Text(
                      'Start Quiz',
                      style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.04,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).width*0.015),
      child: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.sizeOf(context).width*0.04,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  void _startQuiz() async {
    setState(() => _isLoading = true);
    try {
      final questions = await fetchQuizQuestions(_selectedCategory, _selectedDifficulty);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            questions: questions,
            difficulty: _selectedDifficulty,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}