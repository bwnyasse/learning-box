import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final TextStyle textStyle;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = false,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Container(
              width: isSquare ? 32 : 24,
              height: isSquare ? 32 : 24,
              decoration: BoxDecoration(
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class CustomChartWidget extends StatelessWidget {
  final String title;
  final List<Indicator> indicators;
  final Widget chart;

  const CustomChartWidget({
    super.key,
    required this.title,
    required this.indicators,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container for Indicators
        Expanded(
          flex: 1, // Adjust flex ratio as needed
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                ...indicators,
              ],
            ),
          ),
        ),

        // Container for Chart
        Expanded(
          flex: 2, // Adjust flex ratio as needed
          child: chart,
        ),
      ],
    );
  }
}
