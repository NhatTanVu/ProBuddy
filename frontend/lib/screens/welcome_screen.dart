import 'package:flutter/material.dart';
import '../components/rounded_textbox.dart';
import '../components/rounded_button.dart';
import '../components/auth_button.dart';
import '../models/auth_user.dart';
import 'home_screen.dart';
import 'signup_screen0.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthenticationSuccessfulResult(AuthUser authUser) {
    Navigator.pushNamed(context, HomeScreen.id);
  }

  void _handleAuthenticationFailedResult(String message) {
    setState(() {
      _message = message;
    });
  }

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
                          controller: _usernameController,
                          hintText: 'Username',
                          height: 50,
                          backgroundColour: const Color(0xFF49454F),
                          textColour: const Color(0xFFCAC4D0),
                          icon: Icons.person),
                      const SizedBox(
                        height: 21,
                      ),
                      RoundedTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        height: 50,
                        backgroundColour: const Color(0xFF49454F),
                        textColour: const Color(0xFFCAC4D0),
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      AuthButton(
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        onAuthenticationSuccessfulResult:
                            _handleAuthenticationSuccessfulResult,
                        onAuthenticationFailedResult:
                            _handleAuthenticationFailedResult,
                      ),
                      Visibility(
                        visible: _message != "",
                        child: const SizedBox(height: 14.0),
                      ),
                      Center(
                        child: Visibility(
                          visible: _message != "",
                          child: Text(
                            _message,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                          Navigator.pushNamed(context, SignUpScreen0.id);
                        },
                      ),
                    ]),
              ),
            ]),
      ),
    );
  }
}
