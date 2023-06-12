import 'package:flutter/material.dart';
import 'package:pro_buddy/components/rounded_textbox.dart';
import 'package:pro_buddy/screens/signup_screen1.dart';

import '../components/rounded_button.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 83.51,
                    child: Image.asset('images/logo.png'),
                  )),
              const SizedBox(
                height: 30,
              ),
            ]),
      ),
    );
  }
}
