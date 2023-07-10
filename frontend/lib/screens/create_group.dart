import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../components/rounded_button.dart';
import '../components/rounded_multiline_textbox.dart';
import '../components/rounded_textbox.dart';
import '../models/auth_user.dart';
import '../services/buddy_services.dart';
import '../services/auth_services.dart';

class CreateGroupScreen extends StatefulWidget {
  static const String id = 'create_group';

  const CreateGroupScreen({super.key});

  @override
  CreateGroupScreenState createState() => CreateGroupScreenState();
}

class CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _message = "";

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createGroup() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    AuthUser currentUser = await AuthServices.loadUser();

    try {
      await BuddyServices.createGroup(
          name, description, currentUser.userId!, currentUser.jwtToken!);
      _nameController.clear();
      _descriptionController.clear();
      Navigator.pushNamed(context, HomeScreen.id);
    } on Exception catch (e, _) {
      setState(() {
        _message = e.toString().replaceAll("Exception: ", "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          'Create Group',
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
                    controller: _nameController,
                    hintText: 'Group name',
                    backgroundColour: const Color(0xFF49454F),
                    textColour: const Color(0xFFCAC4D0),
                    height: 40,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedMultiLineTextField(
                    controller: _descriptionController,
                    hintText: 'Description',
                    backgroundColour: const Color(0xFF49454F),
                    textColour: const Color(0xFFCAC4D0),
                    height: 120,
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
                        height: 40,
                        fontSize: 16,
                        onPressed: () {
                          _nameController.clear();
                          _descriptionController.clear();
                          Navigator.pushNamed(context, HomeScreen.id);
                        },
                      ),
                      RoundedButton(
                        title: 'Create Group',
                        backgroundColour: const Color(0xFF6750A4),
                        textColour: const Color(0xFFD0BCFF),
                        height: 40,
                        fontSize: 16,
                        width: 130,
                        onPressed: () => _createGroup(),
                      ),
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
            ),
          ),
        ]),
      ),
    );
  }
}
