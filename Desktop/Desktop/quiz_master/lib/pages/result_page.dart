import 'package:flutter/material.dart';
import 'home_page.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int total;

  const ResultPage({Key? key, required this.score, required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $score / $total',
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Return Home'),
            )
          ],
        ),
      ),
    );
  }
}
