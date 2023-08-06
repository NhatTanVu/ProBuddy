import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../components/rounded_textbox.dart';
import '../models/auth_user.dart';
import 'signup_screen0.dart';
import 'signup_screen2.dart';

class SignUpScreen1 extends StatefulWidget {
  static const String id = 'signup_screen_1';

  const SignUpScreen1({Key? key}) : super(key: key);

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthUser? signUpUser =
        ModalRoute.of(context)?.settings.arguments as AuthUser?;
    if (signUpUser == null) {
      signUpUser = AuthUser.fromEmpty();
    } else {
      _emailController.text = signUpUser.email as String;
      _firstNameController.text = signUpUser.firstName as String;
      _lastNameController.text = signUpUser.lastName as String;
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
                            'Sign Up (continued)',
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
                      height: 10,
                    ),
                    RoundedTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 40,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      controller: _firstNameController,
                      hintText: 'First Name',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 40,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      controller: _lastNameController,
                      hintText: 'Last Name',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 40,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButton(
                          title: 'Previous',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 40,
                          fontSize: 16,
                          onPressed: () {
                            signUpUser?.email = _emailController.text;
                            signUpUser?.firstName = _firstNameController.text;
                            signUpUser?.lastName = _lastNameController.text;
                            Navigator.pushNamed(context, SignUpScreen0.id,
                                arguments: signUpUser);
                          },
                        ),
                        RoundedButton(
                          title: 'Next',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 40,
                          fontSize: 16,
                          onPressed: () {
                            signUpUser?.email = _emailController.text;
                            signUpUser?.firstName = _firstNameController.text;
                            signUpUser?.lastName = _lastNameController.text;
                            Navigator.pushNamed(context, SignUpScreen2.id,
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
