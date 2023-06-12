import 'package:flutter/material.dart';
import 'package:pro_buddy/components/rounded_button.dart';
import 'package:pro_buddy/components/rounded_multiline_textbox.dart';
import 'package:pro_buddy/components/rounded_textbox.dart';
import 'package:pro_buddy/screens/signup_screen2.dart';
import 'package:pro_buddy/screens/welcome_screen.dart';

class SignUpScreen1 extends StatefulWidget {
  static const String id = 'signup_screen_1';

  const SignUpScreen1({Key? key}) : super(key: key);

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Hero(
            tag: 'logo',
            child: SizedBox(
              height: 83.51,
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
                    borderRadius: BorderRadius.circular(20)),
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
                      height: 10,
                    ),
                    Row(children: const [
                      Text('Upload Photo:'),
                      SizedBox(
                        width: 10,
                      ),
                      Image(
                        image: AssetImage(
                          'images/3d_avatar_8.png',
                        ),
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
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
                      hintText: 'Last Name',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 40,
                      fontSize: 16,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Gender",
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: const Text(
                                "Female",
                                style: TextStyle(
                                  color: Color(0xFFE6E6E6),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            leading: Radio(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFE6E6E6)),
                              value: 'Female',
                              groupValue: 'grpGender',
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: const Text(
                                'Male',
                                style: TextStyle(
                                  color: Color(0xFFE6E6E6),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            leading: Radio(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFE6E6E6)),
                              value: 'Male',
                              groupValue: 'grpGender',
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      RoundedTextField(
                        hintText: 'Age',
                        backgroundColour: const Color(0xFF49454F),
                        textColour: const Color(0xFFCAC4D0),
                        height: 40,
                        width: 100,
                        fontSize: 16,
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedMultiLineTextField(
                      hintText: 'Address',
                      backgroundColour: const Color(0xFF49454F),
                      textColour: const Color(0xFFCAC4D0),
                      height: 100,
                      fontSize: 16,
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
                          height: 30,
                          fontSize: 16,
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          },
                        ),
                        RoundedButton(
                          title: 'Next',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 30,
                          fontSize: 16,
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpScreen2.id);
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
