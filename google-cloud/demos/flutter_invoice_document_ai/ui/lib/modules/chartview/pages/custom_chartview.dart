import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = false,
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
            Text(text),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Column(children: indicators),
            ],
          ),
        ),
        Expanded(child: chart),
      ],
    );
  }
}
