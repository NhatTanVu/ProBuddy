import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:pro_buddy/components/rounded_button.dart';
import 'signup_screen2.dart';
import 'home_screen.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

class SignUpScreen3 extends StatefulWidget {
  static const String id = 'signup_screen_3';

  const SignUpScreen3({Key? key}) : super(key: key);

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
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
  late List<String> _selectedActivities;
  late List<String> _selectedServices;
  String _message = "";

  Future<void> _signUpUser(AuthUser? signUpUser, BuildContext context) async {
    try {
      await AuthService.signUp(signUpUser as AuthUser);
      await AuthService.login(signUpUser?.userName as String, signUpUser?.password as String);
      Navigator.pushNamed(context, HomeScreen.id);
    } on Exception catch (e, _) {
      setState(() {
        _message = e.toString().replaceAll("Exception: ", "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthUser? signUpUser =
        ModalRoute.of(context)?.settings.arguments as AuthUser?;
    if (signUpUser == null) {
      signUpUser = AuthUser.fromEmpty();
    } else {
      _selectedActivities =
          signUpUser?.userInterests?.map((e) => e.toString()).toList() ??
              <String>[];
      _selectedServices =
          signUpUser?.userServices?.map((e) => e.toString()).toList() ??
              <String>[];
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
                    const Text(
                        'Which activities would you like to do with friends?'),
                    const SizedBox(
                      height: 10,
                    ),
                    MultiSelectDialogField(
                      initialValue: _selectedActivities,
                      items: _activities
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        _selectedActivities = values;
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
                      initialValue: _selectedServices,
                      items:
                          _services.map((e) => MultiSelectItem(e, e)).toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        _selectedServices = values;
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
                          height: 40,
                          fontSize: 16,
                          onPressed: () {
                            signUpUser?.userInterests = _selectedActivities;
                            signUpUser?.userServices = _selectedServices;
                            Navigator.pushNamed(context, SignUpScreen2.id,
                                arguments: signUpUser);
                          },
                        ),
                        RoundedButton(
                          title: 'Finish',
                          backgroundColour: const Color(0xFF6750A4),
                          textColour: const Color(0xFFD0BCFF),
                          height: 40,
                          fontSize: 16,
                          onPressed: () {
                            signUpUser?.userInterests = _selectedActivities;
                            signUpUser?.userServices = _selectedServices;
                            _signUpUser(signUpUser, context);
                          },
                        )
                      ],
                    ),
                    Visibility(
                      visible: _message != "",
                      child: const SizedBox(
                        height: 20,
                      ),
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
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
