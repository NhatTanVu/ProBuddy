import 'package:flutter/material.dart';
import 'package:pro_buddy/screens/home_screen.dart';
import 'package:pro_buddy/screens/signup_screen1.dart';
import 'package:pro_buddy/screens/signup_screen2.dart';
import 'package:pro_buddy/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProBuddy',
      initialRoute: WelcomeScreen.id,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0x001c1b1f),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Color(0xFFE6E6E6),
              fontSize: 16
            ),
        ),
      ),
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        SignUpScreen1.id: (context) => const SignUpScreen1(),
        SignUpScreen2.id: (context) => const SignUpScreen2(),
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}