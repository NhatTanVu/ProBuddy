import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../models/auth_user.dart';
import '../services/auth_services.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile';

  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late AuthUser _currentUser;

  @override
  Widget build(BuildContext context) {
    _currentUser = ModalRoute.of(context)?.settings.arguments as AuthUser;

    return SafeArea(
      child: Scaffold(
        body: Column(children: [
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
                          'Profile',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedButton(
                        title: 'Go Back',
                        backgroundColour: const Color(0xFF6750A4),
                        textColour: const Color(0xFFD0BCFF),
                        height: 40,
                        fontSize: 16,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      RoundedButton(
                        title: 'Log out',
                        backgroundColour: const Color(0xFF6750A4),
                        textColour: const Color(0xFFD0BCFF),
                        height: 40,
                        fontSize: 16,
                        onPressed: () async {
                          await AuthServices.logout(_currentUser.jwtToken!,
                              _currentUser.refreshToken!);
                          Navigator.pushNamed(context, WelcomeScreen.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
