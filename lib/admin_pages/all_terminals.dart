// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:pos_tracker/model/terminal.dart';

class ViewAllTerminals extends StatefulWidget {
  final List<Terminal> terminalsList;
  final String pageTitle;
  const ViewAllTerminals(
      {Key? key, required this.terminalsList, required this.pageTitle})
      : super(key: key);

  @override
  State<ViewAllTerminals> createState() =>
      _ViewAllTerminalsState(terminalsList, pageTitle);
}

class _ViewAllTerminalsState extends State<ViewAllTerminals> {
  final List<Terminal> terminalsList;
  final String pageTitle;

  _ViewAllTerminalsState(this.terminalsList, this.pageTitle);

  Widget _createDataTable(List<Terminal> list) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: DataTable(columns: _createColumns(), rows: _createRows(list)),
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

  List<DataRow> _createRows(List<Terminal> list) {
    return list
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
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: _createDataTable(terminalsList),
    );
  }
}
