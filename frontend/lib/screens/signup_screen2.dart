import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:pro_buddy/components/rounded_button.dart';
import 'package:pro_buddy/components/rounded_multiline_textbox.dart';
import 'package:pro_buddy/components/rounded_textbox.dart';
import 'package:pro_buddy/screens/home_screen.dart';
import 'package:pro_buddy/screens/signup_screen1.dart';

class SignUpScreen2 extends StatefulWidget {
  static const String id = 'signup_screen_2';

  const SignUpScreen2({Key? key}) : super(key: key);

  @override
  State<SignUpScreen2> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen2> {
  static final List<String> _activities = [
    'Hiking',
    'Dining out',
    'Volunteering',
    'Swimming'
  ];
  static final List<String> _services = [
    'Financial Consultation',
    'Mental Health Consultation'
  ];

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
                      height: 20,
                    ),
                    const Text('Which activities would you like to do with friends?'),
                    const SizedBox(
                      height: 10,
                    ),
                    MultiSelectDialogField(
                      items: _activities.map((e) => MultiSelectItem(e, e)).toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        // _selectedAnimals = values;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Which services would you like to provide?'),
                    const SizedBox(
                      height: 10,
                    ),
                    MultiSelectDialogField(
                      items: _services.map((e) => MultiSelectItem(e, e)).toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        //TODO _selectedAnimals = values;
                      },
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
                          height: 30,
                          fontSize: 16,
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpScreen1.id);
                          },
                        ),
                        RoundedButton(
                          title: 'Finish',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 30,
                          fontSize: 16,
                          onPressed: () {
                            Navigator.pushNamed(context, HomeScreen.id);
                          },
                        )
                      ],
                    )
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
