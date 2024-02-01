import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_1/mongodb/mongodb.dart';
import 'package:test_1/provider/auth_provider.dart';
import 'package:test_1/screens/UI/my_diary/my_diary_screen.dart';
import 'package:test_1/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
        // home: MyDiaryScreen(mobile: '+919689061841'),
        // home: MyDiaryScreen(),
        title: "Authentication",
      ),
    );
  }
}
