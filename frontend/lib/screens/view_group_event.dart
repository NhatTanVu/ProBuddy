import 'package:flutter/material.dart';
import 'package:pro_buddy/models/buddy_group_event.dart';
import 'package:pro_buddy/models/buddy_group_event_member.dart';
import '../models/auth_user.dart';
import '../services/auth_services.dart';
import '../services/buddy_services.dart';
import '../services/config.dart';
import 'home_screen.dart';
import 'view_group.dart';
import '../components/rounded_button.dart';
import 'welcome_screen.dart';

class ViewGroupEventScreen extends StatefulWidget {
  static const String id = 'view_group_event';

  const ViewGroupEventScreen({super.key});

  @override
  ViewGroupEventScreenState createState() => ViewGroupEventScreenState();
}

class ViewGroupEventScreenStateData {
  AuthUser currentUser;
  bool isRegistered;

  ViewGroupEventScreenStateData(
      {required this.currentUser, required this.isRegistered});
}

class ViewGroupEventScreenState extends State<ViewGroupEventScreen> {
  String _message = "";

  Future<ViewGroupEventScreenStateData> fetchData(int eventId) async {
    AuthUser currentUser = await AuthServices.loadUser();
    List<BuddyGroupEventMember> eventMembers =
        await BuddyServices.viewGroupEventMembersByEventId(
            eventId, currentUser.jwtToken!);
    bool isRegistered =
        eventMembers.any((obj) => obj.user == currentUser.userId);
    ViewGroupEventScreenStateData stateData = ViewGroupEventScreenStateData(
        currentUser: currentUser, isRegistered: isRegistered);
    return stateData;
  }

  void _registerGroupEvent(int userId, int eventId, String jwtToken) async {
    try {
      await BuddyServices.registerGroupEvent(userId, eventId, jwtToken);
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
    BuddyGroupEvent groupEvent =
        ModalRoute.of(context)?.settings.arguments as BuddyGroupEvent;

    return FutureBuilder<ViewGroupEventScreenStateData>(
        future: fetchData(groupEvent.eventId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError &&
              snapshot.error.toString() ==
                  Config.unauthorizedExceptionMessage) {
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            });
            return Container();
          } else if (snapshot.data == null) {
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            });
            return Container();
          } else {
            ViewGroupEventScreenStateData stateData =
                snapshot.data as ViewGroupEventScreenStateData;
            AuthUser currentUser = stateData.currentUser;
            bool isOrganizer = currentUser.userId == groupEvent.createdBy;
            bool isRegistered = stateData.isRegistered;

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
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  groupEvent.name!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
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
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  groupEvent.description!,
                                ),
                              ),
                            ],
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
                              Visibility(
                                visible: !isOrganizer && !isRegistered,
                                child: RoundedButton(
                                  title: 'Register',
                                  backgroundColour: const Color(0xFF6750A4),
                                  textColour: const Color(0xFFD0BCFF),
                                  height: 40,
                                  fontSize: 16,
                                  onPressed: () => _registerGroupEvent(
                                      currentUser.userId!,
                                      groupEvent.eventId!,
                                      currentUser.jwtToken!),
                                ),
                              ),
                              Visibility(
                                visible: isOrganizer,
                                child: RoundedButton(
                                  title: 'Edit Event',
                                  backgroundColour: const Color(0xFF6750A4),
                                  textColour: const Color(0xFFD0BCFF),
                                  height: 40,
                                  width: 130,
                                  fontSize: 16,
                                  onPressed: () {
                                    // Navigator.pushNamed(
                                    //     context, CreateGroupEventScreen1.id,
                                    //     arguments: groupEvent.groupId);
                                  },
                                ),
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
        });
  }
}