import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_buddy/models/auth_user.dart';
import '../components/rounded_button.dart';
import '../components/date_time_picker.dart';
import '../components/rounded_multiline_textbox.dart';
import 'signup_screen1.dart';
import 'signup_screen3.dart';

class SignUpScreen2 extends StatefulWidget {
  static const String id = 'signup_screen_2';

  const SignUpScreen2({Key? key}) : super(key: key);

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthUser? signUpUser =
        ModalRoute.of(context)?.settings.arguments as AuthUser?;
    if (signUpUser == null) {
      signUpUser = AuthUser.fromEmpty();
    } else {
      _addressController.text = signUpUser.address as String;
      signUpUser.gender ??= 'M';
      if (signUpUser.dob != null) {
        _dobController.text =
            DateFormat('yyyy-MM-dd').format(signUpUser.dob as DateTime);
      }
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
                              value: 'F',
                              groupValue: signUpUser?.gender,
                              onChanged: (value) {
                                setState(() {
                                  signUpUser?.gender = value!;
                                });
                              },
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
                              value: 'M',
                              groupValue: signUpUser?.gender,
                              onChanged: (value) {
                                setState(() {
                                  signUpUser?.gender = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    DateTimePicker(
                      hintText: 'Date of Birth',
                      controller: _dobController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedMultiLineTextField(
                      controller: _addressController,
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
                          title: 'Previous',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 40,
                          fontSize: 16,
                          onPressed: () {
                            signUpUser?.address = _addressController.text;
                            signUpUser?.dob = _dobController.text != ""
                                ? DateFormat('yyyy-MM-dd')
                                    .parse(_dobController.text)
                                : null;
                            Navigator.pushNamed(context, SignUpScreen1.id,
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
                            signUpUser?.address = _addressController.text;
                            signUpUser?.dob = _dobController.text != ""
                                ? DateFormat('yyyy-MM-dd')
                                    .parse(_dobController.text)
                                : null;
                            Navigator.pushNamed(context, SignUpScreen3.id,
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
