import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_buddy/models/buddy_group_event.dart';
import '../components/clickable_row.dart';
import '../models/auth_user.dart';
import '../models/buddy_group.dart';
import '../services/auth_services.dart';
import '../services/config.dart';
import '../services/utility.dart';
import '../services/buddy_services.dart';
import 'create_group.dart';
import 'view_group.dart';
import 'view_group_event.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0;
  late AuthUser _currentUser;
  late String _initials = '';
  late List<BuddyGroup> _createdGroups = [];
  late List<BuddyGroup> _joinedGroups = [];

  late List<BuddyGroupEvent> _allEvents = [];
  late List<BuddyGroupEvent> _upcomingEvents = [];
  late List<BuddyGroupEvent> _goingEvents = [];
  late List<BuddyGroupEvent> _pastEvents = [];

  bool isLoading = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      _currentUser = await AuthServices.loadUser();
      var allCreatedGroups = await BuddyServices.viewCreatedGroupsByUserId(
          _currentUser.userId!, _currentUser.jwtToken!);
      var allJoinedGroups = await BuddyServices.viewJoinedGroupsByUserId(
          _currentUser.userId!, _currentUser.jwtToken!);
      _allEvents = await BuddyServices.viewJoinedGroupEventsByUserId(
          _currentUser.userId!, _currentUser.jwtToken!);
      setState(() {
        _initials = Utility.getInitials(
            [_currentUser.firstName, _currentUser.lastName].join(" "));
        _createdGroups = allCreatedGroups.take(3).toList();
        _joinedGroups = allJoinedGroups.take(2).toList();
        _goingEvents = _allEvents.where((event) => !event.isFinished!).toList();
        _upcomingEvents = _goingEvents.take(3).toList();
        _pastEvents = _allEvents.where((event) => event.isFinished!).toList();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF49454F),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF1c1b1f),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF49454F),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Center(
                          child: Hero(
                            tag: 'logo',
                            child: SizedBox(
                              height: 50,
                              child: Image.asset('images/logo.png'),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 10,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFF1c1b1f),
                                child: Text(
                                  _initials,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Upcoming Events',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                for (var event in _upcomingEvents)
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
                                                  color:
                                                      const Color(0xFFCAC4D0),
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 2, 5, 2),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          event.startDate!.day
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF49454F),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          (event.startDate!
                                                                      .year ==
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
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF49454F),
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
                                                  color:
                                                      const Color(0xAA1C1B19),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        event.name!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      const Text(
                                                        ' - ',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        event.location!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                  flex: (3 - _upcomingEvents.length),
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
                                const Text(
                                  'Created Groups',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Visibility(
                                  visible: _createdGroups.length > 3,
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                for (var group in _createdGroups)
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
                                              context, ViewGroupScreen.id,
                                              arguments: group);
                                        },
                                        child: SizedBox(
                                          height: 140,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 70,
                                                  color:
                                                      const Color(0xAA1C1B19),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        group.name!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                Expanded(
                                  flex: (3 - _createdGroups.length),
                                  child: Container(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ClickableRow(
                              title: 'Start a new group',
                              subtitle: 'Organize your own events',
                              leadingIcon: Icons.group_add,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, CreateGroupScreen.id);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Joined Groups',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Visibility(
                                  visible: _joinedGroups.length > 2,
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                for (var group in _joinedGroups)
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
                                              context, ViewGroupScreen.id,
                                              arguments: group);
                                        },
                                        child: SizedBox(
                                          height: 140,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 70,
                                                  color:
                                                      const Color(0xAA1C1B19),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        group.name!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                Expanded(
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SizedBox(
                                      height: 140,
                                      child: Stack(
                                        children: [
                                          const Positioned(
                                            top: 0,
                                            left: 10,
                                            child: Icon(
                                              Icons.groups,
                                              color: Color(0xFFD0BCFF),
                                              size: 40,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const <Widget>[
                                                  Text(
                                                    'Discover\nmore groups',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Positioned(
                                            bottom: 0,
                                            right: 10,
                                            child: Icon(
                                              Icons.trending_flat,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: (2 - _joinedGroups.length),
                                  child: Container(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'My calendar',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TabBar(
                              // unselectedLabelColor: Colors.black,
                              // labelColor: Colors.red,
                              tabs: const [
                                Tab(
                                  text: 'ALL',
                                ),
                                Tab(
                                  text: 'GOING',
                                ),
                                Tab(
                                  text: 'PAST',
                                ),
                              ],
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              height: 311,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  (_allEvents.isNotEmpty)
                                      ? ListView(
                                          children: ListTile.divideTiles(
                                            context: context,
                                            color: Colors.white,
                                            tiles: [
                                              for (var event in _allEvents)
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        ViewGroupEventScreen.id,
                                                        arguments: event);
                                                  },
                                                  textColor: Colors.white,
                                                  title: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(DateFormat(
                                                                    'EEE, dd MMM yyyy')
                                                                .format(event
                                                                    .startDate!)),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  event.name!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Color(
                                                                          0xFFD0BCFF)),
                                                                ),
                                                                Visibility(
                                                                  visible: event
                                                                      .isFinished!,
                                                                  child:
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                ),
                                                                Visibility(
                                                                  visible: event
                                                                      .isFinished!,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .greenAccent,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(event
                                                                .description!),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            // Text('36 going'),
                                                          ],
                                                        ),
                                                      ),
                                                      // Expanded(
                                                      //   flex: 1,
                                                      //   child: Card(
                                                      //     clipBehavior: Clip.antiAlias,
                                                      //     elevation: 5,
                                                      //     shape: RoundedRectangleBorder(
                                                      //       borderRadius:
                                                      //       BorderRadius.circular(
                                                      //           10),
                                                      //     ),
                                                      //     child: SizedBox(
                                                      //       height: 80,
                                                      //       child: Image.asset(
                                                      //         "images/friendship.jpg",
                                                      //         fit: BoxFit.cover,
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ).toList(),
                                        )
                                      : const Center(
                                          child: Text(
                                              'Hmm, nothing on the horizon...'),
                                        ),
                                  (_goingEvents.isNotEmpty)
                                      ? ListView(
                                          children: ListTile.divideTiles(
                                            context: context,
                                            color: Colors.white,
                                            tiles: [
                                              for (var event in _goingEvents)
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        ViewGroupEventScreen.id,
                                                        arguments: event);
                                                  },
                                                  textColor: Colors.white,
                                                  title: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(DateFormat(
                                                                    'EEE, dd MMM yyyy')
                                                                .format(event
                                                                    .startDate!)),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              event.name!,
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Color(
                                                                      0xFFD0BCFF)),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(event
                                                                .description!),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            // Text('36 going'),
                                                          ],
                                                        ),
                                                      ),
                                                      // Expanded(
                                                      //   flex: 1,
                                                      //   child: Card(
                                                      //     clipBehavior: Clip.antiAlias,
                                                      //     elevation: 5,
                                                      //     shape: RoundedRectangleBorder(
                                                      //       borderRadius:
                                                      //       BorderRadius.circular(
                                                      //           10),
                                                      //     ),
                                                      //     child: SizedBox(
                                                      //       height: 80,
                                                      //       child: Image.asset(
                                                      //         "images/friendship.jpg",
                                                      //         fit: BoxFit.cover,
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ).toList(),
                                        )
                                      : const Center(
                                          child: Text(
                                              'Hmm, nothing on the horizon...'),
                                        ),
                                  (_pastEvents.isNotEmpty)
                                      ? ListView(
                                          children: ListTile.divideTiles(
                                            context: context,
                                            color: Colors.white,
                                            tiles: [
                                              for (var event in _pastEvents)
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, ViewGroupEventScreen.id,
                                                        arguments: event);
                                                  },
                                                  textColor: Colors.white,
                                                  title: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(DateFormat(
                                                                    'EEE, dd MMM yyyy')
                                                                .format(event
                                                                    .startDate!)),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  event.name!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Color(
                                                                          0xFFD0BCFF)),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .greenAccent,
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(event
                                                                .description!),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            // Text('36 going'),
                                                          ],
                                                        ),
                                                      ),
                                                      // Expanded(
                                                      //   flex: 1,
                                                      //   child: Card(
                                                      //     clipBehavior: Clip.antiAlias,
                                                      //     elevation: 5,
                                                      //     shape: RoundedRectangleBorder(
                                                      //       borderRadius:
                                                      //       BorderRadius.circular(
                                                      //           10),
                                                      //     ),
                                                      //     child: SizedBox(
                                                      //       height: 80,
                                                      //       child: Image.asset(
                                                      //         "images/friendship.jpg",
                                                      //         fit: BoxFit.cover,
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ).toList(),
                                        )
                                      : const Center(
                                          child: Text(
                                              'Hmm, nothing on the horizon...'),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF49454F),
              selectedItemColor: const Color(0xFF9A80E9),
              unselectedItemColor: const Color(0xFFCAC4D0),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 30,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    size: 30,
                  ),
                  label: 'Messages',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
