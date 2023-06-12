import 'package:flutter/material.dart';
import 'package:pro_buddy/components/rounded_textbox.dart';
import 'package:pro_buddy/screens/signup_screen1.dart';

import '../components/rounded_button.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

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
              Padding(
                padding: const EdgeInsets.fromLTRB(61, 0, 61, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RoundedTextField(
                          hintText: 'Email',
                          backgroundColour: const Color(0xFF49454F),
                          textColour: const Color(0xFFCAC4D0),
                          icon: Icons.email_rounded),
                      const SizedBox(
                        height: 21,
                      ),
                      RoundedTextField(
                        hintText: 'Password',
                        backgroundColour: const Color(0xFF49454F),
                        textColour: const Color(0xFFCAC4D0),
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      RoundedButton(
                        title: 'Sign In',
                        backgroundColour: const Color(0xFFd0bcff),
                        textColour: const Color(0xFF381E72),
                        onPressed: () {
                          Navigator.pushNamed(context, HomeScreen.id);
                        },
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Divider(
                              color: Color(0xFFE6E6E6),
                              thickness: 1,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFF1c1b1f),
                                  child: Text(
                                    'or',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Divider(
                              color: Color(0xFFE6E6E6),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      RoundedButton(
                        title: 'Sign Up',
                        backgroundColour: const Color(0xFFd0bcff),
                        textColour: const Color(0xFF381E72),
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpScreen1.id);
                        },
                      ),
                    ]),
              ),
            ]),
      ),
    );
  }
}
