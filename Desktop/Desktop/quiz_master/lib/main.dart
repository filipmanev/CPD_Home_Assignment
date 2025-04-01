import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/notification_service.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDXvkZWE4rJY8zuVwwIdUeLB4NgsOEUnWM",
        appId: "1:1008101041805:android:cfde987bb2ef54db9464c4",
        messagingSenderId: "1008101041805",
        projectId: "quiz-master-f95be",
        storageBucket: "gs://quiz-master-f95be.firebasestorage.app",
      ),
    );
    print("Firebase initialized successfully.");
  } else {
    print("Firebase already initialized.");
  }

  final NotificationService notificationService = NotificationService();
  await notificationService.initialize();

  runApp(QuizApp(notificationService: notificationService));
}

class QuizApp extends StatelessWidget {
  final NotificationService notificationService;
  const QuizApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(notificationService: notificationService),
    );
  }
}
