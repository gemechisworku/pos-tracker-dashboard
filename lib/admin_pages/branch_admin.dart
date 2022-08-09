// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, no_logic_in_create_state, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/edit_user.dart';
import 'package:pos_tracker/views/login_page.dart';
import 'package:pos_tracker/views/merchant_terminals.dart';
import 'package:pos_tracker/views/register_user.dart';

class BranchAdminView extends StatefulWidget {
  final MyUser myUser;

  const BranchAdminView({super.key, required this.myUser});
  @override
  State<BranchAdminView> createState() => _BranchAdminViewState(myUser);
}

class _BranchAdminViewState extends State<BranchAdminView> {
  final MyUser myUser;
  List<String> typeList = ['Select workplace','Branch'];
  List<String> tempList = [];
  List<String> merchantsList = [];

  _BranchAdminViewState(this.myUser);

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _getMerchants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            tooltip: 'View in map',
            onPressed: () {},
          ),
          SizedBox(width: 20.0),
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
                          builder: (context) => UserRegistration(userTypes: typeList, myUser: myUser,)));
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
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  child: Text(
                    'TID',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 90,
                  child: Text('Name',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 100,
                  child: Text('Merchant',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 100,
                  child: Text('District',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 2.0,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('location')
                  .where('branch-name', isEqualTo: myUser.branch)
                  .get()
                  .asStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        _rowColumn(snapshot, index, 'term-id', 60.0),
                        _rowColumn(snapshot, index, 'term-name', 90.0),
                        _rowColumn(snapshot, index, 'merch-name', 100.0),
                        _rowColumn(snapshot, index, 'district', 100.0),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        width: 240.0,
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
            for (var merchant in merchantsList) _drawerItems(merchant),
          ],
        ),
      ),
    );
  }

  Widget _headerImage() {
    return ClipOval(
      child: Material(
        // color: Colors.transparent,
        child: Container(
          height: 85,
          width: 150,
          child: InkWell(
            child: Image.asset('assets/images/postms.png'),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Widget _rowColumn(snapshot, index, fieldName, width) {
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Text(snapshot.data!.docs[index][fieldName].toString()),
          ),
          Divider(
            thickness: 1.0,
          ),
        ],
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
              builder: (context) => MerchantTerminal(
                  merchantName: item, distName: myUser.district, myUser: myUser,)));
        },
      ),
    );
  }

  _getMerchants() async {
    tempList = await FirebaseFirestore.instance
        .collection('location')
        .where('branch-name', isEqualTo: myUser.branch)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            if (!tempList.contains(doc['merch-name'])) {
              tempList.add(doc["merch-name"]);
            }
          },
        );
        return tempList;
      },
    );

    setState(() {
      merchantsList = tempList;
    });
    print(merchantsList.length);
    return merchantsList;
  }
}
