// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pos_tracker/model/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomPieChart extends StatelessWidget {
  const CustomPieChart({
    Key? key,
    required TooltipBehavior tooltip,
    required this.data,
  })  : _tooltip = tooltip,
        super(key: key);

  final TooltipBehavior _tooltip;
  final List<ChartData> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: SfCircularChart(
        tooltipBehavior: _tooltip,
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            // ignore: avoid_unnecessary_containers
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
          orientation: LegendItemOrientation.auto,
          iconHeight: 10.0
        ),
        series: <CircularSeries<ChartData, String>>[
          DoughnutSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.label,
            yValueMapper: (ChartData data, _) => data.amount,
            innerRadius: '60%',
            radius: '80%',
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
