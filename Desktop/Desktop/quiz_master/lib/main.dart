import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDXvkZWE4rJY8zuVwwIdUeLB4NgsOEUnWM",
      appId: "1:1008101041805:android:cfde987bb2ef54db9464c4",
      messagingSenderId: "1008101041805",
      projectId: "quiz-master-f95be",
      storageBucket: "gs://quiz-master-f95be.firebasestorage.app",
    ),
  );
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
