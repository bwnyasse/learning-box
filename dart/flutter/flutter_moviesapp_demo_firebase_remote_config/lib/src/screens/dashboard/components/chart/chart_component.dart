import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../models/models.dart';

import '../../../../constants.dart';

class ChartComponent extends StatelessWidget {
  final List<GenreInfo> genresInfo;
  const ChartComponent({
    Key? key,
    required this.genresInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: [
                for (GenreInfo info in genresInfo)
                  PieChartSectionData(
                    color: info.color,
                    value: info.percentage.toDouble(),
                    showTitle: false,
                    radius: 25,
                  ),
              ],
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  "Genres",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                const Text("of Movies")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
