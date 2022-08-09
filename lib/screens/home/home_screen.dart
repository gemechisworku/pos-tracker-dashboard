// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  HomeScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => HomeScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('POSTMS'),
          elevation: 15,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              tooltip: 'View in map',
              onPressed: () {
                Navigator.pushNamed(context, '/archives');
              },
            ),
            PopupMenuButton<String>(
              // Callback that sets the selected popup menu item.
              offset: Offset(3, 53),
              constraints: BoxConstraints(
                maxWidth: 120.0,
                maxHeight: 100.0,
              ),
              onSelected: (value) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'create',
                  child: Text('Create User'),
                ),
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit User'),
                ),
              ],
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.notification_add),
                text: 'Notifications',
              ),
              Tab(
                icon: Icon(Icons.question_mark),
                text: 'Requests',
              ),
              Tab(
                icon: Icon(Icons.change_circle),
                text: 'Relocated',
              ),
              Tab(
                icon: Icon(Icons.archive),
                text: 'Archives',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(),
            // Center(child: Text('title will be listed here')),
            // Center(child: Text('title will be listed here')),
            // Center(child: Text('title will be listed here')),
            // Center(child: Text('title will be listed here')),
          ],
        ),
      ),
    );
  }
}
