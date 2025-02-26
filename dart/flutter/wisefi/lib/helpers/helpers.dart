// Charting helpers
import 'package:flutter/material.dart';

class ChartData {
  final DateTime time;
  final double value;
  final String? category;

  ChartData(this.time, this.value, {this.category});
}

class PieData {
  final String category;
  final double value;
  final String label;
  final Color color;

  PieData(this.category, this.value, this.label, this.color);
}
