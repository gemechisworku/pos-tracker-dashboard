// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/view_terminal.dart';

class EditTerminal extends StatefulWidget {
  final String docId;
  final MyUser myUser;
  const EditTerminal({super.key, required this.docId, required this.myUser});

  @override
  State<EditTerminal> createState() => _EditTerminalState(docId, myUser);
}

class _EditTerminalState extends State<EditTerminal> {
  final loc.Location location = loc.Location();
  final String docId;
  final MyUser myUser;

  List<String> districts = ['select district'];

  final termNameController = TextEditingController();
  final termIdController = TextEditingController();
  final merchIdController = TextEditingController();
  final branchNameController = TextEditingController();
  final merchNameController = TextEditingController();
  final branchIdController = TextEditingController();
  final districtController = TextEditingController();

  String? districtName;
  _EditTerminalState(this.docId, this.myUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Terminal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('location')
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
                districtName = snapshot.data!['district'];
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      _textFormField(districtController, 'District',
                          snapshot.data!['district'], true),
                      _textFormField(branchNameController, 'Branch Name',
                          snapshot.data!['branch-name'], true),
                      _textFormField(branchIdController, 'Branch ID',
                          snapshot.data!['branch-id'], true),
                      _textFormField(merchNameController, 'Merchant Name',
                          snapshot.data!['merch-name'], false),
                      _textFormField(merchIdController, 'Merchant ID',
                          snapshot.data!['merch-id'], false),
                      _textFormField(termNameController, 'Terminal Name',
                          snapshot.data!['term-name'], false),
                      _textFormField(termIdController, 'Terminal ID',
                          snapshot.data!['term-id'], false),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: registerPOSButton,
                            onPressed: () {
                              _updatePos(docId);
                            },
                            child: Text('Submit'),
                          ),
                          SizedBox(width: 30.0),
                          ElevatedButton(
                            style: registerPOSButton,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ThisTerminal(
                                        myUser: myUser,
                                        merchantName: merchNameController.text,
                                        distName: districtName!,
                                        termName: termNameController.text,
                                      )));
                            },
                            child: Text('View Info'),
                          ),
                        ],
                      ),
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

  final ButtonStyle registerPOSButton = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  );

  TextFormField _textFormField(controller, labelString, textFill, isReadOnly) {
    controller.text = textFill;
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: labelString,
      ),
      onSaved: (value) {
        controller.text = value!;
      },
      controller: controller,
      readOnly: isReadOnly,
    );
  }

  _updatePos(documentId) async {
    print(documentId);
    try {
      await FirebaseFirestore.instance
          .collection('location')
          .doc(documentId)
          .set({
        'merch-name': merchNameController.text,
        'merch-id': merchIdController.text,
        'term-name': termNameController.text,
        'term-id': termIdController.text,
      }, SetOptions(merge: true));
      _showDialog(context, 'Terminal updated successfully!');
    } catch (e) {
      print(e);
      _showDialog(context, 'update failed');
    }
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
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ThisTerminal(
                    myUser: myUser,
                    merchantName: merchNameController.text,
                    distName: districtName!,
                    termName: termNameController.text,
                  ),
                ),
              );
            },
            child: Text('View'),
          ),
        ],
      ),
    );
  }
}
