import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_buddy/models/buddy_group_event.dart';
import '../services/config.dart';
import '../components/rounded_button.dart';
import '../components/rounded_multiline_textbox.dart';
import '../components/date_time_picker.dart';
import '../models/auth_user.dart';
import '../services/buddy_services.dart';
import '../services/auth_services.dart';
import 'create_group_event1.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

class CreateGroupEventScreen2 extends StatefulWidget {
  static const String id = 'create_group_event_2';

  const CreateGroupEventScreen2({super.key});

  @override
  CreateGroupEventScreen2State createState() => CreateGroupEventScreen2State();
}

class CreateGroupEventScreen2State extends State<CreateGroupEventScreen2> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _message = "";

  @override
  void dispose() {
    _startDateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _createGroupEvent(BuddyGroupEvent event) async {
    DateTime startDate =
        DateFormat('yyyy-MM-dd').parse(_startDateController.text);
    String location = _locationController.text;
    AuthUser currentUser = await AuthServices.loadUser();
    event.startDate = startDate;
    event.location = location;
    event.createdBy = currentUser.userId;

    try {
      await BuddyServices.createGroupEvent(event, currentUser.jwtToken!);
      _startDateController.clear();
      _locationController.clear();
      Navigator.pushNamed(context, HomeScreen.id);
    } on Exception catch (e, _) {
      if (e.toString() == Config.unauthorizedExceptionMessage) {
        Navigator.pushNamed(context, WelcomeScreen.id);
      } else {
        setState(() {
          _message = e.toString().replaceAll("Exception: ", "");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BuddyGroupEvent? event =
        ModalRoute.of(context)?.settings.arguments as BuddyGroupEvent?;
    if (event == null) {
      event = BuddyGroupEvent.fromEmpty();
    } else {
      if (event.startDate != null) {
        _startDateController.text =
            DateFormat('yyyy-MM-dd').format(event.startDate as DateTime);
      }
      _locationController.text = event.location as String;
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
                          'Create Event (continued)',
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
                  DateTimePicker(
                    hintText: 'Start Date',
                    controller: _startDateController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedMultiLineTextField(
                    controller: _locationController,
                    hintText: 'Location',
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
                        title: 'Previous',
                        backgroundColour: const Color(0xFF6750A4),
                        textColour: const Color(0xFFD0BCFF),
                        height: 40,
                        fontSize: 16,
                        onPressed: () {
                          event?.startDate = (_startDateController.text != "")
                              ? DateFormat('yyyy-MM-dd')
                                  .parse(_startDateController.text)
                              : null;
                          event?.location = _locationController.text;
                          Navigator.pushNamed(
                              context, CreateGroupEventScreen1.id,
                              arguments: event);
                        },
                      ),
                      RoundedButton(
                        title: 'Create Event',
                        backgroundColour: const Color(0xFF6750A4),
                        textColour: const Color(0xFFD0BCFF),
                        height: 40,
                        fontSize: 16,
                        width: 130,
                        onPressed: () => _createGroupEvent(event!),
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
