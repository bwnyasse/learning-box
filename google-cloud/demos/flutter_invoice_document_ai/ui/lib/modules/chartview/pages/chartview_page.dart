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
        indicators: List.generate(invoicesService.totalPerCategory.length, (i) {
          final entry = invoicesService.totalPerCategory.entries.elementAt(i);
          final isTouched =
              i == touchedIndex; // Check if the current index is touched
          final fontSize =
              isTouched ? 14.0 : 12.0; // Increase font size if touched
          final fontBold=
              isTouched ? FontWeight.bold : FontWeight.normal; 
          return Indicator(
            color: entry.value.color, // Use the color from the Category object
            text:
                "${entry.key} : ${entry.value.value}", // Use the category name and value as text
            textStyle: TextStyle(
              fontSize: fontSize, // Set the dynamic font size
              fontWeight: fontBold,
            ),
            isSquare: true,
          );
        }),
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
