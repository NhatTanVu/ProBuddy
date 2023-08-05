import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../models/auth_user.dart';
import '../models/buddy_group.dart';
import '../services/auth_services.dart';
import '../services/buddy_services.dart';
import '../services/config.dart';
import 'view_group.dart';
import 'welcome_screen.dart';

class ViewAllGroupsScreen extends StatefulWidget {
  static const String id = 'view_all_groups';

  const ViewAllGroupsScreen({super.key});

  @override
  ViewAllGroupsScreenState createState() => ViewAllGroupsScreenState();
}

class ViewAllGroupsScreenState extends State<ViewAllGroupsScreen> {
  late List<BuddyGroup> _allGroups = [];
  late AuthUser _currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      _currentUser = await AuthServices.loadUser();
      var allGroups = await BuddyServices.viewAllGroups(_currentUser.jwtToken!);
      setState(() {
        _allGroups = allGroups
            .where((g) =>
                !g.memberIds.contains(_currentUser.userId!) &&
                g.createdBy.userId != _currentUser.userId)
            .toList();
      });
    } catch (error) {
      if (error.toString() == Config.unauthorizedExceptionMessage) {
        Navigator.pushNamed(context, WelcomeScreen.id);
      }
    } finally {
      setState(() {
        isLoading = false;
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
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1C1F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      flex: 1,
                      child: Text(
                        "All Groups",
                        style: TextStyle(
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
                for (int i = 0; i < _allGroups.length; i += 2)
                  Row(
                    children: [
                      for (int j = i;
                          (j < (i + 2)) && (j < _allGroups.length);
                          j++)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
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
                                      context, ViewGroupScreen.id,
                                      arguments: _allGroups[j]);
                                },
                                child: Container(
                                  decoration: (_allGroups[j].image == null) ? null : BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(_allGroups[j].image!),
                                    ),
                                  ),
                                  height: 140,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 70,
                                          color: const Color(0xAA1C1B19),
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _allGroups[j].name!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              )
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
                        ),
                      Expanded(
                        flex: (i < _allGroups.length - 1) ? 0 : 1,
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
                  ],
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
