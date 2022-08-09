// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:pos_tracker/model/chart_data.dart';
import 'package:pos_tracker/model/terminal.dart';
import 'package:pos_tracker/services/database_service.dart';
import 'package:pos_tracker/widgets/custom_container.dart';
import 'package:pos_tracker/widgets/custom_pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeadOfficeDashboardScreen extends StatefulWidget {
  const HeadOfficeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HeadOfficeDashboardScreen> createState() =>
      _HeadOfficeDashboardScreenState();
}

class _HeadOfficeDashboardScreenState extends State<HeadOfficeDashboardScreen> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  DatabaseServiceClass service = DatabaseServiceClass();
  Future<List<Terminal>>? terminalsList;
  List<Terminal> retrievedTerminalsList = [];
  Future<List<Terminal>>? archivedTerminalsList;
  List<Terminal> retrievedArchivedTerminalsList = [];
  List<String> merchantsList = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();
    _initArchivedRetrieval();
    data = [
      ChartData('Online', 80),
      ChartData('Offline', 40),
    ];
    _tooltip = TooltipBehavior(enable: true);
  }

  Future<void> _initRetrieval() async {
    terminalsList = service.retrieveTerminals();
    retrievedTerminalsList = await service.retrieveTerminals();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(floating: true),
            Container(
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
            Container(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                customFutureBuilder(terminalsList, retrievedTerminalsList,
                    Icons.phone_android, 'Working'),
                customFutureBuilder(
                    archivedTerminalsList,
                    retrievedArchivedTerminalsList,
                    Icons.phone_android,
                    'Archived')
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
                  title: '${merchantsList.length} Merchants',
                  icon: Icons.home,
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              width: 30,
            ),
            CustomPieChart(tooltip: _tooltip, data: data),
            _createDataTable(),
            _createDataTable(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Terminal>> customFutureBuilder(
      list, retrievedList, iconData, title) {
    return FutureBuilder(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List<Terminal>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return CustomContainer(
            icon: iconData,
            title: '${retrievedList.length} $title',
            onPressed: () {},
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
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
}
