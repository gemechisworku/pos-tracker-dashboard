// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, no_logic_in_create_state

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_tracker/admin_pages/all_terminals.dart';
import 'package:pos_tracker/constants.dart';
import 'package:pos_tracker/model/chart_data.dart';
import 'package:pos_tracker/model/district.dart';
import 'package:pos_tracker/model/terminal.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/services/database_service.dart';
import 'package:pos_tracker/views/district_merchants.dart';
import 'package:pos_tracker/views/edit_user.dart';
import 'package:pos_tracker/views/login_page.dart';
import 'package:pos_tracker/views/register_user.dart';
import 'package:pos_tracker/views/view_archived_terminal.dart';
import 'package:pos_tracker/widgets/custom_container.dart';
import 'package:pos_tracker/widgets/custom_pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyTracker extends StatefulWidget {
  final MyUser myUser;

  const MyTracker({super.key, required this.myUser});
  @override
  State<MyTracker> createState() => _MyTrackerState(myUser);
}

class _MyTrackerState extends State<MyTracker> {
  Widget? home;
  final MyUser myUser;
  List<String> userTypes = [
    'Select workplace',
    'Head office',
    'District',
    'Branch',
    'Guest'
  ];
  List<String> districtList = [];

  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  DatabaseServiceClass service = DatabaseServiceClass();
  Future<List<Terminal>>? terminalsList;
  List<Terminal> retrievedTerminalsList = [];
  Future<List<Terminal>>? archivedTerminalsList;
  List<Terminal> retrievedArchivedTerminalsList = [];
  List<String> merchantsList = [];

  _MyTrackerState(this.myUser);

  @override
  void initState() {
    super.initState();
    _initRetrieval();
    _initArchivedRetrieval();
    _initDistrictRetrieval();
    data = [
      ChartData('Online', 80),
      ChartData('Offline', 40),
    ];
    _tooltip = TooltipBehavior(enable: true);
    home = customTab();
  }

  Future<void> _initRetrieval() async {
    terminalsList = service.retrieveTerminals();
    retrievedTerminalsList = await service.retrieveTerminals();
  }

  Future<void> _initDistrictRetrieval() async {
    districtList = await service.readDistricts();
  }

  Future<void> _initArchivedRetrieval() async {
    archivedTerminalsList = service.retrieveArchivedTerminals();
    retrievedArchivedTerminalsList = await service.retrieveArchivedTerminals();
    for (var terminal in retrievedArchivedTerminalsList) {
      if (!merchantsList.contains(terminal.merchName)) {
        setState(() {
          merchantsList.add(terminal.merchName);
        });
      }
    }
  }

  FutureBuilder<List<Terminal>> customFutureBuilder(
      list, retrievedList, iconData, title, onPressed) {
    return FutureBuilder(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List<Terminal>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return CustomContainer(
            icon: iconData,
            title: '${retrievedList.length} $title',
            onPressed: onPressed,
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _createDataTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(columns: _createColumns(), rows: _createRows()),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('TID')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Merchant')),
      DataColumn(label: Text('District')),
    ];
  }

  List<DataRow> _createRows() {
    return retrievedArchivedTerminalsList
        .map((terminal) => DataRow(cells: [
              DataCell(Text(terminal.termId)),
              DataCell(Text(terminal.termName)),
              DataCell(Text(terminal.merchName)),
              DataCell(Text(terminal.district)),
            ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // _getStreams();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: customAppBar(context),
          body: TabBarView(
            children: [
              customTab(),
              _createDataTable(),
              _createDataTable(),
              _archivedTerminals(),
              _archivedTerminals(),
            ],
          ),
          drawer: customDrawer(context)),
    );
  }

  Drawer customDrawer(BuildContext context) {
    return Drawer(
      width: 250.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                _headerImage(),
                SizedBox(height: 0.0),
                Row(
                  children: [
                    Text(
                      'User: ${myUser.username}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 20.0),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      tooltip: 'logout',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          for (var district in districtList) _drawerItems(district),
        ],
      ),
    );
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      elevation: 15,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.location_on_outlined),
          tooltip: 'View in map',
          onPressed: () {},
        ),
        PopupMenuButton<String>(
            // Callback that sets the selected popup menu item.
            offset: Offset(3, 53),
            constraints: BoxConstraints(
              maxWidth: 120.0,
              maxHeight: 100.0,
            ),
            onSelected: (value) {
              setState(() {
                if (value == 'create') {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserRegistration(
                              userTypes: userTypes,
                              myUser: myUser,
                            )));
                  });
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditUSer()));
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'create',
                    child: Text('Create User'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit User'),
                  ),
                ])
      ],
      title: const Text('COOPTMS'),
      bottom: TabBar(isScrollable: true, tabs: [
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
      ]),
    );
  }

  Widget _archivedAndRelocatedTabs(title) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(title).get().asStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          controller: ScrollController(),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final String? docId = snapshot.data?.docs[index].id;
            return Card(
              child: ListTile(
                trailing: const Icon(Icons.more),
                title: Text(snapshot.data!.docs[index]['term-name'].toString()),
                subtitle: Text(
                    '${snapshot.data!.docs[index]['date-created'].toString()} - ${snapshot.data!.docs[index]['date-archived'].toString()}'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ArchivedTerminal(myUser: myUser, docId: docId)));
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _archivedTerminals() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          for (var terminal in retrievedArchivedTerminalsList)
            Card(
              child: ListTile(
                trailing: const Icon(Icons.more),
                title: Text(terminal.termName),
                subtitle:
                    Text('${terminal.dateCreated} - ${terminal.dateArchived}'),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         ArchivedTerminal(myUser: myUser, docId: docId)));
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget customTab() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 204, 214, 226),
                border: Border.all(
                  color: Color.fromARGB(255, 204, 214, 226),
                  width: 8,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Overall Info'),
            ),
          ),
          Container(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              customFutureBuilder(
                terminalsList,
                retrievedTerminalsList,
                Icons.phone_android,
                'Active',
                () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewAllTerminals(
                              terminalsList: retrievedTerminalsList,
                              pageTitle: 'Active Terminals',
                            )));
                  });
                },
              ),
              customFutureBuilder(
                archivedTerminalsList,
                retrievedArchivedTerminalsList,
                Icons.phone_android,
                'Archived',
                () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewAllTerminals(
                              terminalsList: retrievedArchivedTerminalsList,
                              pageTitle: 'Archived Terminals',
                            )));
                  });
                },
              )
            ],
          ),
          Container(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomContainer(
                title: '${merchantsList.length} Merchants',
                icon: Icons.home,
                onPressed: () {},
              ),
              CustomContainer(
                title: '${merchantsList.length} Branchs',
                icon: Icons.home,
                onPressed: () {},
              ),
            ],
          ),
          Container(
            width: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomPieChart(tooltip: _tooltip, data: data),
              Container(
                width: 80,
              ),
            ],
          ),
          _createDataTable(),
          _createDataTable(),
        ],
      ),
    );
  }

  Widget _headerImage() {
    return ClipOval(
      child: Material(
        // color: Colors.transparent,
        child: Container(
          height: 75,
          width: 150,
          child: InkWell(
            child: Image.asset('assets/images/postms.png'),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Widget _drawerItems(item) {
    return Card(
      child: ListTile(
        trailing: const Icon(Icons.arrow_right),
        title: Text(item),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Merchant(merchant: item, myUser: myUser)));
        },
      ),
    );
  }

  // readDistricts() async {
  //   final districts = FirebaseFirestore.instance
  //       .collection('district-collection')
  //       .doc('district-document')
  //       .withConverter(
  //           fromFirestore: District.fromFirestore,
  //           toFirestore: (District district, _) => district.toFirestore());

  //   final docSnapshot = await districts.get();
  //   final dicList = docSnapshot.data()!.districts!;
  //   setState(() {
  //     districtList = dicList;
  //   });

  //   print(districtList);
  // }
}
