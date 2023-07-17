import 'package:flutter/material.dart';
import '../models/buddy_group.dart';
import 'home_screen.dart';
import '../components/rounded_button.dart';
import '../models/auth_user.dart';
import '../services/buddy_services.dart';
import '../services/auth_services.dart';

class ViewGroupScreen extends StatefulWidget {
  static const String id = 'view_group';

  const ViewGroupScreen({super.key});

  @override
  ViewGroupScreenState createState() => ViewGroupScreenState();
}

class ViewGroupScreenState extends State<ViewGroupScreen> {
  @override
  Widget build(BuildContext context) {
    BuddyGroup group = ModalRoute.of(context)?.settings.arguments as BuddyGroup;

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
                          'View Group',
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
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          group.name!,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          group.description!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedButton(
                        title: 'Go Back',
                        backgroundColour: const Color(0xFF6750A4),
                        textColour: const Color(0xFFD0BCFF),
                        height: 40,
                        fontSize: 16,
                        onPressed: () {
                          Navigator.pushNamed(context, HomeScreen.id);
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
