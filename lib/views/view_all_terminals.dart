// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllTerminals extends StatefulWidget {
  const AllTerminals({Key? key}) : super(key: key);

  @override
  State<AllTerminals> createState() => _AllTerminalsState();
}

class _AllTerminalsState extends State<AllTerminals> {
  List<String> merchantsList = [];

  _AllTerminalsState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('location')
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
                if (!merchantsList.contains(termName)) {
                  merchantsList.add(termName!);
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                    child: _tableData(snapshot.data?.docs[index]),
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

  Widget _tableData(docSnapshot) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'TID',
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18.0),
          ),
        ),
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18.0),
          ),
        ),
        DataColumn(
          label: Text(
            'Merchant',
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18.0),
          ),
        ),
        DataColumn(
          label: Text(
            'District',
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18.0),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(docSnapshot['term-id'].toString())),
            DataCell(Text(docSnapshot['term-name'].toString())),
            DataCell(Text(docSnapshot['merch-name'].toString())),
            DataCell(Text(docSnapshot['district'].toString())),
          ],
        ),
      ],
    );
  }
}
