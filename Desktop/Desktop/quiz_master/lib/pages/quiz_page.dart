import 'package:flutter/material.dart';
import 'result_page.dart';
import 'upload_picture_page.dart';

class QuizPage extends StatefulWidget {
  final String userName;
  const QuizPage({super.key, required this.userName});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Rome'],
      'answer': 0,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'answer': 1,
    },
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex]['answer']) {
      score++;
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      if (score == questions.length) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            //????? fix later
            builder: (context) => UploadPicturePage(userName: widget.userName),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultPage(score: score, total: questions.length),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[currentQuestionIndex];
    List<dynamic> options = currentQuestion['options'];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ...options.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => answerQuestion(idx),
                  child: Text(option),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
