// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/landing_page.dart';
import 'package:pos_tracker/views/terminal_location.dart';

class ArchivedTerminal extends StatefulWidget {
  final String? docId;
  final MyUser myUser;
  const ArchivedTerminal({Key? key, required this.myUser, required this.docId})
      : super(key: key);
  @override
  State<ArchivedTerminal> createState() =>
      _ArchivedTerminalState(myUser, docId!);
}

class _ArchivedTerminalState extends State<ArchivedTerminal> {
  final String docId;
  final MyUser myUser;
  List<String> terminalsList = [];

  _ArchivedTerminalState(this.myUser, this.docId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Terminal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('archives')
              .doc(docId)
              .get()
              .asStream(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                String relocated = snapshot.data!['isRelocated'].toString();
                bool isRelocated = true;
                if (relocated != 'true') {
                  isRelocated = false;
                }
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder(
                            horizontalInside: BorderSide(
                          width: 1,
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        )),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(30),
                          1: FlexColumnWidth(10),
                          2: FixedColumnWidth(120),
                        },
                        children: [
                          _terminalInfo(snapshot, 'District', 'district'),
                          _terminalInfo(snapshot, 'Branch Name', 'branch-name'),
                          _terminalInfo(snapshot, 'Branch ID', 'branch-id'),
                          _terminalInfo(
                              snapshot, 'Merchant Name', 'merch-name'),
                          _terminalInfo(snapshot, 'Merchant ID', 'merch-id'),
                          _terminalInfo(snapshot, 'Terminal Name', 'term-name'),
                          _terminalInfo(snapshot, 'Terminal ID', 'term-id'),
                          _terminalInfo(
                              snapshot, 'Date Created', 'date-created'),
                          _terminalInfo(
                              snapshot, 'Date Archived', 'date-archived'),
                        ],
                      ),
                      Divider(
                        thickness: 2.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isRelocated
                          ? _customButton('Relocated', '', Colors.grey)
                          : _customButton('Relocate', '', Colors.blueGrey)
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  CollectionReference terminals =
      FirebaseFirestore.instance.collection('location');
  final dateMap = <String, dynamic>{
    "date-archived": DateFormat('yMd').format(DateTime.now()),
  };
  var data;

  Future<void> _relocateTerminal() async {
    final docRef = FirebaseFirestore.instance.collection("location").doc(docId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        setState(() {
          data = doc.data() as Map<String, dynamic>;
          print('*******this is data-1 $data');
        });
      },
      onError: (e) => _showDialog(context, "Error getting document: $e"),
    );
    data['date-archived'] = DateFormat('yMd').format(DateTime.now());
    data['date-relocated'] = DateFormat('yMd').format(DateTime.now());


    print('*******this is data-2 $data');
    await FirebaseFirestore.instance
        .collection("archives")
        .doc(docId)
        .set(data)
        .whenComplete(() {
      terminals.doc(docId).delete().then((value) {
        FirebaseFirestore.instance.collection("relocated").doc(docId).set(data);
        _showDialog(context, 'Terminal relocated successfully');
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyTracker(myUser: myUser)));
        });
      }).catchError((error) {
        _showDialog(context, "Failed to archive terminal: $error");
      });
    });

  }

  Widget _customButton(title, path, style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(style),
          ),
          onPressed: () {
            if (path != '') {}
          },
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showDialog(BuildContext context, msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _comfirmationDialog(BuildContext context, title, msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _relocateTerminal();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  TableRow _terminalInfo(snapshot, labelText, rawName) {
    return TableRow(
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          snapshot.data![rawName].toString(),
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
