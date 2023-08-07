import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_buddy/models/buddy_group_event.dart';
import 'package:pro_buddy/screens/view_group.dart';
import '../components/rounded_button.dart';
import '../components/rounded_multiline_textbox.dart';
import '../components/rounded_textbox.dart';
import 'create_group_event2.dart';
import 'home_screen.dart';

class CreateGroupEventScreen1 extends StatefulWidget {
  static const String id = 'create_group_event_1';

  const CreateGroupEventScreen1({super.key});

  @override
  CreateGroupEventScreen1State createState() => CreateGroupEventScreen1State();
}

class CreateGroupEventScreen1State extends State<CreateGroupEventScreen1> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late File? _image = null;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int? groupId;
    BuddyGroupEvent? event;

    if (ModalRoute.of(context)?.settings.arguments is int?) {
      groupId = ModalRoute.of(context)?.settings.arguments as int?;
    } else if (ModalRoute.of(context)?.settings.arguments is BuddyGroupEvent?) {
      event = ModalRoute.of(context)?.settings.arguments as BuddyGroupEvent?;
    }

    if (event == null) {
      event = BuddyGroupEvent.fromEmpty();
      event.buddyGroup = groupId;
    } else {
      _nameController.text = event.name as String;
      _descriptionController.text = event.description as String;
      _image = event.imageFile;
    }

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
                          'Create Event',
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
                    hintText: 'Name',
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
                  RoundedButton(
                    title: 'Upload Photo',
                    backgroundColour: const Color(0xFF6750A4),
                    textColour: const Color(0xFFD0BCFF),
                    height: 40,
                    fontSize: 16,
                    onPressed: _pickImage,
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
                          Navigator.pushNamed(context, ViewGroupScreen.id,
                              arguments: event?.buddyGroup);
                        },
                      ),
                      RoundedButton(
                        title: 'Next',
                        backgroundColour: const Color(0xFF6750A4),
                        textColour: const Color(0xFFD0BCFF),
                        height: 40,
                        fontSize: 16,
                        onPressed: () {
                          event?.name = _nameController.text;
                          event?.description = _descriptionController.text;
                          event?.imageFile = _image;
                          Navigator.pushNamed(
                              context, CreateGroupEventScreen2.id,
                              arguments: event);
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
