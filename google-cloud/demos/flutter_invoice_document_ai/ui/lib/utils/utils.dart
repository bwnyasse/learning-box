import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../modules/invoices/models/invoice_models.dart';

// 1. Data Conversion Functions
//
//

List<BarChartGroupData> convertToBarChartData(Map<String, double> data) {
  final List<BarChartGroupData> barGroups = [];
  final colors = [
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.green
  ]; // Color palette
  int barIndex = 0;

  data.forEach((key, value) {
    final color = colors[barIndex % colors.length];
    barGroups.add(
      BarChartGroupData(
        x: barIndex, // x-axis position of the bar
        barRods: [
          BarChartRodData(
            toY: value,
            color: color,
            width: 22, // Width of the bar
          ),
        ],
      ),
    );
    barIndex++;
  });

  return barGroups;
}

List<PieChartSectionData> convertToPieChartData(Map<String, Category> data, int touchedIndex) {
  final total = data.values.fold(0.0, (sum, category) => sum + category.value);

  return List.generate(data.length, (i) {
    final entry = data.entries.elementAt(i);
    final category = entry.value;
    final percentage = ((category.value / total) * 100).toStringAsFixed(1);

    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 80.0 : 50.0;

    return PieChartSectionData(
      color: category.color, // Use the color from the Category object
      value: category.value,
      title: '$percentage%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  });
}




Color getRandomColor() {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
    1, // Alpha
  );
}