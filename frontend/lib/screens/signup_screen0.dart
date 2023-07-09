import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../components/rounded_textbox.dart';
import '../models/auth_user.dart';
import 'welcome_screen.dart';
import 'signup_screen1.dart';

class SignUpScreen0 extends StatefulWidget {
  static const String id = 'signup_screen_0';

  const SignUpScreen0({Key? key}) : super(key: key);

  @override
  State<SignUpScreen0> createState() => _SignUpScreen0State();
}

class _SignUpScreen0State extends State<SignUpScreen0> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthUser? signUpUser =
        ModalRoute.of(context)?.settings.arguments as AuthUser?;
    if (signUpUser == null) {
      signUpUser = AuthUser.fromEmpty();
    } else {
      _usernameController.text = signUpUser.userName as String;
      _passwordController.text = signUpUser.password as String;
      _retypePasswordController.text = signUpUser.password as String;
    }

    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Hero(
            tag: 'logo',
            child: SizedBox(
              height: 63.51,
              child: Image.asset('images/logo.png'),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1C1F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 25),
                          ),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Color(0xFFE6E6E6),
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 40,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 40,
                      fontSize: 16,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      controller: _retypePasswordController,
                      hintText: 'Retype Password',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 40,
                      fontSize: 16,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButton(
                          title: 'Cancel',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 40,
                          fontSize: 16,
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          },
                        ),
                        RoundedButton(
                          title: 'Next',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 40,
                          fontSize: 16,
                          onPressed: () {
                            signUpUser?.userName = _usernameController.text;
                            signUpUser?.password = _passwordController.text;
                            Navigator.pushNamed(context, SignUpScreen1.id,
                                arguments: signUpUser);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
