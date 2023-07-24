import 'package:flutter/material.dart';
import '../components/clickable_row.dart';
import '../models/auth_user.dart';
import '../models/buddy_group.dart';
import '../services/auth_services.dart';
import '../services/config.dart';
import '../services/utility.dart';
import '../services/buddy_services.dart';
import 'create_group.dart';
import 'view_group.dart';
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
      setState(() {
        _initials = Utility.getInitials(
            [_currentUser.firstName, _currentUser.lastName].join(" "));
        _createdGroups = allCreatedGroups.take(3).toList();
        _joinedGroups = allJoinedGroups.take(2).toList();
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
                              children: [
                                const Text(
                                  'Upcoming Events',
                                  style: TextStyle(fontSize: 20),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              AssetImage("images/Hiking.png"),
                                        ),
                                      ),
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
                                                  children: const [
                                                    Text(
                                                      '01',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Apr',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 12,
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
                                                children: const <Widget>[
                                                  Text(
                                                    'Hiking',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    '6AM - 7PM',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    'Cypress Mountain',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                Expanded(
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage("images/Movie.png"),
                                        ),
                                      ),
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
                                                  children: const [
                                                    Text(
                                                      '02',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Apr',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 12,
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
                                                children: const <Widget>[
                                                  Text(
                                                    'Movie Night',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    '8PM - 10PM',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    'Metrotown',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                Expanded(
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "images/Volunteer.png"),
                                        ),
                                      ),
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
                                                  children: const [
                                                    Text(
                                                      '10',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Apr',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF49454F),
                                                        fontSize: 12,
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
                                                children: const <Widget>[
                                                  Text(
                                                    'Volunteering',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    '1PM - 8PM',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    'Golden creek park',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue),
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
                                  ListView(
                                    children: ListTile.divideTiles(
                                      context: context,
                                      color: Colors.white,
                                      tiles: [
                                        ListTile(
                                          textColor: Colors.white,
                                          title: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        'THU, 29 JUN • 6:00 PM GMT-7'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        'Where and How to Make New Friends: Intractive Webminar'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        'Personal Development and Friendship Coaching Online'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text('36 going'),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: SizedBox(
                                                    height: 80,
                                                    child: Image.asset(
                                                      "images/friendship.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        ListTile(
                                          textColor: Colors.white,
                                          title: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        'WED, 5 JUL • 6:00 PM GMT-7'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        'Addressing Security Concerns in ChatGPT'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        'Vancouver ChatGPT Experts'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text('33 going'),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: SizedBox(
                                                    height: 80,
                                                    child: Image.asset(
                                                      "images/chat_gpt_experts.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).toList(),
                                  ),
                                  const Center(
                                    child:
                                        Text('Hmm, nothing on the horizon...'),
                                  ),
                                  ListView(
                                    children: ListTile.divideTiles(
                                      context: context,
                                      color: Colors.white,
                                      tiles: [
                                        ListTile(
                                          textColor: Colors.white,
                                          title: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                        'WED, 7 JUN • 6:00 PM GMT-7'),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                        'Building Better Relationships with ChatGPT'),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                        'Vancouver ChatGPT Experts'),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.check_circle,
                                                          size: 30,
                                                          color: Colors
                                                              .greenAccent,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text('208 going'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: SizedBox(
                                                    height: 80,
                                                    child: Image.asset(
                                                      "images/ai-generated.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).toList(),
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
