// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/edit_terminal.dart';
import 'package:pos_tracker/views/landing_page.dart';
import 'package:pos_tracker/views/terminal_location.dart';

class ThisTerminal extends StatefulWidget {
  final String merchantName;
  final String distName;
  final String termName;
  final MyUser myUser;
  const ThisTerminal(
      {Key? key,
      required this.merchantName,
      required this.distName,
      required this.termName,
      required this.myUser})
      : super(key: key);
  @override
  State<ThisTerminal> createState() =>
      _ThisTerminalState(merchantName, distName, termName, myUser);
}

class _ThisTerminalState extends State<ThisTerminal> {
  String? docId;
  final String merchantName;
  final String districtName;
  final String termName;
  final MyUser myUser;
  List<String> terminalsList = [];

  _ThisTerminalState(
      this.merchantName, this.districtName, this.termName, this.myUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            tooltip: 'View in map',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyMap(docId!)));
            },
          ),
        ],
        title: Text('$merchantName | $termName'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('location')
              .where("term-name", isEqualTo: termName)
              .get()
              .asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                String? termName =
                    snapshot.data?.docs[index]['term-name'].toString();

                docId = snapshot.data?.docs[index].id;

                if (!terminalsList.contains(termName)) {
                  terminalsList.add(termName!);
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
                            _terminalInfo(
                                snapshot, index, 'District', 'district'),
                            _terminalInfo(
                                snapshot, index, 'Branch Name', 'branch-name'),
                            _terminalInfo(
                                snapshot, index, 'Branch ID', 'branch-id'),
                            _terminalInfo(
                                snapshot, index, 'Merchant Name', 'merch-name'),
                            _terminalInfo(
                                snapshot, index, 'Merchant ID', 'merch-id'),
                            _terminalInfo(
                                snapshot, index, 'Terminal Name', 'term-name'),
                            _terminalInfo(
                                snapshot, index, 'Terminal ID', 'term-id'),
                            _terminalInfo(snapshot, index, 'Date Created',
                                'date-created'),
                          ],
                        ),
                        Divider(
                          thickness: 2.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blueGrey),
                              ),
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => EditTerminal(
                                //         docId: snapshot.data!.docs[index].id)));
                              },
                              child: Text(
                                'Relocate',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.orange),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditTerminal(
                                        myUser: myUser,
                                        docId: snapshot.data!.docs[index].id)));
                              },
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: () {
                                _comfirmationDialog(
                                    context,
                                    'Do you want to archive this terminal?',
                                    'After this process you can only find this terminal under archives page.');
                              },
                              child: Text(
                                'Archive',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

  CollectionReference terminals =
      FirebaseFirestore.instance.collection('location');
  final dateMap = <String, dynamic>{
    "date-archived": DateFormat('yMd').format(DateTime.now()),
  };
  var data;

  Future<void> _archiveTerminal() async {
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
    data['isRelocated'] = 'false';

    print('*******this is data-2 $data');
    await FirebaseFirestore.instance
        .collection("archives")
        .doc(docId)
        .set(data)
        .whenComplete(() {
      terminals.doc(docId).delete().then((value) {
        _showDialog(context, 'Terminal archived successfully');
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyTracker(myUser: myUser)));
        });
      }).catchError((error) {
        _showDialog(context, "Failed to archive terminal: $error");
      });
    });
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
              _archiveTerminal();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  TableRow _terminalInfo(snapshot, index, labelText, rawName) {
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
          snapshot.data!.docs[index][rawName].toString(),
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
