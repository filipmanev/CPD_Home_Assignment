import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'notification_service.dart';

class HomePage extends StatefulWidget {
  final NotificationService? notificationService;
  const HomePage({super.key, this.notificationService});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  void _startQuiz() {
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    widget.notificationService?.showNotification(name);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizPage(userName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startQuiz,
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
