// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/view_terminal.dart';

class MerchantTerminal extends StatefulWidget {
  final String merchantName;
  final MyUser myUser;
  final String distName;
  const MerchantTerminal(
      {Key? key, required this.merchantName, required this.distName, required this.myUser})
      : super(key: key);
  @override
  State<MerchantTerminal> createState() =>
      _MerchantTerminalState(merchantName, distName, myUser);
}

class _MerchantTerminalState extends State<MerchantTerminal> {
  final String merchantName;
  final String districtName;
  final MyUser myUser;
  List<String> merchantsList = [];

  _MerchantTerminalState(this.merchantName, this.districtName, this.myUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$districtName | $merchantName | Terminals'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('location')
              .where("merch-name", isEqualTo: merchantName)
              .get()
              .asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  semanticsValue: 'Loading please wait...',
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                print(
                    'doc Id: ${snapshot.data?.docs[index].id}');
                String? termName =
                    snapshot.data?.docs[index]['term-name'].toString();
                if (!merchantsList.contains(termName)) {
                  merchantsList.add(termName!);
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                    child: _terminalsList(termName),
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _terminalsList(termName) {
    return Card(
      child: ListTile(
        trailing: const Icon(Icons.arrow_right),
        title: Text(termName),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ThisTerminal(myUser: myUser,merchantName: merchantName, distName: districtName, termName: termName,)));
        },
      ),
    );
  }
}
