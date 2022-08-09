// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_function_type_syntax_for_parameters, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(MaterialApp(home: _ChartApp()));
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Online', 80),
      _ChartData('Offline', 40),
      // _ChartData('RUS', 30),
      // _ChartData('BRZ', 6.4),
      // _ChartData('IND', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POSTMS Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
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
            CustomPieChart(tooltip: _tooltip, data: data),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomContainer(icon: Icons.home, title: '800 Merchants'),
                CustomContainer(
                    icon: Icons.phone_android, title: '1230 Terminals'),
              ],
            ),
            Container(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomContainer(icon: Icons.archive, title: '20 Archived'),
                CustomContainer(icon: Icons.wifi, title: '1210 Working'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPieChart extends StatelessWidget {
  const CustomPieChart({
    Key? key,
    required TooltipBehavior tooltip,
    required this.data,
  })  : _tooltip = tooltip,
        super(key: key);

  final TooltipBehavior _tooltip;
  final List<_ChartData> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: SfCircularChart(
        tooltipBehavior: _tooltip,
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Container(
              child: const Text(
                '62%',
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            isResponsive: true,
            orientation: LegendItemOrientation.auto),
        series: <CircularSeries<_ChartData, String>>[
          DoughnutSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (_ChartData data, _) => data.label,
            yValueMapper: (_ChartData data, _) => data.amount,
            innerRadius: '60%',
            radius: '60%',
            name: 'Status',
            explode: true,
            explodeIndex: 1,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final IconData icon;

  CustomContainer({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 204, 214, 226),
        border: Border.all(
          color: Color.fromARGB(255, 204, 214, 226),
          width: 8,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              icon,
              color: Colors.blue,
            ),
            iconSize: 40,
          ),
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(
    this.label,
    this.amount,
  );

  final String label;
  final double amount;
}
