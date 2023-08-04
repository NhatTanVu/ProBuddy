import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_buddy/models/buddy_group_event.dart';
import '../models/auth_user.dart';
import '../models/buddy_group.dart';
import '../services/auth_services.dart';
import '../services/buddy_services.dart';
import '../services/config.dart';
import 'home_screen.dart';
import 'create_group_event1.dart';
import '../components/rounded_button.dart';
import 'view_group_event.dart';
import 'welcome_screen.dart';

class ViewGroupScreen extends StatefulWidget {
  static const String id = 'view_group';

  const ViewGroupScreen({super.key});

  @override
  ViewGroupScreenState createState() => ViewGroupScreenState();
}

class ViewGroupScreenStateData {
  AuthUser currentUser;
  BuddyGroup buddyGroup;

  ViewGroupScreenStateData(
      {required this.currentUser, required this.buddyGroup});
}

class ViewGroupScreenState extends State<ViewGroupScreen> {
  String _message = "";

  @override
  void initState() {
    super.initState();
  }

  Future<ViewGroupScreenStateData> fetchDataFromGroupId(int groupId) async {
    AuthUser currentUser = await AuthServices.loadUser();
    BuddyGroup buddyGroup =
        await BuddyServices.viewGroupById(groupId, currentUser.jwtToken!);
    return ViewGroupScreenStateData(
        currentUser: currentUser, buddyGroup: buddyGroup);
  }

  Future<ViewGroupScreenStateData> fetchDataFromGroup(BuddyGroup group) async {
    AuthUser currentUser = await AuthServices.loadUser();
    return ViewGroupScreenStateData(
        currentUser: currentUser, buddyGroup: group);
  }

  void _joinGroup(int userId, int groupId, String jwtToken) async {
    try {
      await BuddyServices.joinGroup(userId, groupId, jwtToken);
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

  void _leaveGroup(int userId, int groupId, String jwtToken) async {
    try {
      await BuddyServices.leaveGroup(userId, groupId, jwtToken);
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
    int? groupId;
    BuddyGroup? group;

    if (ModalRoute.of(context)?.settings.arguments is int) {
      groupId = ModalRoute.of(context)?.settings.arguments as int;
    } else if (ModalRoute.of(context)?.settings.arguments is BuddyGroup) {
      group = ModalRoute.of(context)?.settings.arguments as BuddyGroup;
    }

    return FutureBuilder<ViewGroupScreenStateData>(
      future: (group != null)
          ? fetchDataFromGroup(group)
          : fetchDataFromGroupId(groupId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError &&
            snapshot.error.toString() == Config.unauthorizedExceptionMessage) {
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
          BuddyGroup group = snapshot.data!.buddyGroup;
          AuthUser currentUser = snapshot.data!.currentUser;
          String organizer =
              "${group.createdBy.lastName!} ${group.createdBy.firstName!}";
          List<BuddyGroupEvent> upcomingEvents =
              group.events.where((element) => !element.isFinished!).toList();
          upcomingEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));
          upcomingEvents = upcomingEvents.take(2).toList();
          List<BuddyGroupEvent> pastEvents = group.events
              .where((element) => element.isFinished!)
              .take(2)
              .toList();
          bool isOrganizer = group.createdBy.userId == currentUser.userId;
          bool isMember = group.memberIds.contains(currentUser.userId!);

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
                                group.name!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                group.description!,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Organizer',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(organizer),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Color(0xFFE6E6E6),
                          thickness: 0.5,
                        ),
                        Visibility(
                          visible: upcomingEvents.isNotEmpty,
                          child: const SizedBox(
                            height: 10,
                          ),
                        ),
                        Visibility(
                          visible: upcomingEvents.isNotEmpty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Upcoming Events',
                                style: TextStyle(fontSize: 20),
                              ),
                              Visibility(
                                visible: upcomingEvents.length > 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            for (var event in upcomingEvents)
                              Expanded(
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ViewGroupEventScreen.id,
                                          arguments: event);
                                    },
                                    child: Container(
                                      // decoration: const BoxDecoration(
                                      //   image: DecorationImage(
                                      //     fit: BoxFit.cover,
                                      //     image: AssetImage("images/Hiking.png"),
                                      //   ),
                                      // ),
                                      height: 140,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: Card(
                                              color: const Color(0xFFCAC4D0),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 2, 5, 2),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      event.startDate!.day
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      (event.startDate!.year ==
                                                              DateTime.now()
                                                                  .year)
                                                          ? DateFormat(
                                                                  '   MMM   ')
                                                              .format(event
                                                                  .startDate!)
                                                          : DateFormat(
                                                                  'MMM yyyy')
                                                              .format(event
                                                                  .startDate!),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              color: const Color(0xAA1C1B19),
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    event.name!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  const Text(
                                                    ' - ',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    event.location!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Visibility(
                          visible: pastEvents.isNotEmpty,
                          child: SizedBox(
                            height: upcomingEvents.isEmpty ? 10 : 20,
                          ),
                        ),
                        Visibility(
                          visible: pastEvents.isNotEmpty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Past Events',
                                style: TextStyle(fontSize: 20),
                              ),
                              Visibility(
                                visible: pastEvents.length > 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            for (var event in pastEvents)
                              Expanded(
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ViewGroupEventScreen.id,
                                          arguments: event);
                                    },
                                    child: Container(
                                      // decoration: const BoxDecoration(
                                      //   image: DecorationImage(
                                      //     fit: BoxFit.cover,
                                      //     image: AssetImage("images/Hiking.png"),
                                      //   ),
                                      // ),
                                      height: 140,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: Card(
                                              color: const Color(0xFFCAC4D0),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 2, 5, 2),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      event.startDate!.day
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      (event.startDate!.year ==
                                                              DateTime.now()
                                                                  .year)
                                                          ? DateFormat(
                                                                  '   MMM   ')
                                                              .format(event
                                                                  .startDate!)
                                                          : DateFormat(
                                                                  'MMM yyyy')
                                                              .format(event
                                                                  .startDate!),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              color: const Color(0xAA1C1B19),
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    event.name!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  const Text(
                                                    ' - ',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    event.location!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              flex: (pastEvents.length == 1) ? 1 : 0,
                              child: Container(),
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
                              visible: isOrganizer,
                              child: RoundedButton(
                                title: 'Create Event',
                                backgroundColour: const Color(0xFF6750A4),
                                textColour: const Color(0xFFD0BCFF),
                                height: 40,
                                width: 130,
                                fontSize: 16,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, CreateGroupEventScreen1.id,
                                      arguments: group.groupId);
                                },
                              ),
                            ),
                            Visibility(
                              visible: !isOrganizer && !isMember,
                              child: RoundedButton(
                                title: 'Join Group',
                                backgroundColour: const Color(0xFF6750A4),
                                textColour: const Color(0xFFD0BCFF),
                                height: 40,
                                width: 130,
                                fontSize: 16,
                                onPressed: () => _joinGroup(
                                    currentUser.userId!,
                                    group.groupId!,
                                    currentUser.jwtToken!),
                              ),
                            ),
                            Visibility(
                              visible: !isOrganizer && isMember,
                              child: RoundedButton(
                                title: 'Leave Group',
                                backgroundColour: const Color(0xFF6750A4),
                                textColour: const Color(0xFFD0BCFF),
                                height: 40,
                                width: 130,
                                fontSize: 16,
                                onPressed: () => _leaveGroup(
                                    currentUser.userId!,
                                    group.groupId!,
                                    currentUser.jwtToken!),
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
      },
    );
  }
}
