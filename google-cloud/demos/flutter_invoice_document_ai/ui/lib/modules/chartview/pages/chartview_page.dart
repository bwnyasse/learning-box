import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../utils/utils.dart' as utils;
import '../../invoices/invoices_service.dart';
import 'custom_chartview.dart';

InvoicesService get invoicesService => Modular.get<InvoicesService>();

class ChartViewPage extends StatefulWidget {
  static const String routeKey = 'chartview';
  const ChartViewPage({super.key});

  @override
  State<ChartViewPage> createState() => _ChartViewPageState();
}

class _ChartViewPageState extends State<ChartViewPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Breakdown'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: CustomChartWidget(
        title: 'Breakdown per categories',
        indicators: [
          for (var entry in invoicesService.totalPerCategory.entries)
            Indicator(
              color:
                  entry.value.color, // Use the color from the Category object
              text: "${entry.key} : ${entry.value.value}", // Use the category name as text
              isSquare: true,
            ),
        ],
        chart: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(show: false),
            sectionsSpace: -0,
            centerSpaceRadius: 100,
            sections: utils.convertToPieChartData(
                invoicesService.totalPerCategory, touchedIndex),
          ),
        ),
      ),
    );
  }
}
